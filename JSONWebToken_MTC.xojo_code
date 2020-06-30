#tag Class
Protected Class JSONWebToken_MTC
	#tag Method, Flags = &h0
		Sub Constructor(claimValues As Dictionary = Nil, headerValues As Dictionary = Nil)
		  if headerValues is nil then
		    Header = ParseJSON( "{}" )
		  end if
		  
		  if claimValues is nil then
		    Claim = ParseJSON( "{}" )
		  end if
		  
		  LoadValues claimValues, headerValues
		  
		  if not Header.HasKey( kKeyType ) then
		    Header.Value( kKeyType ) = kTypeJWT
		  end if
		  
		  dim nowSecs as Int64 = DateTime.Now.SecondsFrom1970
		  
		  dim issuedAt as Int64 = Claim.Lookup( kKeyIssuedAt, nowSecs )
		  dim expiresAt as Int64 = Claim.Lookup( kKeyExpiration, nowSecs )
		  ExpirationSeconds = expiresAt - issuedAt
		  if ExpirationSeconds < 0 then
		    ExpirationSeconds = 0
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Decode(token As String) As JSONWebToken_MTC
		  //
		  // Decodes the data without regard to signature, but performs content validation
		  //
		  
		  dim result as new JSONWebToken_MTC
		  if DecodeInto( result, token ) = false then
		    result = nil
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function DecodeBase64URL(value As String, encoding As TextEncoding = Nil) As String
		  if value = "" then
		    return value
		  end if
		  
		  value = value.ReplaceAllB( "-", "+" )
		  value = value.ReplaceAllB( "_", "/" )
		  
		  //
		  // The native decoder doesn't care about the padding ("=") so
		  // we don't have to bother putting it back in
		  //
		  
		  dim result as string = DecodeBase64( value, encoding )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function DecodeInto(result As JSONWebToken_MTC, token As String) As Boolean
		  //
		  // Decodes the data without regard to signature, but performs content validation
		  // Returns false only if the content did not validate, i.e., result was not filled
		  //
		  
		  if token = "" then
		    return false
		  end if
		  
		  token = ToUTF8( token )
		  
		  dim parts() as string = token.Split( "." )
		  if parts.Ubound = 0 or parts.Ubound > 2 then
		    return false
		  end if
		  
		  dim headerEncoded as string = parts( 0 )
		  dim claimEncoded as string = parts( 1 )
		  dim signatureEncoded as string = if( parts.Ubound = 2, parts( 2 ), "" )
		  
		  dim headerJSON as string = DecodeBase64URL( headerEncoded )
		  dim claimJSON as string = DecodeBase64URL( claimEncoded )
		  
		  //
		  // Start the validation
		  //
		  
		  if not Encodings.UTF8.IsValidData( headerJSON ) then
		    return false
		  end if
		  
		  headerJSON = ToUTF8( headerJSON )
		  claimJSON = ToUTF8( claimJSON )
		  
		  dim rxBadChars as new RegEx
		  rxBadChars.SearchPattern = "(?mi-Us)""(\\""|[^""])*""(*SKIP)(*FAIL)|(true|false|null)(*SKIP)(*FAIL)|(?:\d*\.)?\d+(*SKIP)(*FAIL)|[^:{[\]},]"
		  
		  if rxBadChars.Search( headerJSON ) isa RegExMatch or rxBadChars.Search( claimJSON ) isa RegExMatch then
		    return false
		  end if
		  
		  dim header as Dictionary = ParseJSON( headerJSON )
		  
		  if header.HasKey( kKeyType ) then
		    dim type as string = header.Value( kKeyType )
		    if StrComp( type, kTypeJWT, 0 ) <> 0 then
		      return false
		    end if
		  end if
		  
		  //
		  // Create it
		  //
		  if claimJSON = "" then
		    claimJSON = "{}"
		  end if
		  dim claim as Dictionary = ParseJSON( claimJSON )
		  
		  result.LoadValues claim, header
		  result.IncludeIssuedAt = claim.HasKey( kKeyIssuedAt )
		  result.mSignature = signatureEncoded
		  result.mLoadedSignaturePart = signatureEncoded
		  result.mLoadedDataPart = headerEncoded + "." + claimEncoded
		  result.mLoadedToken = token
		  
		  return true
		  
		  Exception err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    return false
		    
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function EncodeBase64URL(value As String) As String
		  if value = "" then
		    return value
		  end if
		  
		  dim result as string = EncodeBase64( value, -1 )
		  
		  result = result.ReplaceAllB( "+", "-" )
		  result = result.ReplaceAllB( "/", "_" )
		  
		  if result.RightB( 2 ) = "==" then
		    result = result.LeftB( result.LenB - 2 )
		  elseif result.RightB( 1 ) = "=" then
		    result = result.LeftB( result.LenB - 1 )
		  end if
		  
		  return result.DefineEncoding( Encodings.UTF8 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key As String) As Boolean
		  return Claim.HasKey( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadValues(claimValues As Dictionary, headerValues As Dictionary)
		  if claimValues isa object then
		    Claim = ParseJSON( GenerateJSON( claimValues ) )
		  end if
		  
		  if headerValues isa object then
		    Header = ParseJSON( GenerateJSON( headerValues ) )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(key As String, defaultValue As Variant) As Variant
		  return Claim.Lookup( key, defaultValue )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As String)
		  RemoveValue key, Claim
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveValue(key As String, json As Dictionary)
		  if json.HasKey( key ) then
		    json.Remove key
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToToken(algorithm As String, secretOrPrivateKey As String) As String
		  //
		  // Check parameters
		  //
		  if algorithm <> kAlgorithmNone and secretOrPrivateKey = "" then
		    dim err as new Xojo.Core.BadDataException
		    err.Message = "A secret or private key must be specified"
		    raise err
		  end if
		  
		  if algorithm = kAlgorithmNone and secretOrPrivateKey <> "" then
		    dim err as new Xojo.Core.BadDataException
		    err.Message = "Algorithm NONE with a secret or private key is contradictory"
		    raise err
		  end if
		  
		  dim nowSecs as Int64 = DateTime.Now.SecondsFrom1970
		  
		  self.Header.Value( kKeyAlgorithm ) = algorithm
		  
		  dim header as string = GenerateJSON( self.Header )
		  dim headerEncoded as string = EncodeBase64URL( header )
		  
		  dim claimJSON as Dictionary = RawClaim
		  
		  if ExpirationSeconds > 0 then
		    claimJSON.Value( kKeyExpiration ) = nowSecs + ExpirationSeconds
		  end if
		  
		  if IncludeIssuedAt then
		    claimJSON.Value( kKeyIssuedAt ) = nowSecs
		  else
		    RemoveValue kKeyIssuedAt, claimJSON
		  end if
		  
		  dim claim as string = GenerateJSON( claimJSON )
		  dim claimEncoded as string = EncodeBase64URL( claim )
		  
		  dim data as string = headerEncoded + "." + claimEncoded
		  dim signature as string
		  
		  select case algorithm
		  case kAlgorithmNone
		    //
		    // No signature verification
		    //
		    
		  case kAlgorithmHS256
		    signature = EncodeBase64URL( Crypto.HMAC( secretOrPrivateKey, data, Crypto.Algorithm.SHA256 ) )
		    
		  case kAlgorithmHS512
		    signature = EncodeBase64URL( Crypto.HMAC( secretOrPrivateKey, data, Crypto.Algorithm.SHA512 ) )
		    
		  case else
		    dim err as new Xojo.Core.BadDataException
		    err.Message = "Unknown algorithm " + algorithm
		    raise err
		    
		  end select
		  
		  mSignature = signature
		  dim token as string = data + if( signature <> "", "." + signature, "" )
		  return token
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ToUTF8(s As String) As String
		  if s = "" or s.Encoding = Encodings.UTF8 then
		    return s
		  end if
		  
		  if s.Encoding isa TextEncoding then
		    return s.ConvertEncoding( Encodings.UTF8 )
		  end if
		  
		  //
		  // It's nil
		  //
		  
		  if Encodings.UTF8.IsValidData( s ) then
		    return s.DefineEncoding( Encodings.UTF8 )
		  else
		    return s.DefineEncoding( Encodings.ISOLatin1 ) // Guessing
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Validate(token As String, secretOrPublicKey As String) As JSONWebToken_MTC
		  dim result as new JSONWebToken_MTC
		  if ValidateInto( result, token, secretOrPublicKey ) then
		    return result
		  else
		    return nil
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function ValidateInto(result As JSONWebToken_MTC, token As String, secretOrPublicKey As String) As Boolean
		  if DecodeInto( result, token ) = false then
		    return false
		  end if
		  
		  //
		  // Validate the signature
		  //
		  // Assumption is that a given secret or public keys means
		  // that a signature is expected
		  //
		  dim isSignatureRequired as boolean = secretOrPublicKey <> ""
		  
		  dim signature as string = DecodeBase64URL( result.LoadedSignaturePart )
		  if isSignatureRequired and signature = "" then
		    return false
		  end if
		  
		  dim compareSignature as string
		  
		  dim algorithm as string = result.Header.Lookup( kKeyAlgorithm, "" )
		  select case algorithm
		  case kAlgorithmNone
		    if signature <> "" then
		      //
		      // That doesn't make sense
		      //
		      return false
		    end if
		    
		  case kAlgorithmHS256
		    compareSignature = Crypto.HMAC( secretOrPublicKey, result.LoadedDataPart, Crypto.Algorithm.SHA256 )
		    
		  case kAlgorithmHS512
		    compareSignature = Crypto.HMAC( secretOrPublicKey, result.LoadedDataPart, Crypto.Algorithm.SHA512 )
		    
		  case else
		    //
		    // Unknown algorithm
		    //
		    return false
		  end select
		  
		  if StrComp( signature, compareSignature, 0 ) <> 0 then
		    return false
		  end if
		  
		  //
		  // Make sure it's current
		  //
		  if not result.IsCurrent then
		    return false
		  else
		    return true
		  end if
		  
		  Exception err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    return false
		    
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key As String) As Variant
		  return Claim.Value( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key As String, Assigns value As Variant)
		  Claim.Value( key ) = value
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Claim.Lookup( kKeyAudience, "" )
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim key as string = kKeyAudience
			  
			  if value = "" then
			    Remove key
			  else
			    Value( key ) = value
			  end if
			  
			End Set
		#tag EndSetter
		Audience As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Claim As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		ExpirationSeconds As Int64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Header As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		IncludeIssuedAt As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim nowSecs as Int64 = DateTime.Now.SecondsFrom1970
			  
			  if NotBeforeDate isa object and NotBeforeDate.SecondsFrom1970 > nowSecs then
			    return false
			  end if
			  
			  dim claim as Dictionary = self.Claim
			  
			  dim expireAt as Int64 = claim.Lookup( kKeyExpiration, nowSecs )
			  if expireAt < nowSecs then
			    return false
			  end if
			  
			  return true
			  
			End Get
		#tag EndGetter
		IsCurrent As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Claim.Lookup( kKeyIssuer, "" )
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim key as string = kKeyIssuer
			  
			  if value = "" then
			    Remove key
			  else
			    Value( key ) = value
			  end if
			  
			End Set
		#tag EndSetter
		Issuer As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Claim.Lookup( kKeyJWTId, "" )
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim key as string = kKeyJWTId
			  
			  if value = "" then
			    Remove key
			  else
			    Value( key ) = value
			  end if
			  
			End Set
		#tag EndSetter
		JWTId As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLoadedDataPart
			End Get
		#tag EndGetter
		LoadedDataPart As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim d as DateTime
			  dim claim as Dictionary = self.Claim
			  
			  if claim.HasKey( kKeyExpiration ) then
			    dim rawSecs as Int64 = claim.Value( kKeyExpiration )
			    d = new DateTime( rawSecs, Timezone.Current )
			  end if
			  
			  return d
			End Get
		#tag EndGetter
		LoadedExpiresAt As DateTime
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim d as DateTime
			  dim claim as Dictionary = self.Claim
			  
			  if claim.HasKey( kKeyIssuedAt ) then
			    dim rawSecs as Int64 = claim.Value( kKeyIssuedAt )
			    d = new DateTime( rawSecs, TimeZone.Current )
			  end if
			  
			  return d
			End Get
		#tag EndGetter
		LoadedIssuedAt As DateTime
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLoadedSignaturePart
			End Get
		#tag EndGetter
		LoadedSignaturePart As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mLoadedToken
			End Get
		#tag EndGetter
		LoadedToken As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mLoadedDataPart As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mLoadedSignaturePart As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mLoadedToken As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mSignature As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim d as DateTime
			  dim claim as Dictionary = self.Claim
			  
			  dim key as string = kKeyNotBefore
			  dim hasKey as boolean = claim.HasKey( key )
			  
			  if hasKey then
			    dim rawSecs as Int64 = claim.Value( key )
			    d = new DateTime( rawSecs, TimeZone.Current )
			  end if
			  
			  return d
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    Remove kKeyNotBefore
			  else
			    Value( kKeyNotBefore ) = value.SecondsFrom1970
			  end if
			End Set
		#tag EndSetter
		NotBeforeDate As DateTime
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if Claim is nil then
			    return ParseJSON( "{}" )
			  else
			    return ParseJSON( GenerateJSON( Claim ) )
			  end if
			End Get
		#tag EndGetter
		RawClaim As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if Header is nil then
			    return ParseJSON( "{}" )
			  else
			    return ParseJSON( GenerateJSON( Header ) )
			  end if
			  
			End Get
		#tag EndGetter
		RawHeader As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSignature
			End Get
		#tag EndGetter
		Signature As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Claim.Lookup( kKeySubject, "" )
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim key as string = kKeySubject
			  
			  if value = "" then
			    Remove key
			  else
			    Value( key ) = value
			  end if
			  
			End Set
		#tag EndSetter
		Subject As String
	#tag EndComputedProperty


	#tag Constant, Name = kAlgorithmHS256, Type = String, Dynamic = False, Default = \"HS256", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kAlgorithmHS512, Type = String, Dynamic = False, Default = \"HS512", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kAlgorithmNone, Type = String, Dynamic = False, Default = \"none", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kKeyAlgorithm, Type = String, Dynamic = False, Default = \"alg", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyAudience, Type = String, Dynamic = False, Default = \"aud", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyExpiration, Type = String, Dynamic = False, Default = \"exp", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyIssuedAt, Type = String, Dynamic = False, Default = \"iat", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyIssuer, Type = String, Dynamic = False, Default = \"iss", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyJWTId, Type = String, Dynamic = False, Default = \"jti", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyNotBefore, Type = String, Dynamic = False, Default = \"nbf", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeySubject, Type = String, Dynamic = False, Default = \"sub", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKeyType, Type = String, Dynamic = False, Default = \"typ", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kTypeJWT, Type = String, Dynamic = False, Default = \"JWT", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"4.2", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Audience"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ExpirationSeconds"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Int64"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeIssuedAt"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsCurrent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Issuer"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="JWTId"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedDataPart"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedSignaturePart"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LoadedToken"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Signature"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Subject"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
