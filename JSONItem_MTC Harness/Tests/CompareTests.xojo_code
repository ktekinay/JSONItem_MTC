#tag Class
Protected Class CompareTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub UnicodeEncodingTest()
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
		    
		    Assert.AreEqual( sNative, sMine, "Codepoint: " + str( i ) )
		  next i
		End Sub
	#tag EndMethod


End Class
#tag EndClass
