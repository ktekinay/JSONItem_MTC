#tag Class
Protected Class YAMLTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BasicArrayTest()
		  dim y as string
		  
		  y = "- xxx" + &uA  + "- yyy"
		  dim arr() as variant = ParseYAML_MTC( y )
		  
		  Assert.AreEqual 1, CType( arr.Ubound, integer )
		  Assert.AreEqual "xxx", arr( 0 ).StringValue
		  Assert.AreEqual "yyy", arr( 1 ).StringValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicObjectTest()
		  dim y as string
		  
		  y = "k1 : value1" + &uA + "k2:value2"
		  
		  dim dict as Dictionary = ParseYAML_MTC( y )
		  
		  Assert.AreEqual 2, dict.Count
		  Assert.AreEqual "value1", dict.Value( "k1" ).StringValue
		  Assert.AreEqual "value2", dict.Value( "k2" ).StringValue
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
