#tag Class
Protected Class BasicTests_JSONItem
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub LoadEncodingTest()
		  const kOriginal = "[""abc""]"
		  
		  dim testString as string
		  dim j as JSONItem
		  
		  testString = kOriginal
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.DefineEncoding( nil )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  testString = testString.DefineEncoding( nil )
		  j = new JSONItem( testString )
		  Assert.AreSame( "abc", j( 0 ) )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnicodeTest()
		  dim j as new JSONItem
		  
		  j.Value( "a" + chr( 1 ) ) = "something" + chr( 2 )
		  Assert.AreSame( "{""a\u0001"":""something\u0002""}", j.ToString )
		  
		  j = new JSONItem
		  j.Append( "a" + chr( 1 ) )
		  Assert.AreSame( "[""a\u0001""]", j.ToString )
		  
		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as string = "[""\uD800\uDD49""]"
		  
		  j = new JSONItem( asEncoded )
		  Assert.AreEqual( EncodeHex( highChar, true ), EncodeHex( j( 0 ).StringValue, true ) )
		  
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
