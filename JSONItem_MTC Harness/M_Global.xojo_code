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
