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
		  
		  dim wt2 as JSONWebToken_MTC = JSONWebToken_MTC.Validate(token, kSecret)
		  Assert.IsNotNil wt2, "Could not validate"
		  Assert.IsTrue wt2.IsCurrent, "Is not current"
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
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
