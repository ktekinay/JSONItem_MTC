#tag Class
Protected Class JSONItem_MTC
	#tag Method, Flags = &h21
		Private Sub AdvancePastWhiteSpace(inMB As MemoryBlock, ByRef pos As Integer)
		  dim inPtr as Ptr = inMB
		  dim lastPos as integer = inMB.Size - 1
		  
		  do
		    if pos > lastPos then
		      raise new JSONException( "Unexpected end of JSON string", 0 )
		      return
		    end if
		    
		    dim thisByte as byte = inPtr.Byte( pos )
		    select case thisByte
		    case 9, 10, 13, 32
		      pos = pos + 1
		    else
		      return
		    end select
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Append(value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  HasSetType = kHasSetArray
		  ArrayValues.Append value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(index As Integer) As JSONItem_MTC
		  dim r as JSONItem_MTC = self.Value( index )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(index As Integer, Assigns obj As JSONItem_MTC)
		  self.Value( index ) = obj
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(name As String) As JSONItem_MTC
		  dim r as JSONItem_MTC = self.Value( name )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(name As String, Assigns obj As JSONItem_MTC)
		  self.Value( name ) = obj
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  mObjectValues = nil
		  redim ArrayValues( -1 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(JSONString As String)
		  self.Load JSONString
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  if IsArray then
		    return ArrayValues.Ubound + 1
		  else
		    return ObjectValues.Count
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeString(inMB As MemoryBlock, ByRef pos As Integer) As String
		  dim lastPos as integer = inMB.Size - 1
		  if pos > lastPos then
		    raise new JSONException( "Improperly formed JSON string", 0 )
		    return ""
		  end if
		  
		  dim inPtr as Ptr = inMB
		  if inPtr.Byte( pos ) <> kQuote then
		    raise new JSONException( "String is missing an opening quote", 0 )
		    return ""
		  end if
		  
		  dim outMB as new MemoryBlock( inMB.Size )
		  dim outPtr as Ptr = outMB
		  dim outIndex as integer
		  
		  pos = pos + 1
		  dim inBackslash as boolean
		  do
		    if pos > lastPos then
		      raise new JSONException( "String missing closing quote", 0 )
		      return ""
		    end if
		    
		    dim thisByte as integer = inPtr.Byte( pos )
		    select case true
		    case not inBackSlash and thisByte = kBackSlash
		      inBackslash = true
		      pos = pos + 1
		      
		    case not inBackslash and thisByte = kQuote // End
		      pos = pos + 1
		      exit do
		      
		    case inBackslash
		      select case thisByte
		      case kBackSlash, kQuote, kForwardSlash
		        outPtr.Byte( outIndex ) = thisByte
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 114 // r
		        outPtr.Byte( outIndex ) = 13
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 116 // t
		        outPtr.Byte( outIndex ) = 9
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 110 // n
		        outPtr.Byte( outIndex ) = 10
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 98 // b
		        outPtr.Byte( outIndex ) = 8
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 102 // f
		        outPtr.Byte( outIndex ) = 12
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 117 /// u
		        if ( pos + 5 ) > lastPos then
		          raise new JSONException( "Improperly formed JSON string", 0 )
		          return ""
		        end if
		        
		        dim asString as string = inMB.StringValue( pos + 1, 4 ).DefineEncoding( Encodings.UTF8 )
		        dim uValue as integer = val( "&h" + asString )
		        dim char as string = Encodings.UTF8.Chr( uValue )
		        outMB.StringValue( outIndex, char.LenB ) = char
		        outIndex = outIndex + char.LenB
		        pos = pos + 4
		        
		      else // Some random escaped character
		        raise new JSONException( "Improperly formed JSON string", 0 )
		        return ""
		        
		      end select
		      
		      inBackslash = false
		      
		    else
		      outPtr.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      pos = pos + 1
		      
		    end select
		  loop
		  
		  dim r as string = outMB.StringValue( 0, outIndex )
		  r = r.DefineEncoding( Encodings.UTF8 )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeValue(inMB As MemoryBlock, ByRef pos As Integer) As Variant
		  dim lastPos as integer = inMB.Size - 1
		  if pos > lastPos then
		    raise new JSONException( "Improperly formed JSON string", 0 )
		    return nil
		  end if
		  
		  static rxInteger as RegEx
		  if rxInteger is nil then
		    rxInteger = new RegEx
		    rxInteger.SearchPattern = "\A[-+]?\d+\z"
		  end if
		  
		  dim inPtr as Ptr = inMB
		  
		  dim thisByte as integer = inPtr.Byte( pos )
		  if thisByte = kQuote then
		    return DecodeString( inMB, pos )
		    
		  elseif thisByte = kOpenCurlyBrace or thisByte = kOpenSquareBracket then
		    dim child as new JSONItem_MTC
		    child.Load( inMB, pos )
		    return child
		    
		  end if
		  
		  // Look for the next ender
		  
		  dim startPos as integer = pos
		  dim endPos as integer = pos + 1
		  do
		    if endPos > lastPos then
		      raise new JSONException( "Improperly formed JSON string", 0 )
		      return nil
		    end if
		    
		    thisByte = inPtr.Byte( endPos )
		    if thisByte < 33 then
		      exit do
		    elseif thisByte = kComma then
		      exit do
		    elseif thisByte = kCloseCurlyBrace or thisByte = kCloseSquareBracket then
		      exit do
		    end if
		    endPos = endPos + 1
		  loop
		  
		  pos = endPos
		  
		  dim valueString as string = inMB.StringValue( startPos, endPos - startPos ).DefineEncoding( Encodings.UTF8 )
		  dim value as variant
		  if valueString = "true" then
		    value = true
		  elseif valueString = "false" then
		    value = false
		  elseif valueString = "null" then
		    value = nil
		  elseif rxInteger.Search( valueString ) <> nil then
		    dim i as Int64 = val( valueString )
		    value = i
		  elseif IsNumeric( valueString ) then
		    value = val( valueString )
		  else
		    raise new JSONException( "Unrecognized value in JSON string", 0 )
		  end if
		  
		  return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeString(s As String, escapeSlashes As Boolean, output() As String)
		  const kBackSlashVal = 92
		  
		  if s = "" then
		    return
		  end if
		  
		  s = s.ConvertEncoding( Encodings.UTF8 )
		  
		  dim inMB as MemoryBlock = s
		  dim outSize as integer = inMB.Size
		  if outSize < 32 then
		    outSize = 32
		  end if
		  dim outMB as new MemoryBlock( outSize )
		  
		  dim inPtr as Ptr = inMB
		  dim outPtr as Ptr = outMB
		  
		  dim lastIndex as integer = inMB.Size - 1
		  dim inIndex as integer = -1
		  dim outIndex as integer = 0
		  
		  do
		    inIndex = inIndex + 1
		    if inIndex > lastIndex then
		      exit do
		    end if
		    
		    if outIndex > ( outSize - 6 ) then
		      do
		        outSize = outSize * 2
		      loop until outIndex <= ( outSize - 6 )
		      outMB.Size = outSize
		      outPtr = outMB
		    end if
		    
		    dim thisByte as byte = inPtr.Byte( inIndex )
		    if thisByte > 31 and thisByte < 128 then
		      outPtr.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      
		    elseif thisByte = 34 or thisByte = kBackSlashVal then // quote or backslash
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = thisByte
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 47 then // slash
		      if escapeSlashes then
		        outPtr.Byte( outIndex ) = kBackSlashVal
		        outPtr.Byte( outIndex + 1 ) = thisByte
		        outIndex = outIndex + 2
		      else
		        outPtr.Byte( outIndex ) = thisByte
		        outIndex = outIndex + 1
		      end if
		      
		    elseif thisByte = 8 then // backspace
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = 98 // b
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 9 then // tab
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = 116 // t
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 10 then // linefeed
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = 110 // n
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 12 then // formfeed
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = 102 // f
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 13 then // return
		      outPtr.Byte( outIndex ) = kBackSlashVal
		      outPtr.Byte( outIndex + 1 ) = 114 // r
		      outIndex = outIndex + 2
		      
		    elseif thisByte < 32 then // control character
		      dim insertValue as string = "\u" + Right( "000" + hex( thisByte ), 4 )
		      outMB.StringValue( outIndex, 6 ) = insertValue
		      outIndex = outIndex + 6
		      
		    elseif  thisByte > 127 then // high-ascii 
		      dim byteLength as integer
		      if thisByte > 240 then
		        byteLength = 4
		      elseif thisByte > 224 then
		        byteLength = 3
		      else
		        byteLength = 2
		      end if
		      dim thisChar as string = inMB.StringValue( inIndex, byteLength )
		      thisChar = thisChar.DefineEncoding( Encodings.UTF8 )
		      outMB.StringValue( outIndex, 6 ) = "\u" + Right( "000" + hex( thisChar.Asc ), 4 )
		      outIndex = outIndex + 6
		      
		      inIndex = inIndex + byteLength 
		      
		    end if
		    
		  loop
		  
		  s = outMB.StringValue( 0, outIndex )
		  s = s.DefineEncoding( Encodings.UTF8 )
		  
		  output.Append """"
		  output.Append s
		  output.Append """"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeValue(value As Variant, settings As JSONItem_MTC, level As Integer, output() As String)
		  if value IsA JSONItem_MTC then
		    JSONItem_MTC( value ).ToString( output, settings, level )
		    
		  elseif value.Type = Variant.TypeString then
		    EncodeString( value, settings.EscapeSlashes, output )
		    
		  elseif value.Type = Variant.TypeDouble or value.Type = Variant.TypeSingle then
		    output.Append Format( value, settings.DecimalFormat )
		    
		  elseif value.Type = Variant.TypeNil then
		    output.Append "null"
		    
		  else
		    output.Append value.StringValue.Lowercase
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnsureArray() As Boolean
		  if HasSetType <> kHasSetObject then
		    return true
		  else
		    
		    raise new JSONException( "This JSONItem_MTC is an obect", 13 )
		    return false
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnsureObject() As Boolean
		  if HasSetType <> kHasSetArray then
		    return true
		  else
		    
		    raise new JSONException( "This JSONItem_MTC is an array", 13 )
		    return false
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasName(name As String) As Boolean
		  if not EnsureObject() then
		    return false
		  end if
		  
		  HasSetType = kHasSetObject
		  return ObjectValues.HasKey( name )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Insert(index As Integer, value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  HasSetType = kHasSetArray
		  ArrayValues.Insert( index, value )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Load(inMB As MemoryBlock, ByRef pos As Integer)
		  dim inPtr as Ptr = inMB
		  
		  // Determine the type we are loading. If we get here,
		  // it either has to match self, or this type hasn't been set yet
		  if inPtr.Byte( pos ) = kOpenSquareBracket then
		    //
		    // Loading array
		    //
		    pos = pos + 1
		    
		    do
		      AdvancePastWhiteSpace( inMB, pos )
		      if inPtr.Byte( pos ) = kCloseSquareBracket then
		        pos = pos + 1
		        exit do
		      end if
		      dim value as variant = DecodeValue( inMB, pos )
		      self.Append value
		      AdvancePastWhiteSpace( inMB, pos )
		      if inPtr.Byte( pos ) = kComma then
		        pos = pos + 1
		      end if
		    loop
		    
		  else
		    //
		    // Loading object
		    //
		    pos = pos + 1
		    
		    do
		      AdvancePastWhiteSpace( inMB, pos )
		      if inPtr.Byte( pos ) = kCloseCurlyBrace then
		        pos = pos + 1
		        exit do
		      end if
		      
		      dim name as string = DecodeString( inMB, pos )
		      AdvancePastWhiteSpace( inMB, pos )
		      if inPtr.Byte( pos ) <> kColon then
		        // Something is wrong
		        raise new JSONException( "Improperly formed JSON string", 0 )
		        return
		      end if
		      pos = pos + 1
		      AdvancePastWhiteSpace( inMb, pos )
		      dim value as variant = DecodeValue( inMB, pos )
		      self.Value( name ) = value
		      
		      AdvancePastWhiteSpace( inMB, pos )
		      if inPtr.Byte( pos ) = kComma then
		        pos = pos + 1
		      end if
		    loop
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Load(JSONString As String)
		  if JSONString = "" then
		    return
		  end if
		  
		  JSONString = JSONString.ConvertEncoding( Encodings.UTF8 ).Trim
		  
		  dim firstChar as string = JSONString.LeftB( 1 )
		  if firstChar = "[" and IsObject then
		    // Do nothing
		    return
		    
		  elseif firstChar = "{" and IsArray then
		    // Do nothing
		    return
		    
		  elseif firstChar <> "[" and firstChar <> "{" then
		    // Do nothing
		    return
		  end if
		  
		  dim inMB as MemoryBlock = JSONString
		  dim pos as integer
		  Load( inMB,pos )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(name As String, defaultValue As Variant) As Variant
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  return ObjectValues.Lookup( name, defaultValue )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(index As Integer) As String
		  if not EnsureObject() then
		    return ""
		  end if
		  
		  return ObjectValues.Key( index ).StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Names() As String()
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  dim d as Dictionary = ObjectValues
		  dim keys() as variant = d.Keys
		  dim r() as string
		  redim r( keys.Ubound )
		  for i as integer = 0 to keys.Ubound
		    r( i ) = keys( i )
		  next i
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ObjectValues() As Dictionary
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  if mObjectValues is nil then
		    mObjectValues = new Dictionary
		  end if
		  
		  return mObjectValues
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(index As Integer)
		  if not EnsureArray() then
		    return
		  end if
		  
		  ArrayValues.Remove( index )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(name As String)
		  if not EnsureObject() then
		    return
		  end if
		  
		  ObjectValues.Remove( name )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  dim output() as string
		  
		  ToString( output, self, 0 )
		  
		  dim r as string = join( output, "" )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ToString(output() As String, settings As JSONItem_MTC, level As Integer)
		  level = level + 1
		  dim notCompact as boolean = not( settings.Compact )
		  
		  static lotsOfSpaces as string = "        "
		  
		  dim indenter as string
		  if notCompact then
		    dim targetLen as integer = level * settings.IndentSpacing
		    while lotsOfSpaces.LenB < targetLen
		      lotsOfSpaces = lotsOfSpaces + lotsOfSpaces
		    wend
		    indenter = lotsOfSpaces.LeftB( targetLen )
		  end if
		  
		  if IsArray then
		    
		    output.Append "["
		    if notCompact then
		      output.Append EndOfLine
		    end if
		    
		    for i as integer = 0 to ArrayValues.Ubound
		      if notCompact then
		        output.Append indenter
		      end if
		      
		      dim value as variant = ArrayValues( i )
		      EncodeValue( value, settings, 0, output )
		      
		      if i < ArrayValues.Ubound then
		        output.Append ","
		      end if
		      if notCompact then
		        output.Append EndOfLine
		      end if
		    next i
		    
		    if notCompact then
		      output.Append indenter.LeftB( indenter.LenB - settings.IndentSpacing )
		    end if
		    output.Append "]"
		    
		  else
		    
		    output.Append "{"
		    if notCompact then
		      output.Append EndOfLine
		    end if
		    
		    dim d as Dictionary = ObjectValues
		    dim keys() as variant = d.Keys
		    for i as integer = 0 to keys.Ubound
		      if notCompact then
		        output.Append indenter
		      end if
		      
		      dim key as variant = keys( i )
		      EncodeString( key.StringValue, settings.EscapeSlashes, output )
		      output.Append ":"
		      
		      dim value as variant = d.Value( key )
		      EncodeValue( value, settings, level, output )
		      
		      if i < keys.Ubound then
		        output.Append ","
		      end if
		      if notCompact then
		        output.Append EndOfLine
		      end if
		    next
		    
		    if notCompact then
		      output.Append indenter.LeftB( indenter.LenB - settings.IndentSpacing )
		    end if
		    output.Append "}"
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(index As Integer) As Variant
		  if not EnsureArray() then
		    return nil
		  end if
		  
		  return ArrayValues( index )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(index As Integer, Assigns value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  HasSetType = kHasSetArray
		  if ArrayValues.Ubound < index then
		    ArrayValues.Append value
		  else
		    ArrayValues( index ) = value
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(name As String) As Variant
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  return ObjectValues.Value( name.ConvertEncoding( Encodings.UTF8 ) )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(name As String, Assigns value As Variant)
		  if not EnsureObject then
		    return
		  end if
		  
		  HasSetType = kHasSetObject
		  ObjectValues.Value( name.ConvertEncoding( Encodings.UTF8 ) ) = value
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private ArrayValues() As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Compact As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		DecimalFormat As String = "-0.0##############"
	#tag EndProperty

	#tag Property, Flags = &h0
		EscapeSlashes As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HasSetType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IndentSpacing As Integer = 2
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return HasSetType = kHasSetArray
			  
			End Get
		#tag EndGetter
		IsArray As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return HasSetType = kHasSetObject
			  
			End Get
		#tag EndGetter
		Private IsObject As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mObjectValues As Dictionary
	#tag EndProperty


	#tag Constant, Name = kBackSlash, Type = Double, Dynamic = False, Default = \"92", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseCurlyBrace, Type = Double, Dynamic = False, Default = \"125", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseSquareBracket, Type = Double, Dynamic = False, Default = \"93", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kColon, Type = Double, Dynamic = False, Default = \"58", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kComma, Type = Double, Dynamic = False, Default = \"44", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kForwardSlash, Type = Double, Dynamic = False, Default = \"47", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetArray, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetNone, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetObject, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenCurlyBrace, Type = Double, Dynamic = False, Default = \"123", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenSquareBracket, Type = Double, Dynamic = False, Default = \"91", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kQuote, Type = Double, Dynamic = False, Default = \"34", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Compact"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DecimalFormat"
			Group="Behavior"
			InitialValue="-0.0##############"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EscapeSlashes"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndentSpacing"
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsArray"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
