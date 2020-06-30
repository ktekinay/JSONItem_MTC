#tag Class
Protected Class JSONItem_MTC
Inherits JSONItem
	#tag Method, Flags = &h0
		Sub Add(Value as Variant)
		  Raise New RuntimeException("not implemented")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddAt(index as integer, value as Variant)
		  Raise New RuntimeException("not implemented")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdvancePastWhiteSpace(inMB As MemoryBlock, ByRef pos As Integer)
		  dim inPtr as Ptr = inMB
		  dim lastPos as integer = inMB.Size - 1
		  
		  do
		    if pos > lastPos then
		      raise new JSONException( "A parsing error occurred", 2, pos )
		      return
		    end if
		    
		    dim thisByte as integer = inPtr.Byte( pos )
		    select case thisByte
		    case 9, 10, 13, 32
		      pos = pos + 1
		    else
		      return
		    end select
		  loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Append(value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  Validate( value )
		  
		  HasSetType = kHasSetArray
		  ArrayValues.Append value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AppendOutMB(outMBs() As MemoryBlock, ByRef outIndex As Integer) As MemoryBlock
		  dim outMB as MemoryBlock
		  
		  outMB = new MemoryBlock( kOutMBSize )
		  outMBs.Append outMB
		  outIndex = 0
		  
		  return outMB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(index As Integer) As JSONItem_MTC
		  dim r as JSONItem_MTC = self.Value( index )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(index As Integer, Assigns obj As JSONItem_MTC)
		  self.Value( index ) = obj
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(name As String) As JSONItem_MTC
		  dim r as JSONItem_MTC = self.Value( name )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(name As String, Assigns obj As JSONItem_MTC)
		  self.Value( name ) = obj
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChildAt(Index as Integer)
		  Raise New RuntimeException("not implemented")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  ObjectValues = new Dictionary
		  redim ArrayValues( -1 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CompareValues(v1 As Variant, v2 As Variant) As Integer
		  if v1.IsNull and v2.IsNull then
		    return 0
		  elseif v1.IsNull then
		    return -1
		  elseif v2.IsNull then
		    return 1
		  end if
		  
		  dim result as integer
		  
		  if v1 isa JSONItem_MTC and v2 isa JSONItem_MTC then
		    result = JSONItem_MTC( v1 ).Operator_Compare( JSONItem_MTC( v2 ) )
		    
		  else
		    
		    dim type1 as integer = v1.Type
		    dim type2 as integer = v2.Type
		    
		    //
		    // Normalize the types
		    //
		    if type1 = Variant.TypeInt32 or type1 = Variant.TypeInteger then
		      type1 = Variant.TypeInt64
		    elseif type1 = Variant.TypeCurrency then
		      dim d as double = v1.CurrencyValue
		      v1 = d
		      type1 = Variant.TypeDouble 
		    elseif type1 = Variant.TypeSingle then
		      type1 = Variant.TypeDouble
		    elseif type1 = Variant.TypeText then
		      dim s as string = v1.TextValue
		      v1 = s
		      type1 = Variant.TypeString
		    end if
		    
		    if type2 = Variant.TypeInt32 or type2 = Variant.TypeInteger then
		      type2 = Variant.TypeInt64
		    elseif type2 = Variant.TypeCurrency then
		      dim d as double = v2.CurrencyValue
		      v2 = d
		      type2 = Variant.TypeCurrency
		    elseif type2 = Variant.TypeSingle then
		      type2 = Variant.TypeDouble
		    elseif type2 = Variant.TypeText then
		      dim s as string = v2.TextValue
		      v2 = s
		      type2 = Variant.TypeString
		    end if
		    
		    if type1 = type2 then
		      select case type1
		      case Variant.TypeInt64
		        result = v1.IntegerValue - v1.IntegerValue
		        
		      case Variant.TypeBoolean
		        if v1.BooleanValue = v2.BooleanValue then
		          result = 0
		        elseif v1.BooleanValue then
		          result = 1
		        else
		          result = -1
		        end if
		        
		      case else // Strings, doubles, singles
		        result = StrComp( v1.StringValue, v2.StringValue, 0 )
		        
		      end select
		      
		    else
		      result = type1 - type2
		    end if
		    
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  LoadCS = new CriticalSection
		  
		  ObjectValues = new Dictionary
		  
		  DecimalFormat = kDefaultDecimalFormat
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(jsonItem As JsonItem)
		  dim item As String = jsonItem.ToString
		  if item <> "" Then
		    Me.Load(item)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(JSONString As String, isStrict As Boolean = False)
		  self.Constructor()
		  
		  self.Strict = isStrict
		  self.Load JSONString
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  Return Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeString(inMB As MemoryBlock, ByRef pos As Integer, current As JSONItem_MTC, outMB As MemoryBlock) As String
		  dim lastPos as integer = inMB.Size - 1
		  if pos > lastPos then
		    raise new JSONException( "Missing """, 7, pos + 1 )
		    return ""
		  end if
		  
		  dim inPtr as Ptr = inMB
		  if inPtr.Byte( pos ) <> kQuote then
		    raise new JSONException( "Missing """, 7, pos + 1 )
		    return ""
		  end if
		  
		  if outMB.Size < inMB.Size then
		    outMB.Size = inMB.Size
		  end if
		  
		  dim outPtr as Ptr = outMB
		  dim outIndex as integer
		  
		  pos = pos + 1
		  
		  dim flushStart as integer = pos
		  dim flushEnd as integer = -1
		  dim hasBackSlash as boolean
		  dim surrogatePairFirstHalf as integer
		  dim surrogatePairLastHalf as integer
		  dim expectingSurrogate as boolean
		  dim insertCodepoint as boolean
		  
		  do
		    if pos > lastPos then
		      dim msg as string = if( current.IsArray, "Missing , or ]", "Missing , or }" )
		      raise new JSONException( msg, 6, pos )
		      return ""
		    end if
		    
		    if expectingSurrogate and ( inPtr.Byte( pos ) <> kBackSlash or ( pos + 1 ) > lastPos or inPtr.Byte( pos + 1 ) <> 117 ) then
		      raise new JSONException( "Improperly formed JSON string", 0 )
		      return ""
		    end if
		    
		    dim thisByte as integer = inPtr.Byte( pos )
		    select case thisByte
		      
		    case kBackSlash
		      hasBackSlash = true
		      
		      if flushEnd <> -1 then
		        dim flushLen as integer = flushEnd - flushStart + 1
		        outMB.StringValue( outIndex, flushLen ) = inMB.StringValue( flushStart, flushLen )
		        outIndex = outIndex + flushLen
		      end if
		      
		      pos = pos + 1
		      if pos > lastPos then
		        continue do
		      end if
		      
		      thisByte = inPtr.Byte( pos )
		      if Strict and thisByte < 32 then
		        continue do // Deal on the next pass
		      end if
		      
		      select case thisByte
		      case 114 // r
		        outPtr.Byte( outIndex ) = 13
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 116 // t
		        outPtr.Byte( outIndex ) = 9
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 110 // n
		        outPtr.Byte( outIndex ) = 10
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 98 // b
		        outPtr.Byte( outIndex ) = 8
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 102 // f
		        outPtr.Byte( outIndex ) = 12
		        outIndex = outIndex + 1
		        pos = pos + 1
		      case 117 // u
		        if ( pos + 5 ) > lastPos then
		          raise new JSONException( "Improperly formed JSON string", 0 )
		          return ""
		        end if
		        
		        dim codepoint as integer
		        for byteAdder as integer = 1 to 4
		          dim hexDigit as integer = inPtr.Byte( pos + byteAdder )
		          select case hexDigit
		          case 48 to 57 // 0 - 9
		            codepoint = ( codepoint * 16 ) + ( hexDigit - 48 )
		          case 65 to 70 // A - F
		            codepoint = ( codepoint * 16 ) + ( hexDigit - 55 )
		          case 97 to 102 // a - f
		            codepoint = ( codepoint * 16 ) + ( hexDigit - 87 )
		          else
		            raise new JSONException( "Illegal value", 10, pos )
		            return ""
		          end select
		        next
		        
		        //
		        // See if this is part of a surrogate pair
		        //
		        if expectingSurrogate then
		          if codepoint < &hDC00 or codepoint > &hDFFF then
		            raise new JSONException( "Invalid codepoint", 10, pos )
		            return ""
		          end if
		          
		          //
		          // surrogatePairFirstHalf holds the first 10 bits, this codepoint holds the last 10
		          //
		          surrogatePairLastHalf = codepoint
		          codepoint = Bitwise.ShiftLeft( surrogatePairFirstHalf - &hD800, 10, 20 ) + ( surrogatePairLastHalf - &hDC00 ) + &h10000
		          insertCodepoint = true
		          expectingSurrogate = false
		          
		        elseif codepoint < 128 then
		          outPtr.Byte( outIndex ) = codepoint
		          outIndex = outIndex + 1
		          
		        elseif codepoint < &hD800 or codepoint > &hDFFF then
		          insertCodepoint = True
		          
		        elseif codepoint < &hDC00 then // Surrogate pair
		          
		          surrogatePairFirstHalf = codepoint
		          expectingSurrogate = true
		          
		        else // It's some codepoint that shouldn't be here
		          raise new JSONException( "Invalid codepoint", 10, pos )
		          return ""
		          
		        end if
		        
		        if insertCodepoint then
		          if codepoint > &b1111111111111111 then // Four bytes
		            outPtr.Byte( outIndex ) = &b11110000 or Bitwise.ShiftRight( codepoint, 18, 21 )
		            outPtr.Byte( outIndex + 1 ) = &b10000000 or ( Bitwise.ShiftRight( codepoint, 12, 21 ) and &b111111 )
		            outPtr.Byte( outIndex + 2 ) = &b10000000 or ( Bitwise.ShiftRight( codepoint, 6, 21 ) and &b111111 )
		            outPtr.Byte( outIndex + 3 ) = &b10000000 or ( codepoint and &b111111 )
		            
		            outIndex = outIndex + 4
		          elseif codepoint > &b11111111111  then // Three bytes
		            outPtr.Byte( outIndex ) = &b11100000 or Bitwise.ShiftRight( codepoint, 12, 16 )
		            outPtr.Byte( outIndex + 1 ) = &b10000000 or ( BitWise.ShiftRight( codepoint, 6, 16 ) and &b111111 )
		            outPtr.Byte( outIndex + 2 ) = &b10000000 or ( codepoint and &b111111 )
		            
		            outIndex = outIndex + 3
		          else // two bytes
		            outPtr.Byte( outIndex ) = &b11000000 or Bitwise.ShiftRight( codepoint, 6, 11 )
		            outPtr.Byte( outIndex + 1 ) = &b10000000 or ( codepoint and &b111111 )
		            
		            outIndex = outIndex + 2
		          end if
		          
		          insertCodepoint = false
		        end if
		        
		        pos = pos + 5
		        
		      else // Some random escaped character
		        if Strict then
		          raise new JSONException( "Illegal Character", 9, pos + 1 )
		          return ""
		        end if
		        
		        outPtr.Byte( outIndex ) = inPtr.Byte( pos )
		        outIndex = outIndex + 1
		        pos = pos + 1
		      end select
		      
		      flushStart = pos
		      flushEnd = -1
		      
		    case kQuote // End
		      pos = pos + 1
		      exit 
		      
		    else
		      if self.Strict and thisByte < 32 then
		        raise new JSONException( "Illegal Character", 9, pos + 1 )
		        return ""
		      end if
		      
		      flushEnd = pos
		      pos = pos + 1
		      
		    end select
		  loop
		  
		  if hasBackSlash and flushEnd <> -1 then
		    dim flushLen as integer = flushEnd - flushStart + 1
		    outMB.StringValue( outIndex, flushLen ) = inMB.StringValue( flushStart, flushLen )
		    outIndex = outIndex + flushLen
		  end if
		  
		  dim r as string 
		  if hasBackSlash then
		    r = outMB.StringValue( 0, outIndex )
		  elseif flushEnd <> -1 then
		    r = inMB.StringValue( flushStart, flushEnd - flushStart + 1 )
		  end if
		  
		  r = r.DefineEncoding( Encodings.UTF8 )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DecodeValue(inMB As MemoryBlock, ByRef pos As Integer, current As JSONItem_MTC, outMB As MemoryBlock) As Variant
		  static trueValue as Int32
		  if trueValue = 0 then
		    dim mb as MemoryBlock = "true"
		    mb.LittleEndian = inMB.LittleEndian
		    trueValue = mb.Int32Value( 0 )
		  end if
		  
		  static nullValue as Int32
		  if nullValue = 0 then
		    dim mb as MemoryBlock = "null"
		    mb.LittleEndian = inMB.LittleEndian
		    nullValue = mb.Int32Value( 0 )
		  end if
		  
		  static falsValue as Int32
		  if falsValue = 0 then
		    dim mb as MemoryBlock = "fals"
		    mb.LittleEndian = inMB.LittleEndian
		    falsValue = mb.Int32Value( 0 )
		  end if
		  
		  dim lastPos as integer = inMB.Size - 1
		  if pos > lastPos then
		    raise new JSONException( "A parsing error occurred", 2, pos + 1 )
		    return nil
		  end if
		  
		  dim inPtr as Ptr = inMB
		  
		  dim thisByte as integer = inPtr.Byte( pos )
		  if thisByte = kQuote then
		    return DecodeString( inMB, pos, current, outMB )
		    
		  elseif thisByte = kOpenCurlyBrace then
		    dim child as new JSONItem_MTC
		    child.HasSetType = kHasSetObject
		    pos = pos + 1
		    return child
		    
		  elseif thisByte = kOpenSquareBracket then
		    dim child as new JSONItem_MTC
		    child.HasSetType = kHasSetArray
		    pos = pos + 1
		    return child
		    
		  end if
		  
		  // Look for the next ender
		  
		  dim startPos as integer = pos
		  dim endPos as integer = pos + 1
		  do
		    if endPos > lastPos then
		      dim msg as string = if( current.IsArray, "Missing , or ]", "Missing , or }" )
		      raise new JSONException( msg, 6, endPos + 1 )
		      return nil
		    end if
		    
		    thisByte = inPtr.Byte( endPos )
		    if thisByte < 33 then
		      exit do
		    elseif thisByte = kComma then
		      exit do
		    elseif thisByte = kCloseCurlyBrace or thisByte = kCloseSquareBracket then
		      exit do
		    end if
		    endPos = endPos + 1
		  loop
		  
		  pos = endPos
		  endPos = endPos - 1
		  dim valueLen as integer = endPos - startPos + 1
		  
		  dim value as variant
		  dim keepChecking as boolean = valueLen <> 0
		  
		  dim firstByte as integer = inPtr.Byte( startPos )
		  
		  //
		  // See if it's true, false, or null first
		  //
		  if keepChecking and valueLen = 5 then // false?
		    if firstByte = 102 and inPtr.Byte( startPos + 4 ) = 101 and inMB.Int32Value( startPos ) = falsValue then
		      value = false
		      keepChecking = false
		    end if
		  end if
		  
		  if keepChecking and valueLen = 4 then // true or null?
		    if  firstByte = 116 and inMB.Int32Value( startPos ) = trueValue then
		      value = true
		      keepChecking = false
		    end if
		    
		    if keepChecking and firstByte = 110 and inMB.Int32Value( startPos ) = nullValue then
		      value = nil
		      keepChecking = false
		    end if
		  end if
		  
		  //
		  // Is it an number?
		  //
		  if keepChecking and valueLen = 1 and firstByte >= 48 and firstByte <= 57 then // Single digit
		    value = firstByte - 48
		    keepChecking = false
		  end if
		  
		  if keepChecking then 
		    //
		    //  Only send it to ParseNumber if it's not Strict, or if the firstByte meets strict criteria
		    //
		    if not Strict or ( firstByte = kHyphen or ( firstByte >= 48 and firstByte <= 57 ) ) then
		      if ParseNumber( inMB, startPos, endPos, value ) then
		        keepChecking = false
		      end if
		    end if
		  end if
		  
		  //
		  // Hail Mary
		  //
		  if keepChecking and not Strict then
		    keepChecking = false
		    dim valueString as string = inMB.StringValue( startPos, valueLen ).DefineEncoding( Encodings.UTF8 )
		    if valueString = "true" then
		      value = true
		    elseif valueString = "false" then
		      value = false
		    elseif valueString = "null" then
		      value = nil
		    elseif IsNumeric( valueString ) then
		      value = val( valueString )
		    else
		      keepChecking = true
		    end if
		  end if
		  
		  if keepChecking then // Never found it
		    raise new JSONException( "Illegal Value", 10, startPos )
		  end if
		  
		  return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeCodepoint(value As Integer, outPtr As Ptr, pos As Integer)
		  // WARNING: Assumption is that the destination has enough room
		  
		  static hexByteArr() as integer = Array( 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70 ) // 0-9, A- F
		  
		  outPtr.Byte( pos + 3 ) = hexByteArr( value and &h0F )
		  outPtr.Byte( pos + 2 ) = hexByteArr( Bitwise.ShiftRight( value, 4, 32 ) and &h0F )
		  outPtr.Byte( pos + 1 ) = hexByteArr( Bitwise.ShiftRight( value, 8, 32 ) and &h0F )
		  outPtr.Byte( pos ) = hexByteArr( Bitwise.ShiftRight( value, 12, 32 ) and &h0F )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeString(s As String, settings As JSONItem_MTC, outMBs() As MemoryBlock, ByRef outIndex As Integer, inMB As MemoryBlock)
		  // Encodes a string for output during ToString.
		  // Honors the EncodeUnicode setting, but some characters must ALWAYS be encoded for 
		  // Javascript compatibility. These are
		  //
		  //  chr 127
		  //  &h00ad
		  //  &h0600 - &h0604
		  //  &h070f
		  //  &h17b4 - &h17b5
		  //  &h200c - &h200f
		  //  &h2028 - &h202f
		  //  &h2060 - &h206f
		  //  &hfeff
		  //  &hfff0 - &hffff
		  
		  static alwaysEncode() as integer = Array( _
		  127, &hAD, _
		  &h600, &h601, &h602, &h603, &h604, _
		  &h70F, _
		  &h17B4, &h17B5, _
		  &h200C, &h200D, &h200E, &h200F, _
		  &h2028, &h2029, &h202A, &h202B, &h202C, &h202D, &h202E, &h202F, _
		  &h2060, &h2061, &h2062, &h2063, &h2064, &h2065, &h2066, &h2067, &h2068, &h2069, _
		  &h206A, &h206B, &h206C, &h206D, &h206E, &h206F, _
		  &hFEFF, _
		  &hFFF0, &hFFF1, &hFFF2, &hFFF3, &hFFF4, &hFFF5, &hFFF6, &hFFF7, &hfff8, &hFFF9, _
		  &hFFFA, &hFFFB, &hFFFC, &hFFFD, &hFFFE, &hFFFF _
		  )
		  
		  const kByteBuffer = 13 // Most an encoding can use plus the trailing quote
		  
		  dim outMB as MemoryBlock = outMBs( outMBs.Ubound )
		  dim outSize as integer = outMB.Size
		  if outIndex > ( outSize - kByteBuffer ) then
		    outMB = AppendOutMB( outMBs, outIndex )
		  end if
		  dim outPtr as Ptr = outMB
		  
		  outPtr.Byte( outIndex ) = kQuote
		  outIndex = outIndex + 1
		  
		  if s = "" then
		    outPtr.Byte( outIndex ) = kQuote
		    outIndex = outIndex + 1
		    
		    return
		  end if
		  
		  s = s.ConvertEncoding( Encodings.UTF8 )
		  
		  dim inSize as integer = s.LenB
		  if inMB.Size < inSize then
		    inMB.Size = inSize
		  end if
		  inMB.StringValue( 0, inSize ) = s
		  
		  dim inPtr as Ptr = inMB
		  
		  dim lastIndex as integer = inSize - 1
		  dim inIndex as integer = -1
		  
		  dim encodeUnicode as EncodeType = settings.EncodeUnicode
		  dim escapeSlashes as boolean = settings.EscapeSlashes
		  
		  do
		    inIndex = inIndex + 1
		    if inIndex > lastIndex then
		      exit do
		    end if
		    
		    if outIndex > ( outSize - kByteBuffer ) then
		      outMB = AppendOutMB( outMBs, outIndex )
		      outSize = outMB.Size
		      outPtr = outMB
		    end if
		    
		    dim thisByte as byte = inPtr.Byte( inIndex )
		    
		    if thisByte = 34 or thisByte = kBackSlash then // quote or backslash
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = thisByte
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 47 then // slash
		      if escapeSlashes then
		        outPtr.Byte( outIndex ) = kBackSlash
		        outPtr.Byte( outIndex + 1 ) = thisByte
		        outIndex = outIndex + 2
		      else
		        outPtr.Byte( outIndex ) = thisByte
		        outIndex = outIndex + 1
		      end if
		      
		    elseif thisByte = 8 then // backspace
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 98 // b
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 9 then // tab
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 116 // t
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 10 then // linefeed
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 110 // n
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 12 then // formfeed
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 102 // f
		      outIndex = outIndex + 2
		      
		    elseif thisByte = 13 then // return
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 114 // r
		      outIndex = outIndex + 2
		      
		    elseif thisByte < 32 then // control character
		      outPtr.Byte( outIndex ) = kBackSlash
		      outPtr.Byte( outIndex + 1 ) = 117 // u
		      dim insertValue as string = Right( "000" + hex( thisByte ), 4 )
		      outMB.StringValue( outIndex + 2, 4 ) = insertValue
		      outIndex = outIndex + 6
		      
		    elseif thisByte > 127 and thisByte < 192 then // Continuation byte that wasn't encoded, so just add it
		      outPtr.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      
		    elseif encodeUnicode <> EncodeType.None and ( thisByte = 127 or thisByte >= 192 ) then // Leading byte
		      dim codepoint as integer
		      dim byteLength as integer
		      if thisByte >= 240 then
		        byteLength = 4
		        codepoint = Bitwise.ShiftLeft( thisByte and &b00000111, 18, 21 )
		        codepoint = codepoint + ( Bitwise.ShiftLeft( inPtr.Byte( inIndex + 1 ) and &b00111111, 12, 21 ) )
		        codepoint = codepoint + ( Bitwise.ShiftLeft( inPtr.Byte( inIndex + 2 ) and &b00111111 , 6, 21 ) )
		        codepoint = codepoint + ( inPtr.Byte( inIndex + 3 ) and &b00111111 )
		      elseif thisByte >= 224 then
		        byteLength = 3
		        codepoint = Bitwise.ShiftLeft( thisByte and &b00001111, 12, 18 )
		        codepoint = codepoint + ( Bitwise.ShiftLeft( inPtr.Byte( inIndex + 1 ) and &b00111111, 6, 18 ) )
		        codepoint = codepoint + ( inPtr.Byte( inIndex + 2 ) and &b00111111 )
		      elseif thisByte >= 192 then
		        byteLength = 2
		        codepoint = Bitwise.ShiftLeft( thisByte and &b00011111, 6, 18 )
		        codepoint = codepoint + ( inPtr.Byte( inIndex + 1 ) and &b00111111 )
		      else
		        byteLength = 1
		        codepoint = thisByte
		      end if
		      
		      //
		      // See if we have to use a surrogate pair
		      //
		      if codepoint > &hFFFF and encodeUnicode = EncodeType.All then
		        codepoint = codepoint - &h10000
		        dim surrogateFirst as integer = &hD800 + Bitwise.ShiftRight( codepoint, 10, 21 )
		        dim surrogateLast as integer = &hDC00 + ( codepoint and &b1111111111 )
		        
		        
		        outPtr.Byte( outIndex ) = kBackSlash
		        outPtr.Byte( outIndex + 1 ) = 117 // u
		        EncodeCodepoint( surrogateFirst, outPtr, outIndex + 2 )
		        
		        outPtr.Byte( outIndex + 6 ) = kBackSlash
		        outPtr.Byte( outIndex + 7 ) = 117 // u
		        EncodeCodepoint( surrogateLast, outPtr, outIndex + 8 )
		        
		        outIndex = outIndex + 12
		        
		      elseif codepoint <= &hFFFF and ( encodeUnicode = EncodeType.All or alwaysEncode.IndexOf( codepoint ) <> -1 ) then
		        outPtr.Byte( outIndex ) = kBackSlash
		        outPtr.Byte( outIndex + 1 ) = 117 // u
		        EncodeCodepoint( codepoint, outPtr, outIndex + 2 )
		        outIndex = outIndex + 6
		        
		      else
		        outPtr.Byte( outIndex ) = thisByte
		        outIndex = outIndex + 1
		        byteLength = 1 // Doesn't matter what it really is, only need to advance one byte
		      end if
		      
		      inIndex = inIndex + byteLength - 1
		      
		    else // thisByte > 31 and thisByte < 127  
		      outPtr.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      
		    end if
		    
		  loop
		  
		  outPtr.Byte( outIndex ) = kQuote
		  outIndex = outIndex + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeValue(value As Variant, settings As JSONItem_MTC, level As Integer, outMBs() As MemoryBlock, ByRef outIndex As Integer, inMB As MemoryBlock)
		  if value IsA JSONItem_MTC then
		    JSONItem_MTC( value ).Serialize( outMBs, outIndex, settings, level, inMB )
		    
		  elseif value IsA Dictionary then
		    dim child as JSONItem_MTC = Dictionary( value )
		    child.Serialize( outMBs, outIndex, settings, level, inMB )
		    
		  elseif value.Type = Variant.TypeString or value.Type = Variant.TypeCString or _
		    value.Type = Variant.TypePString then
		    EncodeString( value.StringValue, settings, outMBs, outIndex, inMB )
		    
		  elseif value.Type = Variant.TypeText then
		    dim t as Text = value.TextValue
		    dim s as string = t
		    EncodeString( s, settings, outMBs, outIndex, inMB )
		    
		  else
		    
		    dim insert as string
		    
		    if value.Type = Variant.TypeDouble or value.Type = Variant.TypeSingle or _
		      value.Type = Variant.TypeCurrency then
		      dim s as string = value.StringValue
		      if s.InStr( "inf" ) <> 0 then
		        if settings.Strict then
		          raise new JSONException( "Illegal Value 'inf'", 10 )
		        else
		          insert = "inf"
		        end if
		      elseif s.InStr( "nan" ) <> 0 then 
		        if settings.Strict then
		          raise new JSONException( "Illegal Value 'nan'", 10 )
		        else
		          insert = "nan"
		        end if
		      else
		        insert = Str( value, settings.DecimalFormat )
		      end if
		      
		    elseif value.Type = Variant.TypeNil then
		      insert = "null"
		      
		    else
		      insert = value.StringValue.Lowercase
		    end if
		    
		    dim insertLen as integer = insert.LenB
		    dim outMB as MemoryBlock = outMBs( outMBs.Ubound )
		    dim outSize as integer = outMB.Size
		    if outIndex > ( outSize - insertLen ) then
		      outMB = AppendOutMB( outMBs, outIndex )
		    end if
		    
		    outMB.StringValue( outIndex, insertLen ) = insert
		    outIndex = outIndex + insertLen
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnsureArray() As Boolean
		  if HasSetType <> kHasSetObject then
		    return true
		  else
		    
		    raise new JSONException( "This JSONItem_MTC is an object", 13 )
		    return false
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnsureObject() As Boolean
		  if HasSetType <> kHasSetArray then
		    return true
		  else
		    
		    raise new JSONException( "This JSONItem_MTC is an array", 13 )
		    return false
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasName(name As String) As Boolean
		  if not EnsureObject() then
		    return false
		  end if
		  
		  HasSetType = kHasSetObject
		  dim key as string = NameToKey( name )
		  return ObjectValues.HasKey( key )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HasName(Name as Variant)
		  Raise New RuntimeException("not implemented")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Insert(index As Integer, value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  HasSetType = kHasSetArray
		  ArrayValues.Insert( index, value )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsArray() As Boolean
		  Return IsArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsLoading() As Boolean
		  return mIsLoading
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function JSONStringToUTF8(s As String) As String
		  // Ensures that the given string is converted to UTF8.
		  //
		  // A string obtained from an unknown source might be nil or might 
		  // be marked as the wrong encoding, so we won't trust it
		  // and will check ourselves.
		  //
		  // Since the string must start with characters in the ASCII range
		  // (whitespace, {, or [), we only need the first four bytes.
		  
		  static null as string = ChrB( 0 )
		  static doubleNull as string  = null + null
		  static tripleNull as string = null + null + null
		  
		  dim firstFour as string = s.LeftB( 4 )
		  if firstFour.LenB < 2 or firstFour.LenB = 3 then
		    return s.DefineEncoding( Encodings.UTF8 )
		  end if
		  
		  // 
		  // Check for BOM
		  //
		  if true then // Scope
		    static bomArr() as string = Array( _
		    ChrB( &hFF ) + ChrB( &hFE ) + doubleNull, _
		    doubleNull + ChrB( &hFE ) + ChrB( &hFF ), _
		    ChrB( &hEF ) + ChrB( &hBB ) + ChrB( &hBF ), _
		    ChrB( &hFF ) + ChrB( &hFE ), _
		    ChrB( &hFE ) + ChrB( &hFF ) _
		    )
		     
		    for i as integer = 0 to bomArr.Ubound
		      dim bom as string = bomArr( i )
		      dim bomLen as integer = bom.LenB
		      if firstFour.LeftB( bomLen ) = bom then
		        s = s.MidB( bomLen + 1 )
		        firstFour = s.LeftB( 4 )
		        exit
		      end if
		    next i
		  end if
		  
		  // Check for UTF8
		  if firstFour.InStrB( null ) = 0 then
		    return s.DefineEncoding( Encodings.UTF8 )
		  end if
		  
		  // UTF32?
		  if firstFour.LenB = 4 then
		    if firstFour.LeftB( 3 ) = tripleNull then
		      s = s.DefineEncoding( Encodings.UTF32BE )
		      return s.ConvertEncoding( Encodings.UTF8 )
		    end if
		    if firstFour.RightB( 3 ) = tripleNull then
		      s = s.DefineEncoding( Encodings.UTF32LE )
		      return s.ConvertEncoding( Encodings.UTF8 )
		    end if
		  end if
		  
		  // UTF16?
		  if firstFour.LeftB( 1 ) = null then
		    s = s.DefineEncoding( Encodings.UTF16BE )
		    return s.ConvertEncoding( Encodings.UTF8 )
		  end if
		  if firstFour.RightB( 1 ) = null then
		    s = s.DefineEncoding( Encodings.UTF16LE )
		    return s.ConvertEncoding( Encodings.UTF8 )
		  end if
		  
		  // We don't know what the heck it is
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function KeyToName(key As String) As String
		  dim hex as string = key.NthField( "-", key.CountFields( "-" ) )
		  dim name as string = key.LeftB( key.LenB - hex.LenB - 1 )
		  return name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Load(JSONString As String)
		  const kNeverStarted = -1000
		  
		  dim originalSetType as integer = kNeverStarted
		  dim originalValue as variant
		  
		  if not LoadCS.TryEnter then
		    raise new JSONException( "This object is currently loading", 0 )
		    return
		  end if
		  
		  JSONString = JSONStringToUTF8( JSONString ).RTrim
		  
		  if JSONString = "" then
		    
		    // Do nothing
		    
		  else
		    
		    mIsLoading = true
		    
		    //
		    // Save original values
		    //
		    originalSetType = self.HasSetType
		    if originalSetType = kHasSetArray then
		      dim values() as variant
		      redim values( ArrayValues.Ubound )
		      for i as integer = 0  to ArrayValues.Ubound
		        values( i ) = ArrayValues( i )
		      next i
		      originalValue = values
		    elseif originalSetType = kHasSetObject then
		      dim d as new Dictionary
		      dim keys() as Variant = ObjectValues.Keys
		      for i as integer = 0 to keys.Ubound
		        dim k as variant = keys( i )
		        d.Value( k ) = ObjectValues.Value( k )
		      next i
		      originalValue = d
		    end if
		    
		    dim inMB as MemoryBlock = JSONString
		    dim pos as integer
		    dim inPtr as Ptr = inMB
		    
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    dim proceed as boolean = true
		    if inPtr.Byte( pos ) = kOpenSquareBracket then
		      if IsObject then
		        // Do nothing
		        proceed = false
		      else
		        HasSetType = kHasSetArray
		      end if
		      
		    elseif inPtr.Byte( pos ) = kOpenCurlyBrace then
		      if IsArray then
		        // Do nothing
		        proceed = false
		      else
		        HasSetType = kHasSetObject
		      end if
		      
		    elseif inPtr.Byte( pos ) <> kOpenCurlyBrace and inPtr.Byte( pos ) <> kOpenSquareBracket then
		      raise new JSONException( "Parse Error: Expecting '{' or '['", 1 )
		      return
		      
		    end if
		    
		    if proceed then
		      
		      dim outMB as new MemoryBlock( 1024 )
		      
		      pos = pos + 1
		      dim stack() as JSONItem_MTC 
		      dim current as JSONItem_MTC = self
		      dim lastIndex as integer = inMB.Size - 1
		      do
		        if current.IsArray then
		          
		          if pos <= lastIndex and inPtr.Byte( pos ) < 33 then
		            self.AdvancePastWhiteSpace( inMB, pos )
		          end if
		          
		          if inPtr.Byte( pos ) = kCloseSquareBracket then // Empty array
		            if stack.Ubound <> -1 then
		              current = stack.Pop
		            else
		              current = nil
		            end if
		            pos = pos + 1
		            
		          else
		            LoadArray( inMB, pos, current, stack, outMB )
		            if pos <= lastIndex and inPtr.Byte( pos ) < 33 then
		              self.AdvancePastWhiteSpace( inMB, pos )
		            end if
		            
		          end if
		          
		        else
		          
		          if pos <= lastIndex and inPtr.Byte( pos ) < 33 then
		            self.AdvancePastWhiteSpace( inMB, pos )
		          end if
		          
		          if inPtr.Byte( pos ) = kCloseCurlyBrace then // Empty object
		            if stack.Ubound <> -1 then
		              current = stack.Pop
		            else
		              current = nil
		            end if
		            pos = pos + 1
		            
		          else
		            LoadObject( inMB, pos, current, stack, outMB )
		            if pos <= lastIndex and inPtr.Byte( pos ) < 33 then
		              self.AdvancePastWhiteSpace( inMB, pos )
		            end if
		            
		          end if
		          
		        end if
		        
		        if current is nil then
		          if pos <= lastIndex then
		            raise new JSONException( "A parsing error occurred", 2, pos )
		          end if
		          exit do
		          
		        elseif pos > lastIndex then
		          raise new JSONException( "A parsing error occurred", 2, pos )
		          exit do
		          
		        else
		          if inPtr.Byte( pos ) <  33 then
		            self.AdvancePastWhiteSpace( inMB, pos )
		          end if
		          if inPtr.Byte( pos ) = kComma then
		            pos = pos + 1
		          end if
		        end if
		      loop
		      
		    end if // proceed
		    
		  end if // JSONString = ""
		  
		  mIsLoading = false
		  LoadCS.Leave
		  
		  Exception err as RuntimeException
		    //
		    // Restore original values
		    //
		    if originalSetType <> kNeverStarted then
		      self.Clear
		      if originalSetType = kHasSetArray then
		        ArrayValues = originalValue
		      elseif originalSetType = kHasSetObject then
		        ObjectValues = originalValue
		      end if
		      
		      HasSetType = originalSetType
		    end if
		    
		    mIsLoading = False
		    LoadCS.Leave
		    
		    raise err
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadArray(inMB As MemoryBlock, ByRef pos As Integer, ByRef current As JSONItem_MTC, stack() As JSONItem_MTC, outMB As MemoryBlock)
		  dim inPtr As Ptr = inMB
		  
		  dim commaFound as boolean
		  
		  dim value as variant
		  
		  do
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    if inPtr.Byte( pos ) = kCloseSquareBracket then
		      if commaFound then
		        raise new JSONException( "Illegal Value", 10, pos )
		        exit do
		      end if
		      
		      pos = pos + 1
		      if stack.Ubound <> -1 then
		        current = stack.Pop
		      else
		        current = nil
		      end if
		      
		      exit do
		    end if
		    
		    value = DecodeValue( inMB, pos, current, outMB )
		    current.ArrayValues.Append value
		    
		    if value IsA JSONItem_MTC then
		      stack.Append current
		      current = value
		      exit do
		    end if
		    
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    commaFound = false
		    if inPtr.Byte( pos ) = kComma then
		      pos = pos + 1
		      commaFound = true
		    elseif inPtr.Byte( pos ) <> kCloseSquareBracket then
		      raise new JSONException( "A parsing error occurred", 2, pos + 1 )
		      exit do
		    end if
		  loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadObject(inMB As MemoryBlock, ByRef pos As Integer, ByRef current As JSONItem_MTC, stack() As JSONItem_MTC, outMB As MemoryBlock)
		  dim inPtr As Ptr = inMB
		  
		  dim name as string
		  dim key as string
		  dim value as variant
		  
		  do
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if 
		    
		    if inPtr.Byte( pos ) = kCloseCurlyBrace then
		      pos = pos + 1
		      
		      if stack.Ubound <> -1 then
		        current = stack.Pop
		      else
		        current = nil
		      end if
		      
		      exit do
		    end if
		    
		    name = DecodeString( inMB, pos, current, outMB )
		    
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    if inPtr.Byte( pos ) <> kColon then
		      // Something is wrong
		      raise new JSONException( "Missing :", 5, pos + 1 )
		      exit do
		    end if
		    pos = pos + 1
		    
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    value = DecodeValue( inMB, pos, current, outMB )
		    key = NameToKey( name )
		    current.ObjectValues.Value( key ) = value
		    
		    if value IsA JSONItem_MTC then
		      stack.Append current
		      current = value
		      exit do
		    end if
		    
		    if inPtr.Byte( pos ) < 33 then
		      self.AdvancePastWhiteSpace( inMB, pos )
		    end if
		    
		    if inPtr.Byte( pos ) = kComma then
		      pos = pos + 1
		    end if
		  loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(name As String, defaultValue As Variant) As Variant
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  dim key as string = NameToKey( name )
		  return ObjectValues.Lookup( key, defaultValue )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(index As Integer) As String
		  if not EnsureObject() then
		    return ""
		  end if
		  
		  dim key as string = ObjectValues.Key( index ).StringValue
		  dim name as string = KeyToName( key )
		  
		  return name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NameAt(index as integer) As String
		  If IsArray Then
		    Return ""
		  Else 
		    Var names() As String = Me.Names
		    Return names(index)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Names() As String()
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  dim d as Dictionary = ObjectValues
		  dim keys() as variant = d.Keys
		  dim r() as string
		  redim r( keys.Ubound )
		  for i as integer = 0 to keys.Ubound
		    dim name as string = keys( i )
		    name = KeyToName( name )
		    r( i ) = name
		  next i
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NameToKey(name As String) As String
		  name = name.ConvertEncoding( Encodings.UTF8 )
		  dim key as string = name + "-" + EncodeHex( name )
		  return key
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Compare(compare As JSONItem_MTC) As Integer
		  if compare is nil then
		    return 1
		  end if
		  
		  if Count <> compare.Count then
		    return Count - compare.Count
		    
		  elseif Count = 0 then
		    return 0
		    
		  end if
		  
		  if IsObject <> compare.IsObject then
		    return -1 // Meaningless, really
		  end if
		  
		  //
		  // Same count, same type, let's dive in
		  //
		  dim result as integer
		  
		  if IsArray then
		    dim arr1() as variant = self.ArrayValues
		    dim arr2() as variant = compare.ArrayValues
		    
		    for i as integer = 0 to arr1.Ubound
		      dim v1 as variant = arr1( i )
		      dim v2 as variant = arr2( i )
		      
		      result = CompareValues( v1, v2 )
		      if result <> 0 then
		        exit
		      end if
		    next
		    
		  else // IsObject
		    dim d1 as Dictionary = self.ObjectValues
		    dim d2 as Dictionary = compare.ObjectValues
		    
		    //
		    // Since we know the count is the same, every key and value must match
		    //
		    dim keys() as variant = d1.Keys
		    dim values() as variant = d1.Values
		    for i as integer = 0 to keys.Ubound
		      dim key as variant = keys( i )
		      
		      if not d2.HasKey( key ) then
		        result = 1 // Meaningless
		        exit
		      end if
		      
		      dim v1 as variant = values( i )
		      dim v2 as variant = d2.Value( key )
		      
		      result = CompareValues( v1, v2 )
		      if result <> 0 then
		        exit
		      end if
		    next
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As Dictionary
		  if IsArray then
		    raise new TypeMismatchException
		  else
		    dim d as Dictionary = Dictionary( ToNativeValue )
		    if d is nil then
		      d = new Dictionary
		    end if
		    return d
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As Variant()
		  if IsObject then
		    raise new TypeMismatchException
		  else
		    dim arr() as variant
		    dim native as variant = ToNativeValue
		    if not native.IsNull then
		      arr = native
		    end if
		    return arr
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Boolean)
		  self.Constructor()
		  
		  for each v as boolean in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Currency)
		  self.Constructor()
		  
		  for each v as currency in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(d As Dictionary)
		  self.Constructor()
		  
		  dim keys() as variant = d.Keys
		  dim values() as variant = d.Values
		  for i as integer = 0 to keys.Ubound
		    dim name as string = keys( i )
		    dim value as variant = values( i )
		    self.Value( name ) = value
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Double)
		  self.Constructor()
		  
		  for each v as double in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Int32)
		  self.Constructor()
		  
		  for each v as Int32 in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Int64)
		  self.Constructor()
		  
		  for each v as Int64 in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Object)
		  self.Constructor()
		  
		  for each v as object in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Single)
		  self.Constructor()
		  
		  for each v as single in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As String)
		  self.Constructor()
		  
		  for each v as string in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Text)
		  self.Constructor()
		  
		  for each v as text in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(arr() As Variant)
		  self.Constructor()
		  
		  for each v as variant in arr
		    self.Append v
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subscript(index As Integer) As Variant
		  return self.Value( index )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Subscript(index As Integer, Assigns value As Variant)
		  self.Value( index ) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ParseJSON(s As String) As Variant
		  dim j as new JSONItem_MTC( s )
		  return j.ToNativeValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseNumber(mb As MemoryBlock, startPos As Integer, endPos As Integer, ByRef result As Variant) As Boolean
		  if endPos >= mb.Size then
		    endPos = mb.Size - 1
		  end if
		  
		  if endPos <= startPos then
		    return false
		  end if
		  
		  dim p as Ptr = mb
		  
		  dim dotFound as boolean
		  dim inExponent as boolean
		  dim r as boolean = true
		  
		  dim pos as integer = startPos
		  dim thisByte as integer = p.Byte( pos )
		  
		  dim isNegative as boolean
		  if thisByte = kHyphen then
		    isNegative = true
		    pos = pos + 1
		  elseif thisByte = kPlus then
		    pos = pos + 1
		  end if
		  
		  dim total as Int64
		  
		  do
		    thisByte = p.Byte( pos )
		    select case thisByte
		    case kDot
		      if dotFound or inExponent then
		        r = false
		        exit do
		      else
		        dotFound = true
		        pos = pos + 1
		      end if
		      
		    case 48 to 57
		      if not dotFound and not inExponent then
		        total = ( total * 10 ) + ( thisByte - 48 )
		      end if
		      pos = pos + 1
		      
		    case 101, 69 // e, E
		      if inExponent then
		        r = false
		        exit do
		      elseif Strict and dotFound and p.Byte( pos - 1 ) = kDot then
		        r = false
		        exit do
		      else
		        inExponent = true
		        pos = pos + 1
		        if pos > endPos then
		          r = false
		          exit do
		        else
		          thisByte = p.Byte( pos )
		          if thisByte = 45 or thisByte = 43 then
		            pos = pos + 1
		            if pos > endPos then
		              r = false
		              exit do
		            end if
		          end if
		        end if
		      end  if
		      
		    else
		      r = false
		      exit do
		      
		    end select
		  loop until pos > endPos
		  
		  if r and Strict and dotFound and ( p.Byte( endPos ) < 48 or p.Byte( endPos ) > 57 ) then
		    r = false
		  end if
		  
		  if r then
		    if not dotFound and not inExponent then // Integer
		      
		      if isNegative then
		        total = 0 - total
		      end if
		      result = total
		      
		    else
		      
		      dim s as string = mb.StringValue( startPos, endPos - startPos + 1 )
		      result = Val( s )
		      
		    end if
		  end if
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(index As Integer)
		  if not EnsureArray() then
		    return
		  end if
		  
		  ArrayValues.Remove( index )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(name As String)
		  if not EnsureObject() then
		    return
		  end if
		  
		  dim key as string = NameToKey( name )
		  ObjectValues.Remove( key )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  Redim ArrayValues(-1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(Index as Integer)
		  Raise New RuntimeException("not implemented")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Serialize(data As JSONItem_MTC) As String
		  //
		  // Most JSON will be rather small, so we'll start with a small initial block
		  
		  const kInitialMBSize = 10 * 1024
		  
		  dim outMB as new MemoryBlock( kInitialMBSize )
		  dim outMBs() as MemoryBlock
		  outMBs.Append outMB
		  dim outIndex as integer
		  
		  dim inMB as new MemoryBlock( kInMBSize )
		  
		  data.Serialize( outMBs, outIndex, self, 0, inMB)
		  
		  //
		  // We know exactly how long the last MemoryBlock's data is
		  // in outIndex
		  //
		  
		  dim joiner() as string 
		  redim joiner( outMBs.Ubound)
		  
		  for i as integer = 0  to outMBs.Ubound
		    #if DebugBuild
		      if i = 1 then
		        i = i // A place to break
		      end if
		    #endif
		    
		    outMB = outMBs( i )
		    outMBs( i ) = nil
		    
		    dim s as string
		    if i = outMBs.Ubound then
		      
		      s = outMB.StringValue( 0, outIndex )
		      
		    else
		      //
		      // Scan for the final null
		      //
		      dim lastBytePos as integer = outMB.Size - 1
		      dim p as Ptr = outMB
		      for bytePos as integer = lastBytePos downto 0
		        if p.Byte( bytePos ) <> 0 then
		          s = outMB.StringValue( 0, bytePos + 1 )
		          exit for bytePos
		        end if
		      next bytePos
		      
		    end if
		    
		    outMB = nil
		    
		    if s = "" then
		      raise new JSONException( "Couldn't find non-null bytes in a MemoryBlock", 0 )
		    end if
		    
		    s = s.DefineEncoding( Encodings.UTF8 )
		    joiner( i ) = s
		  next i
		  
		  dim r as string = join( joiner, "" )
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Serialize(outMBs() As MemoryBlock, ByRef outIndex As Integer, settings As JSONItem_MTC, level As Integer, inMB As MemoryBlock)
		  dim outMB as MemoryBlock = outMBs( outMBs.Ubound )
		  
		  level = level + 1
		  dim notCompact as boolean = not( settings.Compact ) and settings.IndentSpacing > 0
		  
		  static lotsOfSpaces as string = "        "
		  
		  dim indenter as string
		  if notCompact then
		    dim targetLen as integer = level * settings.IndentSpacing
		    while lotsOfSpaces.LenB < targetLen
		      lotsOfSpaces = lotsOfSpaces + lotsOfSpaces
		    wend
		    indenter = lotsOfSpaces.LeftB( targetLen )
		  end if
		  
		  //
		  // Always keep at least a 1024 byte buffer at the end of the outMB
		  //
		  dim outSize as integer = outMB.Size
		  if outIndex > ( outSize - 1024 ) then
		    outMB = AppendOutMB( outMBs, outIndex )
		    outSize = outMB.Size
		  end if
		  
		  dim outPtr as Ptr = outMB
		  
		  if IsArray then
		    
		    outPtr.Byte( outIndex ) = kOpenSquareBracket
		    outIndex = outIndex + 1
		    
		    if ArrayValues.Ubound <> -1 then
		      if notCompact then
		        #if TargetWin32
		          outPtr.Byte( outIndex ) = 13
		          outIndex = outIndex + 1
		        #endif
		        outPtr.Byte( outIndex ) = 10
		        outIndex = outIndex + 1
		      end if
		      
		      for i as integer = 0 to ArrayValues.Ubound
		        if outIndex > ( outSize - 1024 ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		          outPtr = outMB
		        end if
		        
		        if notCompact then
		          outMB.StringValue( outIndex, indenter.LenB ) = indenter
		          outIndex = outIndex + indenter.LenB
		        end if
		        
		        dim value as variant = ArrayValues( i )
		        EncodeValue( value, settings, level, outMBs, outIndex, inMB )
		        
		        outMB = outMBs( outMBs.Ubound )
		        outSize = outMB.Size
		        if outIndex > ( outSize - 1024 ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		        end if
		        outPtr = outMB
		        
		        if i < ArrayValues.Ubound then
		          outPtr.Byte( outIndex ) = kComma
		          outIndex = outIndex + 1
		        end if
		        if notCompact then
		          #if TargetWin32
		            outPtr.Byte( outIndex ) = 13
		            outIndex = outIndex + 1
		          #endif
		          outPtr.Byte( outIndex ) = 10
		          outIndex = outIndex + 1
		        end if
		      next i
		      
		      if outIndex > ( outSize - 1024 ) then
		        outMB = AppendOutMB( outMBs, outIndex )
		        outSize = outMB.Size
		        outPtr = outMB
		      end if
		      
		      if notCompact then
		        if outIndex > ( outSize - indenter.LenB ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		          outPtr = outMB
		        end if
		        
		        outMB.StringValue( outIndex, indenter.LenB - settings.IndentSpacing ) = indenter.LeftB( indenter.LenB - indentSpacing )
		        outIndex = outIndex + ( indenter.LenB - settings.IndentSpacing )
		      end if
		    end if
		    
		    if outIndex > ( outSize - 1024 ) then
		      outMB = AppendOutMB( outMBs, outIndex )
		      outSize = outMB.Size
		      outPtr = outMB
		    end if
		    
		    outPtr.Byte( outIndex ) = kCloseSquareBracket
		    outIndex = outIndex + 1
		    
		  else
		    
		    dim d as Dictionary = ObjectValues
		    
		    outPtr.Byte( outIndex ) = kOpenCurlyBrace
		    outIndex = outIndex + 1
		    
		    if d.Count <> 0 then
		      if notCompact then
		        #if TargetWin32
		          outPtr.Byte( outIndex ) = 13
		          outIndex = outIndex + 1
		        #endif
		        outPtr.Byte( outIndex ) = 10
		        outIndex = outIndex + 1
		      end if
		      
		      dim keys() as variant = d.Keys
		      for i as integer = 0 to keys.Ubound
		        if outIndex > ( outSize - 1024 ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		          outPtr = outMB
		        end if
		        
		        if notCompact then
		          outMB.StringValue( outIndex, indenter.LenB ) = indenter
		          outIndex = outIndex + indenter.LenB
		        end if
		        
		        dim key as variant = keys( i )
		        dim name as string = KeyToName( key )
		        EncodeString( name, settings, outMBs, outIndex, inMB )
		        
		        outMB = outMBs( outMBs.Ubound )
		        outSize  = outMB.Size
		        if outIndex > ( outSize - 1 ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		        end if
		        outPtr = outMB
		        
		        outPtr.Byte( outIndex ) = kColon
		        outIndex = outIndex + 1
		        
		        dim value as variant = d.Value( key )
		        EncodeValue( value, settings, level, outMBs, outIndex, inMB )
		        
		        outMB = outMBs( outMBs.Ubound )
		        outSize  = outMB.Size
		        if outIndex > ( outSize - 1024 ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		        end if
		        outPtr = outMB
		        
		        if i < keys.Ubound then
		          outPtr.Byte( outIndex ) = kComma
		          outIndex = outIndex + 1
		        end if
		        if notCompact then
		          #if TargetWin32
		            outPtr.Byte( outIndex ) = 13
		            outIndex = outIndex + 1
		          #endif
		          outPtr.Byte( outIndex ) = 10
		          outIndex = outIndex + 1
		        end if
		      next
		      
		      if notCompact then
		        if outIndex > ( outSize - indenter.LenB ) then
		          outMB = AppendOutMB( outMBs, outIndex )
		          outSize = outMB.Size
		          outPtr = outMB
		        end if
		        
		        outMB.StringValue( outIndex, indenter.LenB - settings.IndentSpacing ) = indenter.LeftB( indenter.LenB - indentSpacing )
		        outIndex = outIndex + ( indenter.LenB - settings.IndentSpacing )
		      end if
		    end if
		    
		    if outIndex > ( outSize - 1024 ) then
		      outMB = AppendOutMB( outMBs, outIndex )
		      outSize = outMB.Size
		      outPtr = outMB
		    end if
		    
		    outPtr.Byte( outIndex ) = kCloseCurlyBrace
		    outIndex = outIndex + 1
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Validate(ByRef value As Variant)
		  //
		  // If value holds a Dictionary or Array,
		  // this will do the conversion and allow the new
		  // object to raise an exception if needed
		  //
		  
		  if value.IsArray then
		    dim jsonArr as JSONItem_MTC
		    
		    select case value.ArrayElementType
		    case Variant.TypeBoolean
		      dim arr() as boolean = value
		      jsonArr = arr
		      
		    case Variant.TypeDouble
		      dim arr() as double = value
		      jsonArr = arr
		      
		    case Variant.TypeInt32
		      dim arr() as Int32 = value
		      jsonArr = arr
		      
		    case Variant.TypeInt64
		      dim arr() as Int64 = value
		      jsonArr = arr
		      
		    case Variant.TypeSingle
		      dim arr() as single = value
		      jsonArr = arr
		      
		    case Variant.TypeString
		      dim arr() as string = value
		      jsonArr = arr
		      
		    case Variant.TypeText
		      dim arr() as text = value
		      jsonArr = arr
		      
		    case Variant.TypeObject
		      dim arr() as object = value
		      jsonArr = arr
		      
		    case else
		      raise new JSONException( "Illegal Value", 10 )
		      
		    end select
		    
		    
		    value = jsonArr
		    
		  else
		    
		    select case value.Type
		    case Variant.TypeNil, Variant.TypeBoolean
		      
		    case Variant.TypeString, Variant.TypeCString, Variant.TypePString, Variant.TypeText
		      
		    case Variant.TypeDouble, Variant.TypeSingle, Variant.TypeCurrency
		      
		    case Variant.TypeInt32, Variant.TypeInt64, Variant.TypeInteger
		      
		    case Variant.TypeObject
		      select case value
		      case IsA JSONItem_MTC
		      case IsA Dictionary  
		        dim dictJSON as JSONItem_MTC = Dictionary( value )
		        value = dictJSON
		      case IsA JsonItem
		        dim item As String = JsonItem(value).ToString
		        if item = "" Then
		          value = New JSONItem_MTC
		        else
		          dim dictJSON as JSONItem_MTC = JSONItem_MTC.ParseJSON(JsonItem(value).ToString)
		          value = dictJSON
		        end if
		        
		      else
		        raise new JSONException( "Unrecognized Object", 11 )
		      end select
		      
		    else
		      raise new JSONException( "Illegal Value", 10 )
		    end
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(index As Integer) As Variant
		  if not EnsureArray() then
		    return nil
		  end if
		  
		  return ArrayValues( index )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(index As Integer, Assigns value As Variant)
		  if not EnsureArray() then
		    return
		  end if
		  
		  Validate( value )
		  
		  HasSetType = kHasSetArray
		  if ArrayValues.Ubound < index then
		    ArrayValues.Append value
		  else
		    ArrayValues( index ) = value
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(name As String) As Variant
		  if not EnsureObject() then
		    return nil
		  end if
		  
		  dim key as string = NameToKey( name )
		  return ObjectValues.Value( key )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(name As String, Assigns value As Variant)
		  if not EnsureObject then
		    return
		  end if
		  
		  Validate( value )
		  
		  HasSetType = kHasSetObject
		  dim key as string = NameToKey( name )
		  ObjectValues.Value( key ) = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAt(index as Integer) As Variant
		  Return ArrayValues(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValueAt(index As Integer, Assigns Value As Variant)
		  ArrayValues(index) = Value
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		JSONItem_MTC
		
		This is a drop-in replacements for the native JSONItem. It emulates all its features but should
		perform certain functions faster.
		
		To use it, search for "JSONItem" within your project and replace it with "JSONItem_MTC". Then
		drag the JSONItem_MTC class into your project.
		
		Differences:
		
		- You can add any object to JSONItem and it will throw an exception when you try to use ToString.
		This class will throw that exception when you try to add the bad object.
		
		- This class has an extra property, EncodeUnicode. By default, it is False to emulate the native class. 
		If set to True, it will encode all characters whose codepoints are greater than 127.
		
		- Some error messages will be different within this class than the native class.
		
		- As of Xojo 2014r21, ToString is significantly faster in this class than the native version.
		
		See the Legal note for licensing information. If you do make useful modifications, please let me 
		know so I can include them in future versions.
		
		Kem Tekinay
		ktekinay@mactechnologies.com
		http://www.mactechnologies.com
		
		Original project at:
		https://github.com/ktekinay/JSONItem_MTC
		
	#tag EndNote

	#tag Note, Name = Acknowledgements
		With thanks to Jeremy Cowgar for his suggestions and adding the unit testing framework.
		
		With thanks for Paul Lefebvre of Xojo, Inc., for creating the unit testing framework in the first place.
		
	#tag EndNote

	#tag Note, Name = Legal
		This class was created by Kem Tekinay, MacTechnologies Consulting (ktekinay@mactechnologies.com).
		It is copyright ©2015 by Kem Tekinay, all rights reserved.
		
		This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied.
		The author disavows any responsibility for bad design, poor execution, or any other faults.
		
		You may freely use or modify this project or any part within. You may distribute a modified version as long 
		as this notice or any other legal notice is left undisturbed and all modifications are clearly documented and 
		accredited. The author does not actively support this class, although comments and recommendations are 
		welcome.
		
	#tag EndNote

	#tag Note, Name = Specs (RFC)
		This class follows the specs in RFC 7159 found, among other places, here:
		
		http://tools.ietf.org/html/rfc7159
		
	#tag EndNote


	#tag Property, Flags = &h1
		Protected ArrayValues() As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Compact As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if IsArray then
			    return ArrayValues.Ubound + 1
			  elseif ObjectValues <> nil then
			    return ObjectValues.Count
			  else
			    return 0
			  end if
			  
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		DecimalFormat As String
	#tag EndProperty

	#tag Property, Flags = &h0
		EncodeUnicode As EncodeType = EncodeType.JavaScriptCompatible
	#tag EndProperty

	#tag Property, Flags = &h0
		EscapeSlashes As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HasSetType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IndentSpacing As Integer = 2
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return HasSetType = kHasSetArray
			  
			End Get
		#tag EndGetter
		IsArray As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return HasSetType = kHasSetObject
			  
			End Get
		#tag EndGetter
		Private IsObject As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private LoadCS As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsLoading As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ObjectValues As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Strict As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if IsObject then
			    dim d as Dictionary = new Dictionary
			    
			    dim rawKeys() as variant = ObjectValues.Keys
			    dim values() as variant = ObjectValues.Values
			    
			    for i as integer = 0 to rawKeys.Ubound
			      dim name as string = KeyToName( rawKeys( i ) )
			      dim value as variant = values( i )
			      
			      if value isa JSONItem_MTC then
			        value = JSONItem_MTC( value ).ToNativeValue
			      end if
			      
			      d.Value( name ) = value
			    next
			    
			    return d
			    
			  elseif IsArray then
			    dim arr() as variant
			    redim arr( ArrayValues.Ubound )
			    
			    for i as integer = 0 to ArrayValues.Ubound
			      dim value as variant = ArrayValues( i )
			      if value isa JSONItem_MTC then
			        value = JSONItem_MTC( value ).ToNativeValue
			      end if
			      
			      arr( i ) = value
			    next
			    
			    return arr
			    
			  else
			    
			    return nil
			    
			  end if
			End Get
		#tag EndGetter
		ToNativeValue As Variant
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Serialize( self )
			End Get
		#tag EndGetter
		ToString As String
	#tag EndComputedProperty


	#tag Constant, Name = kBackSlash, Type = Double, Dynamic = False, Default = \"92", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseCurlyBrace, Type = Double, Dynamic = False, Default = \"125", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseSquareBracket, Type = Double, Dynamic = False, Default = \"93", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kColon, Type = Double, Dynamic = False, Default = \"58", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kComma, Type = Double, Dynamic = False, Default = \"44", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDefaultDecimalFormat, Type = String, Dynamic = False, Default = \"\"-#.0##########\"", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kDot, Type = Double, Dynamic = False, Default = \"46", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kForwardSlash, Type = Double, Dynamic = False, Default = \"47", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetArray, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetNone, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHasSetObject, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHyphen, Type = Double, Dynamic = False, Default = \"45", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kInMBSize, Type = Double, Dynamic = False, Default = \"2048", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenCurlyBrace, Type = Double, Dynamic = False, Default = \"123", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOpenSquareBracket, Type = Double, Dynamic = False, Default = \"91", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOutMBSize, Type = Double, Dynamic = False, Default = \"2097152", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPlus, Type = Double, Dynamic = False, Default = \"43", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kQuote, Type = Double, Dynamic = False, Default = \"34", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"4.2", Scope = Public
	#tag EndConstant


	#tag Enum, Name = EncodeType, Type = Integer, Flags = &h0
		None = 0
		  JavaScriptCompatible = 1
		All = 2
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Compact"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DecimalFormat"
			Visible=false
			Group="Behavior"
			InitialValue="-0.0##############"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EscapeSlashes"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndentSpacing"
			Visible=false
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsArray"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Strict"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ToString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EncodeUnicode"
			Visible=false
			Group="Behavior"
			InitialValue="EncodeType.JavaScriptCompatible"
			Type="EncodeType"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - JavaScriptCompatible"
				"2 - All"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
