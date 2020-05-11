#tag Class
Protected Class BasicTests_API2
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ArrayMethodsTest()
		  
		  
		  dim items() as variant = ArrayVariant( "a", "A", true, 1.3, 2, nil )
		  
		  dim j() As variant = ParseJSON( GenerateJSON( items ) )
		  
		  Assert.AreEqual( items.Ubound, j.Ubound )
		  
		  for i as integer = 0 to items.Ubound
		    Assert.IsTrue( items( i ) = j( i ) )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BadlyFormedJSONLoadTest()
		  
		  
		  dim loads() as string = Array( """""", "12", "[1", "2]", "[bad]" )
		  
		  Assert.Pass "Running tests"
		  
		  for each load as string in loads
		    #pragma BreakOnExceptions false
		    try
		      dim t as String = GenerateJSON( ParseJSON( load ) )
		      #pragma unused t
		      Assert.Fail "Loading '" + load.ToText + " should have failed"
		      return
		    catch err as InvalidJSONException
		    end
		    #pragma BreakOnExceptions true
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CaseSensitiveKeyTest()
		  
		  
		  dim j as Dictionary = ParseJSON( kCaseSensitiveJSON )
		  
		  Assert.AreEqual( 3, j.Count, "Should be 3 objects" )
		  dim r as integer = j.Value( "a" )
		  Assert.AreEqual( 1, r )
		  
		  Assert.IsFalse( j.HasKey( "MaT" ), "Keys with same Base64 encoding return incorrect results" )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedQuoteTest()
		  
		  Dim jI As Dictionary = ParseJSON( "{}" )
		  
		  jI.Value( "name" ) = "John ""Doey"" Doe"
		  
		  Dim raw As String = GenerateJSON( jI )
		  
		  Dim jO As Dictionary = ParseJSON( raw )
		  
		  for each k as variant in jI.Keys
		    Assert.IsTrue( jI.Value( k ) = jO.Value( k ), k.StringValue.ToText )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmptyStringTest()
		  
		  
		  Dim jI As Dictionary = ParseJSON( "{}" )
		  jI.Value("name") = ""
		  
		  Dim raw As String = GenerateJSON( jI )
		  Dim jO As Dictionary = ParseJSON( raw )
		  
		  Assert.AreEqual( "", CType( jO.Value("name"), String ) )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EscapedCharactersTest()
		  dim j() as variant
		  
		  dim jsonString() as String = Array( "\r", "\n", "\\", "\t", "\f", "\b", "\""", "\/", "\u0020" )
		  dim expectedString() as string = Array( EndOfLine.Macintosh,  EndOfLine.UNIX, "\", chr( 9 ), chr( 12 ), chr( 8 ), """", "/", " " )
		  
		  for i as integer = 0 to jsonString.Ubound
		    j = ParseJSON( "[""" + jsonString( i ) + """]" )
		    dim extracted as String = j( 0 )
		    dim extractedString as string = extracted
		    Assert.AreEqual( expectedString( i ), extractedString )
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IllegalStringTest()
		  
		  
		  Assert.Pass( "Running tests" )
		  
		  dim j() As variant
		  
		  dim badStrings() as string = Array( Chr( 13 ), Chr( 9 ), Chr( 8 ), Chr( 5 ), Chr( 29 ) )
		  
		  for each s as string in badStrings
		    dim load as String = "[""this" + s + "that""]"
		    
		    #pragma BreakOnExceptions false
		    
		    try
		      j = ParseJSON( load )
		      Assert.Fail( EncodeHex( s ).ToText + " should have failed" )
		      return
		    catch err as InvalidJSONException
		    end try
		    
		    #pragma BreakOnExceptions true
		    
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnicodeTest()
		  
		  
		  dim d as new Dictionary
		  dim a() as variant
		  
		  d.Value( "a" + chr( 1 ) ) = "something" + chr( 2 )
		  Assert.AreSame( "{""a\u0001"":""something\u0002""}", GenerateJSON( d ) )
		  
		  a.Append( "a" + chr( 1 ) )
		  Assert.AreSame( "[""a\u0001""]", GenerateJSON( a ) )
		  
		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as String = "[""\uD800\uDD49""]"
		  
		  a = ParseJSON( asEncoded )
		  Assert.AreEqual( EncodeHex( highChar, true ), EncodeHex( a( 0 ), true ) )
		  
		  redim a( -1 )
		  #pragma BreakOnExceptions false
		  try
		    a = ParseJSON( "[""\ujohn""]" )
		    Assert.Fail( "Loading '\ujohn' should have failed" )
		  catch err as InvalidJSONException
		  end
		  #pragma BreakOnExceptions default
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCaseSensitiveJSON, Type = Text, Dynamic = False, Default = \"{\n    \"a\" : 1\x2C\n    \"A\" : 2\x2C\n    \"Man\" : 3\n}", Scope = Private
	#tag EndConstant


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
