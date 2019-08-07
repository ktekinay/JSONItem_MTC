#tag Class
Protected Class BasicTests_NewFramework
Inherits TestGroup
	#tag Method, Flags = &h21
		Sub ArrayMethodsTest()
		  Using Xojo.Core

		  dim items() as Auto = ArrayAuto( "a", "A", true, 1.3, 2, nil )

		  dim j() As Auto = Xojo.Data.ParseJSON( Xojo.Data.GenerateJSON( items ) )

		  Assert.AreEqual( items.Ubound, j.Ubound )

		  for i as integer = 0 to items.Ubound
		    Assert.IsTrue( items( i ) = j( i ) )
		  next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub BadlyFormedJSONLoadTest()
		  Using Xojo.Core

		  dim loads() as string = Array( """""", "12", "[1", "2]", "[bad]" )

		  Assert.Pass "Running tests"

		  for each load as string in loads
		    #pragma BreakOnExceptions false
		    try
		      dim t as Text = Xojo.Data.GenerateJSON( Xojo.Data.ParseJSON( load.ToText ) )
		      #pragma unused t
		      Assert.Fail "Loading '" + load.ToText + " should have failed"
		      return
		    catch err as Xojo.Data.InvalidJSONException
		    end
		    #pragma BreakOnExceptions true
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub CaseSensitiveKeyTest()
		  Using Xojo.Core

		  dim j as Dictionary = Xojo.Data.ParseJSON( kCaseSensitiveJSON )

		  Assert.AreEqual( 3, j.Count, "Should be 3 objects" )
		  dim r as integer = j.Value( "a" )
		  Assert.AreEqual( 1, r )

		  Assert.IsFalse( j.HasKey( "MaT" ), "Keys with same Base64 encoding return incorrect results" )


		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub EmbeddedQuoteTest()
		  Using Xojo.Core

		  Dim jI As Dictionary = NewCaseSensitiveDictionary

		  jI.Value("name") = "John ""Doey"" Doe"

		  Dim raw As Text = Xojo.Data.GenerateJSON( jI )

		  Dim jO As Dictionary = Xojo.Data.ParseJSON( raw )

		  for each entry as DictionaryEntry in jI
		    dim k as Auto = entry.Key
		    Assert.IsTrue( entry.Value = jO.Value(k), k)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub EmptyStringTest()
		  Using Xojo.Core

		  Dim jI As Dictionary = NewCaseSensitiveDictionary
		  jI.Value("name") = ""

		  Dim raw As Text = Xojo.Data.GenerateJSON( jI )
		  Dim jO As Dictionary = Xojo.Data.ParseJSON( raw )

		  Assert.AreEqual( "", CType( jO.Value("name"), Text ) )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub EscapedCharactersTest()
		  dim j() as Auto

		  dim jsonString() as text = Array( "\r", "\n", "\\", "\t", "\f", "\b", "\""", "\/", "\u0020" )
		  dim expectedString() as string = Array( EndOfLine.Macintosh,  EndOfLine.UNIX, "\", chr( 9 ), chr( 12 ), chr( 8 ), """", "/", " " )

		  for i as integer = 0 to jsonString.Ubound
		    j = Xojo.Data.ParseJSON( "[""" + jsonString( i ) + """]" )
		    dim extracted as text = j( 0 )
		    dim extractedString as string = extracted
		    Assert.AreEqual( expectedString( i ), extractedString )
		  next i

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub IllegalStringTest()
		  Using Xojo.Core

		  Assert.Pass( "Running tests" )

		  dim j() As Auto

		  dim badStrings() as string = Array( Chr( 13 ), Chr( 9 ), Chr( 8 ), Chr( 5 ), Chr( 29 ) )

		  for each s as string in badStrings
		    dim load as text = "[""this" + s.ToText + "that""]"

		    #pragma BreakOnExceptions false

		    try
		      j = Xojo.Data.ParseJSON( load )
		      Assert.Fail( EncodeHex( s ).ToText + " should have failed" )
		      return
		    catch err as Xojo.Data.InvalidJSONException
		    end try

		    #pragma BreakOnExceptions true

		  next

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub UnicodeTest()
		  Using Xojo.Core

		  dim d as new Dictionary
		  dim a() as Auto

		  d.Value( "a" + chr( 1 ) ) = "something" + chr( 2 )
		  Assert.AreSame( "{""a\u0001"":""something\u0002""}", Xojo.Data.GenerateJSON( d ) )

		  a.Append( "a" + chr( 1 ) )
		  Assert.AreSame( "[""a\u0001""]", Xojo.Data.GenerateJSON( a ) )

		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as text = "[""\uD800\uDD49""]"

		  a = Xojo.Data.ParseJSON( asEncoded )
		  Assert.AreEqual( EncodeHex( highChar, true ), EncodeHex( a( 0 ), true ) )

		  redim a( -1 )
		  #pragma BreakOnExceptions false
		  try
		    a = Xojo.Data.ParseJSON( "[""\ujohn""]" )
		    Assert.Fail( "Loading '\ujohn' should have failed" )
		  catch err as Xojo.Data.InvalidJSONException
		  end
		  #pragma BreakOnExceptions default
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCaseSensitiveJSON, Type = Text, Dynamic = False, Default = \"{\n    \"a\" : 1\x2C\n    \"A\" : 2\x2C\n    \"Man\" : 3\n}", Scope = Private
	#tag EndConstant


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
