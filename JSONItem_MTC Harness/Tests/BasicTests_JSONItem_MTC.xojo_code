#tag Class
Protected Class BasicTests_JSONItem_MTC
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub ArrayMethodsTest()
		  dim items() as Variant = Array( "a", "A", true, 1.3, 2, nil )
		  
		  dim j as new JSONItem_MTC
		  for i as integer = 0 to items.Ubound
		    j.Append items( i )
		  next
		  
		  Assert.IsTrue( j.IsArray )
		  Assert.AreEqual( items.Ubound + 1, j.Count )
		  
		  for i as integer = 0 to items.Ubound
		    Assert.IsTrue( items( i ) = j.Value( i ) )
		  next
		  
		  j = new JSONItem_MTC
		  j.Value( 5 ) = "a"
		  Assert.AreSame( "a", j.Value( 0 ).StringValue )
		  
		  j = new JSONItem_MTC
		  j.Append true
		  j.Append false
		  j.Remove 0
		  
		  Assert.IsTrue( j.Value( 0 ) = false )
		  
		  j.Insert( 0, "a" )
		  
		  Assert.AreSame( "a", j( 0 ) )
		  Assert.IsTrue( j( 1 ) = false )
		  
		  try
		    j.Insert( 5, "c" )
		    Assert.Fail( "Insert with an out of bounds index" )
		  catch err as OutOfBoundsException
		    // Worked
		  end
		  
		End Sub
	#tag EndMethod

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
		Private Sub DictionaryMethodsTest()
		  dim j as new JSONItem_MTC
		  
		  j.Value( "a" ) = "a"
		  j.Value( "A" ) = "A"
		  
		  Assert.IsFalse( j.IsArray )
		  Assert.AreEqual( 2, j.Count )
		  
		  Assert.IsTrue( j.HasName( "a" ), "HasName 'a'" )
		  Assert.IsTrue( j.HasName( "A" ), "HasName 'A'" )
		  
		  Assert.AreSame( "a", j.Value( "a" ) )
		  Assert.AreSame( "A", j.Value( "A" ) )
		  
		  dim names() as string = j.Names
		  Assert.AreEqual( 1, names.Ubound )
		  Assert.AreSame( "a", names( 0 ), "First name is 'a'" )
		  Assert.AreSame( "A", names( 1 ), "Second name is 'A'" )
		  
		  Assert.AreSame( "A", j.Lookup( "A", "" ), "Lookup 'A'" )
		  Assert.AreSame( "", j.Lookup( "b", "" ), "Lookup 'b'" )
		  
		  Assert.AreSame( "a", j.Name( 0 ) )
		  Assert.AreSame( "A", j.Name( 1 ) )
		  
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
		Private Sub EscapedCharactersTest()
		  dim j as JSONItem_MTC
		  dim jsonString() as string = Array( "\r", "\n", "\\", "\t", "\f", "\b", "\""", "\/", "\u0020", "\G" )
		  dim expectedString() as string = Array( EndOfLine.Macintosh,  EndOfLine.UNIX, "\", chr( 9 ), chr( 12 ), chr( 8 ), """", "/", " ", "G" )
		  
		  for i as integer = 0 to jsonString.Ubound
		    j = new JSONItem_MTC( "[""" + jsonString( i ) + """]" )
		    Assert.AreEqual( expectedString( i ), j( 0 ) )
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadEncodingTest()
		  const kOriginal = "[""abc""]"
		  
		  dim testString as string
		  dim j as JSONItem_MTC
		  
		  testString = kOriginal
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  //
		  // With BOM
		  //
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  testString = ChrB( &hFF ) + ChrB( &hFE ) + testString
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  testString = ChrB( 0 ) + ChrB( 0 ) + ChrB( &hFE ) + ChrB( &hFF ) + testString
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem_MTC( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
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

	#tag Method, Flags = &h21
		Private Sub UnicodeTest()
		  dim j as new JSONItem_MTC
		  
		  j.Value( "a" + chr( 1 ) ) = "something" + chr( 2 )
		  Assert.AreSame( "{""a\u0001"":""something\u0002""}", j.ToString )
		  
		  j = new JSONItem_MTC
		  j.Append( "a" + chr( 1 ) )
		  Assert.AreSame( "[""a\u0001""]", j.ToString )
		  
		  j = new JSONItem_MTC
		  j.Append "©"
		  
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.None
		  Assert.AreEqual( "[""©""]", j.ToString )
		  
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreEqual( "[""\u00A9""]", j.ToString )
		  
		  j = new JSONItem_MTC( "[""Norm’s dog""]" )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreSame( "[""Norm\u2019s dog""]", j.ToString )
		  
		  j = new JSONItem_MTC( "[""this char \u00AD""]" )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.None
		  Assert.AreSame( "[""this char " + Chr( &hAD ) + """]", j.ToString )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.JavaScriptCompatible
		  Assert.AreSame( "[""this char \u00AD""]", j.ToString )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreSame( "[""this char \u00AD""]", j.ToString )
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
