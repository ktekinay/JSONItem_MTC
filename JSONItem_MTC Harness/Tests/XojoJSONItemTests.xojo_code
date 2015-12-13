#tag Class
Protected Class XojoJSONItemTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub EmptyArrayTest()
		  dim js as new JSONItem_MTC("[]")
		  dim s as string = js.ToString
		  
		  ErrorIf(s<>"[]","JSONItem_MTC destroys empty array objects")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( FeedbackCase = 23582 )  Sub EncodeLowCharsTest()
		  dim js as new JSONItem_MTC()
		  js.Append( "hello" )
		  js.Append( chr( 9 ) )
		  js.Append( chr( 10 ) )
		  js.Append( chr( 11 ) )
		  js.Append( chr( 1 ) )
		  js.Append( encodings.UTF8.chr(1536))
		  
		  ErrorIf( js.ToString <> "[""hello"",""\t"",""\n"",""\u000B"",""\u0001"",""\u0600""]", "Low characters are not escaped" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeakTest()
		  //Check for memory leaks
		  Dim startobj,endobj As Integer
		  Dim startmem,endmem As UInt64
		  
		  startmem = Runtime.MemoryUsed
		  startobj = runtime.ObjectCount
		  
		  js = New JSONItem_MTC
		  js.Load(kJSONSample)
		  js = Nil
		  
		  endmem = Runtime.MemoryUsed
		  endobj = runtime.ObjectCount
		  
		  ErrorIf( startmem<endmem,"JSONItem_MTC test leaked " + Format( endmem-startmem, "0" ).ToText + " bytes" )
		  ErrorIf( startobj<endobj,"JSONItem_MTC test leaked " + Format( endobj-startobj, "0" ).ToText + " objects" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParsingTest()
		  Dim s As String
		  
		  js = New JSONItem_MTC
		  
		  Try
		    js.Load(kJSONSample)
		    s = js.child("menu").Child("popup").Child("menuitem").child(0).Value("onclick")
		    ErrorIf(s<>"CreateNewDoc()","JSONItem_MTC data retrieval error")
		  Catch err As JSONException
		    ErrorIf(True,"JSONItem_MTC Parsing Error")
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringTest()
		  
		  js = New JSONItem_MTC
		  Dim s As String = js.ToString
		  
		  ErrorIf(s <> "{}","Empty object <> {}")
		  
		  js.Value("one") = 1
		  s = js.ToString
		  ErrorIf(s<>"{""one"":1}","Integer type error")
		  dim thisType as integer = js.Value("one").Type
		  ErrorIf(thisType <> variant.TypeInteger and thisType <> variant.TypeInt64,"Integer type storage error")
		  
		  js.Value("one") = "1"
		  s = js.ToString
		  ErrorIf(s<>"{""one"":""1""}","String type error")
		  ErrorIf(js.Value("one").Type <> variant.TypeString,"String type storage error")
		  
		  js.Value("one") = Nil
		  s = js.ToString
		  ErrorIf(s<>"{""one"":null}","NULL value error")
		  ErrorIf(js.Value("one").Type <> variant.TypeNil,"NULL type storage error")
		  
		  js.Value("one") = True
		  s = js.ToString
		  ErrorIf(s<>"{""one"":true}","TRUE value error")
		  ErrorIf(js.Value("one").Type <> variant.TypeBoolean,"Boolean TRUE type storage error")
		  
		  js.Value("one") = False
		  s = js.ToString
		  ErrorIf(s<>"{""one"":false}","FALSE type error")
		  ErrorIf(js.Value("one").Type <> variant.TypeBoolean,"Boolean FALSE type storage error")
		  
		  ErrorIf(js.HasName("One"),"Case-Insensitive Names")
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UTF8Test()
		  //UTF8 Encoding
		  Dim s As String
		  
		  js = New JSONItem_MTC
		  
		  js.Value("one") = "one" //Assign a string
		  s = js.Value("one") //Retrieve it
		  ErrorIf(s.Encoding <> encodings.UTF8,"JSONItem_MTC not returning UTF8 Strings")
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private js As JSONItem_MTC
	#tag EndProperty


	#tag Constant, Name = kJSONSample, Type = String, Dynamic = False, Default = \"{\"menu\": {\r  \"id\": \"file\"\x2C\r  \"value\": \"File\"\x2C\r  \"popup\": {\r    \"menuitem\": [\r      {\"value\": \"New\"\x2C \"onclick\": \"CreateNewDoc()\"}\x2C\r      {\"value\": \"Open\"\x2C \"onclick\": \"OpenDoc()\"}\x2C\r      {\"value\": \"Close\"\x2C \"onclick\": \"CloseDoc()\"}\r    ]\r  }\r}}", Scope = Private
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
