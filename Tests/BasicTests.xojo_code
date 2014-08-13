#tag Class
Protected Class BasicTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub SimpleToFromTest()
		  Dim jF As New JSONItem_MTC
		  jF.Value("name") = "John Doe"
		  jF.Value("age") = 32
		  jF.Value("wage") = 14.56
		  
		  Dim jT As New JSONItem_MTC(jF.ToString)
		  
		  Assert.AreEqual(jF.Value("name").StringValue, jT.Value("name").StringValue, "Names equal")
		  Assert.AreEqual(jF.Value("age").IntegerValue, jT.Value("age").IntegerValue, "Ages equal")
		  Assert.AreEqual(jF.Value("wage").DoubleValue, jT.Value("wage").DoubleValue, 0.001, "Wages equal")
		End Sub
	#tag EndMethod


End Class
#tag EndClass
