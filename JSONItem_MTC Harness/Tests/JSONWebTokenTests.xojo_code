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
		  
		  dim wt2 as JSONWebToken_MTC = JSONWebToken_MTC.Validate( token, kSecret )
		  Assert.IsNotNil wt2, "Could not validate"
		  Assert.IsTrue wt2.IsCurrent, "Is not current"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub JavaScriptOutputTest()
		  //
		  // Tokens below were generated via JavaScript's jsonwebtoken library
		  // https://www.npmjs.com/package/jsonwebtoken
		  //
		  // It has no expiration date and a claim property of "userId"
		  //
		  
		  // Default HS256
		  dim token as string = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTU4NDcxMzA0NX0.qIqL_EqlNcea9N93CIECCRx2EbdyWg5R47UjOxBfS2g"
		  dim wt as JSONWebToken_MTC
		  
		  wt = wt.Validate( token, "" )
		  Assert.IsNil wt, "No secret"
		  
		  wt = wt.Validate( token, "bad secret" )
		  Assert.IsNil wt, "Bad secret" 
		  
		  wt = wt.Validate( token, "secret" )
		  Assert.IsNotNil wt, "Right secret"
		  
		  Assert.IsTrue wt.HasKey( "userId" ), "Doesn't have userId"
		  if not Assert.Failed then
		    Assert.AreEqual 1, wt.Lookup( "userId", 0 ).IntegerValue
		  end if
		  
		  // HS512
		  token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImlhdCI6MTU4NDcxMzgyM30.jP1HTJ_kIUDBde7a_UZgbnzHWR7Jc9e4CeotiTYKGsT9N1ZZnyifg4-GJWM0yN_6T9bsjRllqOozbRysk0EePA"
		  wt = wt.Validate( token, "secret" )
		  Assert.IsNotNil wt, "HS512"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToTokenTest()
		  dim wt as new JSONWebToken_MTC
		  wt.ExpirationSeconds = 30
		  
		  dim token as string
		  
		  token = wt.ToToken( JSONWebToken_MTC.kAlgorithmNone, "" )
		  Assert.AreNotEqual( "", token )
		  
		  token = wt.ToToken( JSONWebToken_MTC.kAlgorithmHS256, "something" )
		  Assert.AreNotEqual( "", token )
		  
		  #pragma BreakOnExceptions false
		  try
		    token = wt.ToToken( JSONWebToken_MTC.kAlgorithmHS256, "" )
		    Assert.Fail "No secret with some algorithm"
		  catch err as Xojo.Core.BadDataException
		    Assert.Pass
		  end try
		  
		  try
		    token = wt.ToToken( JSONWebToken_MTC.kAlgorithmNone, "something" )
		    Assert.Fail "A secret with no algorithm"
		  catch err as Xojo.Core.BadDataException
		    Assert.Pass
		  end try
		  
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValidateTest()
		  dim wt as new JSONWebToken_MTC
		  wt.ExpirationSeconds = 30
		  
		  dim token as string
		  dim validated as JSONWebToken_MTC
		  
		  token = wt.ToToken( JSONWebToken_MTC.kAlgorithmNone, "" )
		  validated = JSONWebToken_MTC.Validate( token, "" )
		  Assert.IsNotNil validated, "No algorithm, no secret"
		  
		  validated = JSONWebToken_MTC.Validate( token, "something" )
		  Assert.IsNil validated, "No algorithm with secret"
		  
		  token = wt.ToToken( JSONWebToken_MTC.kAlgorithmHS256, "something" )
		  validated = JSONWebToken_MTC.Validate( token, "" )
		  Assert.IsNil validated, "Algorithmm, no secret"
		  
		  validated = JSONWebToken_MTC.Validate( token, "something" )
		  Assert.IsNotNil validated, "Algorithm, right secret"
		  
		  validated = JSONWebToken_MTC.Validate( token, "bad secret" )
		  Assert.IsNil validated, "Algorithm, wrong secret"
		  
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
