#tag Class
Protected Class JSONDictionary
Inherits Dictionary
	#tag Method, Flags = &h0
		Function HasKey(name As Variant) As Boolean
		  dim key as variant = NameToKey( name )
		  return super.HasKey( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Key(index As Integer) As Variant
		  dim key as variant = super.Key( index )
		  dim name as variant = KeyToName( key )
		  
		  return name
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Keys() As Variant()
		  dim rawKeys() as variant = super.Keys
		  
		  for i as integer = 0 to rawKeys.Ubound
		    dim thisKey as variant = rawKeys( i )
		    rawKeys( i ) = KeyToName( thisKey )
		  next
		  
		  return rawKeys
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function KeyToName(key As Variant) As Variant
		  if key.Type = Variant.TypeString then
		    dim s as string = key.StringValue
		    if s <> "" then
		      dim hex as string = s.NthField( "-", s.CountFields( "-" ) )
		      s = s.LeftB( s.LenB - hex.LenB - 1 )
		    end if
		    return s
		    
		  else
		    return key
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(name As Variant, defaultValue As Variant) As Variant
		  dim key as variant = NameToKey( name )
		  
		  return super.Lookup( key, defaultValue )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NameToKey(name As Variant) As Variant
		  if name.Type = Variant.TypeText then
		    dim t as text = name.TextValue
		    dim s as string = t
		    name = s
		  end if
		  
		  if name.Type = Variant.TypeString then
		    dim key as string = name.StringValue
		    if key <> "" then
		      key = key + "-" + EncodeHex( key )
		    end if
		    return key
		    
		  else
		    return name
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(name As Variant)
		  dim key as variant = NameToKey( name )
		  
		  super.Remove( key )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary() As Dictionary
		  dim keys() as variant = self.Keys
		  dim values() as variant = self.Values
		  
		  dim d as new Dictionary
		  for i as integer = 0 to keys.Ubound
		    d.Value( keys( i ) ) = values( i )
		  next
		  
		  return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(name As Variant) As Variant
		  dim key as variant = NameToKey( name )
		  
		  return super.Value( key )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(name As Variant, Assigns v As Variant)
		  dim key as variant = NameToKey( name )
		  
		  super.Value( key ) = v
		End Sub
	#tag EndMethod


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
	#tag EndViewBehavior
End Class
#tag EndClass
