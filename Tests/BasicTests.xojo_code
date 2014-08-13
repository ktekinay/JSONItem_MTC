#tag Class
Protected Class BasicTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub EmptyStringTest()
		  Dim jI As New JSONItem_MTC
		  jI.Value("name") = ""
		  
		  Dim raw As String = jI.ToString
		  Dim jO As New JSONItem_MTC(raw)
		  
		  Assert.AreEqual("", jO.Value("name"))
		End Sub
	#tag EndMethod

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


	#tag ViewBehavior
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
