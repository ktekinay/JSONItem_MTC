#tag Module
Protected Module M_Global
	#tag Method, Flags = &h0
		Function ArrayAuto(ParamArray arr() As Auto) As Auto()
		  return arr
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewCaseSensitiveDictionary() As Xojo.Core.Dictionary
		  return Xojo.Data.ParseJSON( "{}" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Repeat(src As String, repetitions As Integer) As String
		  return src.Repeat_MTC( repetitions )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Repeat_MTC(Extends src As String, repetitions As Integer) As String
		  // Repeats the given string repetitions times.
		  
		  // Common cases
		  if repetitions < 1 then return ""
		  if repetitions = 1 then return src
		  if repetitions = 2 then return src + src
		  if repetitions = 3 then return src + src + src
		  
		  dim curLenB as integer = src.LenB
		  dim targetLenB as integer = curLenB * repetitions
		  dim halfLenB as integer = ( targetLenB + 1 ) \ 2
		  
		  while curLenB < halfLenB
		    src = src + src
		    curLenB = curLenB + curLenB
		  wend
		  
		  dim diffB as integer = targetLenB - curLenB
		  if diffB <> 0 then src = src + LeftB( src, diffB )
		  
		  return src
		  
		End Function
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
End Module
#tag EndModule
