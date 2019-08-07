#tag Class
Protected Class CompareTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Sub UnicodeEncodingTest()
		  dim mine as JSONItem_MTC
		  dim native as JSONItem

		  for i as integer = 0 to &hFFFF
		    native = new JSONItem
		    native.Append chr( i )
		    mine = new JSONItem_MTC
		    mine.Append chr( i )

		    dim sNative as string = native.ToString
		    dim sMine as string = mine.ToString
		    if sNative <> sMine then
		      sMine = mine.ToString // Landing spot to break and trace
		    end if

		    Assert.AreEqual( sNative, sMine, "Codepoint: " + i.ToText )
		  next i

		  mine = new JSONItem_MTC
		  native = new JSONItem

		  mine.Append true
		  mine.Append false
		  mine.Append 100
		  mine.Append -100
		  mine.Append 2000.1
		  mine.Append -2000.1
		  mine.Append -2.56e12
		  mine.Append -3.445e-12
		  mine.Append nil
		  mine.Append new JSONItem_MTC( "{""name"":""Kem"",""num"":3.0,""bool"":true}" )

		  native.Append true
		  native.Append false
		  native.Append 100
		  native.Append -100
		  native.Append 2000.1
		  native.Append -2000.1
		  native.Append -2.56e12
		  native.Append -3.445e-12
		  native.Append nil
		  native.Append new JSONItem( "{""name"":""Kem"",""num"":3.0,""bool"":true}" )

		  dim sNative as string = native.ToString
		  dim sMine as string = mine.ToString

		  if sNative <> sMine then
		    sMine = mine.ToString
		  end if

		  Assert.AreEqual( sNative, sMine, "Compact output" )

		  native.Compact = false
		  mine.Compact = false

		  sNative = native.ToString
		  sMine = mine.ToString

		  if sNative <> sMine then
		    sMine = mine.ToString
		  end if

		  Assert.AreEqual( sNative, sMine, "Not compact output" )


		End Sub
	#tag EndMethod


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
