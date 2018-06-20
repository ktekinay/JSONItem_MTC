#tag Class
Protected Class JSONDictionary
Inherits Dictionary
	#tag Method, Flags = &h0
		Function HasKey(key As Variant) As Boolean
		  if key.Type = Variant.TypeString then
		    key = EncodeHex( key.StringValue )
		  end if
		  
		  return super.HasKey( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Key(index As Integer) As Variant
		  dim k as variant = super.Key( index )
		  if k.Type = Variant.TypeString then
		    k = DecodeHex( k.StringValue )
		  end if
		  
		  return k
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Keys() As Variant()
		  dim rawKeys() as variant = super.Keys
		  
		  for i as integer = 0 to rawKeys.Ubound
		    dim thisKey as variant = rawKeys( i )
		    if thisKey.Type = Variant.TypeString then
		      rawKeys( i ) = DecodeHex( thisKey.StringValue )
		    end if
		  next
		  
		  return rawKeys
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(key As Variant, defaultValue As Variant) As Variant
		  if key.Type = Variant.TypeString then
		    key = EncodeHex( key.StringValue )
		  end if
		  
		  return super.Lookup( key, defaultValue )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(key As Variant)
		  if key.Type = Variant.TypeString then
		    key = EncodeHex( key.StringValue )
		  end if
		  
		  super.Remove( key )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key As Variant) As Variant
		  if key.Type = Variant.TypeString then
		    key = EncodeHex( key.StringValue )
		  end if
		  
		  return super.Value( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key As Variant, Assigns v As Variant)
		  if key.Type = Variant.TypeString then
		    key = EncodeHex( key.StringValue )
		  end if
		  
		  super.Value( key ) = v
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  dim rawKeys() as variant = super.Keys
			  dim rawKeysString() as string
			  
			  //
			  // Remove the non-strings and get some stats
			  //
			  dim longest as integer
			  dim shortest as integer = &h7FFFFFFF
			  
			  for i as integer = 0 to rawKeys.Ubound 
			    dim thisKey as variant = rawKeys( i )
			    
			    if thisKey.Type = Variant.TypeString then
			      rawKeysString.Append thisKey.StringValue
			      
			      dim thisLen as integer = thisKey.StringValue.LenB
			      longest = max( longest, thisLen )
			      shortest = min( shortest, thisLen )
			    end if
			  next
			  
			  rawKeysString.Sort
			  
			  dim padder as string = " "
			  while padder.LenB < longest
			    padder = padder + padder
			  wend
			  
			  dim builder() as string
			  
			  for i as integer = 0 to rawKeysString.Ubound
			    dim thisKey as string = rawKeysString( i )
			    
			    dim row as string = padder + thisKey + " = "
			    row = row.Right( longest + 3 )
			    row = row + DecodeHex( thisKey )
			    builder.Append row
			  next
			  
			  dim r as string = join( builder, EndOfLine )
			  return r
			End Get
		#tag EndGetter
		Private DebugKeyMap As String
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
		#tag ViewProperty
			Name="KeyMap"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
