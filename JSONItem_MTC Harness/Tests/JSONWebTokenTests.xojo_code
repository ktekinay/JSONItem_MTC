#tag Class
Protected Class JSONWebTokenTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Base64URLTest()
		  dim s as string = Repeat("This is a test! ", 10)
		  
		  dim encoded as string = JSONWebToken_MTC.EncodeBase64URL(s)
		  Assert.AreSame Encodings.UTF8, encoded.Encoding, "Encoding doesn't match of encoded"
		  Assert.AreEqual 0, encoded.InStr("/"), "Slash"
		  Assert.AreEqual 0, encoded.InStr("+"), "Plus"
		  
		  dim decoded as string = JSONWebToken_MTC.DecodeBase64URL(encoded, Encodings.UTF8)
		  Assert.AreSame s, decoded, "Decoded doesn't match"
		  
		  s = ChrB(&b11111111) + ChrB(&b11100000) + "abc"
		  s = s.Repeat_MTC(100)
		  
		  encoded = JSONWebToken_MTC.EncodeBase64URL(s)
		  Assert.AreSame s, DecodeBase64(encoded.ReplaceAllB("-", "+").ReplaceAllB("_", "/")), _
		  "DecodeBase64 fails"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateTest()
		  const kSecret = "123"
		  
		  self.StopTestOnFail = true
		  
		  dim wt as new JSONWebToken_MTC
		  wt.ExpirationSeconds = 30
		  
		  dim token as string = wt.ToToken(JSONWebToken_MTC.kAlgorithmHS256, kSecret)
		  
		  dim wt2 as JSONWebToken_MTC = JSONWebToken_MTC.Validate(token, kSecret, true)
		  Assert.IsNotNil wt2, "Could not validate"
		  Assert.IsTrue wt2.IsCurrent, "Is not current"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RSASignatureTest()
		  dim privateKey as string
		  dim publicKey as string
		  Assert.IsTrue Crypto.RSAGenerateKeyPair( 2048, privateKey, publicKey )
		  
		  dim wt as new JSONWebToken_MTC
		  wt.ExpirationSeconds = 30
		  
		  dim token as string = wt.ToToken( JSONWebToken_MTC.kAlgorithmRS256, privateKey )
		  
		  dim newToken as JSONWebToken_MTC = JSONWebToken_MTC.Validate( token, publicKey, true )
		  Assert.IsNotNil newToken
		   
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
