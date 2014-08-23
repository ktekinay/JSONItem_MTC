#tag Class
Protected Class JSONMBSTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub LoadTest()
		  dim encoded() as string = Array( "t", "\u0000", "\u0020", Chr( 1 ), "\u0001" )
		  dim expected() as string = Array( "t", chr( 0 ), " ", Chr( 1 ), Chr( 1 ) )
		  
		  for i as integer = 0 to encoded.Ubound
		    dim thisEncoded as string = "[""" + encoded( i ) + """]"
		    dim thisExpected as string = expected( i )
		    dim j as new JSONMBS( thisEncoded )
		    dim returned as string = j.ChildNode.ValueString
		    Assert.AreSame( thisExpected, returned, "Shoud be: " + EncodeHex( thisExpected ) + ", was " + EncodeHex( returned ) )
		  next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ToStringTest()
		  dim j as JSONMBS
		  
		  j = JSONMBS.NewStringArray( Array( chr( 1 ) ) )
		  dim s as string = j.ToString( false )
		  Assert.AreSame( "[""\u0001""]", s )
		  
		  j = JSONMBS.NewStringArray( Array( chr( 0 ) ) )
		  s = j.ToString( false )
		  Assert.AreSame( "[""\u0000""]", s )
		  
		  j = JSONMBS.NewStringArray( Array( EndOfLine.Macintosh ) )
		  s = j.ToString( false )
		  Assert.AreSame( "[""\r""]", s )
		  
		  j = JSONMBS.NewStringArray( Array( chr( 9 ) ) )
		  s = j.ToString( false )
		  Assert.AreSame( "[""\t""]", s )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UnicodeTest()
		  dim j as JSONMBS
		  
		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as string = "[""\uD800\uDD49""]"
		  
		  j = new JSONMBS( asEncoded )
		  Assert.AreEqual( EncodeHex( highChar, true ), EncodeHex( j.ChildNode.ValueString, true ) )
		  
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
