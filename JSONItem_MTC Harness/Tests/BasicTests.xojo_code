#tag Class
Protected Class BasicTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub CaseSensitiveKeyTest()
		  dim j as new JSONItem_MTC
		  j.Value( "a" ) = 1
		  j.Value( "A" ) = 2
		  
		  Assert.AreEqual( 2, j.Count, "Should be 2 objects" )
		  Assert.AreEqual( 1, j.Value( "a" ).IntegerValue )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EmbeddedQuoteTest()
		  Dim jI As New JSONItem_MTC
		  jI.Value("name") = "John ""Doey"" Doe"
		  
		  Dim raw As String = jI.ToString
		  
		  Dim jO As New JSONItem_MTC(raw)
		  
		  For Each k As String In jI.Names
		    Assert.IsTrue(jI.Value(k) = jO.Value(k), k)
		  Next
		End Sub
	#tag EndMethod

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
		Private Sub ObjectsTest()
		  dim j as new JSONItem_MTC
		  
		  try
		    j.Append new date
		    Assert.Fail( "Shouldn't be able to add a date" )
		  catch err as JSONException
		    Assert.Pass()
		  end try
		  
		  dim f as FolderItem = SpecialFolder.Desktop
		  try
		    j.Append f
		    Assert.Fail( "Shouldn't be able to add a FolderItem" )
		  catch err as JSONException
		    Assert.Pass()
		  end try
		  
		  dim child as new JSONItem_MTC( "[]" ) // Empty array
		  try
		    j.Append child
		    Assert.Pass
		  catch err as JSONException
		    Assert.Pass( "Should be allowed to append JSONItem_MTC" )
		  end try
		  
		  dim d as new Dictionary
		  try
		    j.Append d
		    Assert.Pass
		  catch err as JSONException
		    Assert.Pass( "Should be allowed to append Dictionary" )
		  end try
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SimpleToFromTest()
		  Dim jI As New JSONItem_MTC
		  jI.Value("name") = "John Doe"
		  jI.Value("age") = 32
		  jI.Value("wage") = 14.56
		  
		  Dim jO As New JSONItem_MTC(jI.ToString)
		  
		  For Each k As String In jI.Names
		    Assert.IsTrue(jI.Value(k) = jO.Value(k), k + " matches")
		  Next
		End Sub
	#tag EndMethod


	#tag ViewBehavior
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
