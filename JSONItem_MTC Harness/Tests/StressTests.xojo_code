#tag Class
Protected Class StressTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Private Sub BigStringTest()
		  const kSize = 700 * 1024 * 1024
		  dim halfSize as integer = ( kSize \ 2 ) + 1
		  
		  dim s as string = "0123456789"
		  
		  while s.LenB < halfSize
		    s = s + s
		  wend
		  
		  if s.LenB < kSize then
		    s = s + s.Mid( 1, kSize - s.LenB )
		  end if
		  
		  dim length as integer = s.LenB
		  #pragma unused length
		  
		  dim j as new JSONItem_MTC
		  j.Compact = true
		  
		  try
		    j.Append s
		    Assert.Pass
		  catch err as OutOfMemoryException
		    Assert.Fail "Ran out of memory"
		    return
		  end try
		  
		  dim jString as string
		  try
		    jString = j.ToString
		    Assert.AreEqual 0, StrComp( "[""" + s + """]", jString, 0 ), "Strings don't match"
		  catch err as OutOfMemoryException
		    Assert.Fail "Ran out of memory creating string"
		    return
		  end try
		  
		  return
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
