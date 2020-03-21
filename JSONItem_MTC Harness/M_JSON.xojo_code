#tag Module
Protected Module M_JSON
	#tag Method, Flags = &h21
		Private Sub AdvancePastWhiteSpace(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer)
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  dim mbSize as integer = mb.Size
		  while bytePos < mbSize
		    dim thisByte as integer = p.Byte( bytePos )
		    select case thisByte
		    case kTab, kLinefeed, kReturn, kSpace
		      bytePos = bytePos + 1
		    case else
		      return
		    end select
		  wend
		  
		  raise new JSONException( "Unexpected end of data", 2, bytePos )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeArray(value As Variant, level As Integer, ByRef outBuffer As MemoryBlock, ByRef outPtr As Ptr, ByRef outIndex As Integer, ByRef inBuffer As MemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  dim thisIndent as string
		  dim nextIndent as string
		  dim nextIndentLen as integer
		  const kComma as integer = 44
		  
		  dim prettyPrint as boolean = level > -1
		  
		  if prettyPrint then
		    ExpandIndentArr level + 1
		    thisIndent = IndentArr( level )
		    nextIndent = IndentArr( level + 1 )
		    nextIndentLen = nextIndent.LenB
		  end if
		  
		  dim isEmpty as boolean = true
		  
		  ExpandOutBuffer 10, outBuffer, outPtr, outIndex
		  outPtr.Byte( outIndex ) = kSquareBracket
		  outIndex = outIndex + 1
		  
		  select case value.ArrayElementType
		  case Variant.TypeObject
		    //
		    // Can't go directly from variant, have to pass through auto
		    //
		    dim autoValue as auto = value
		    dim arr() as object = autoValue
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      EncodeValue arr( i ), level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeString
		    dim arr() as string = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as string = arr( i )
		      EncodeString item, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeText
		    dim arr() as text = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as string = arr( i )
		      EncodeString item, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeDouble
		    dim arr() as double = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as double = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeSingle
		    dim arr() as single = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as single = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeInt32
		    dim arr() as Int32 = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as Int32 = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeInt64
		    dim arr() as Int64 = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as Int64 = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeInteger
		    dim arr() as Integer = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as Integer = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case Variant.TypeBoolean
		    dim arr() as boolean = value
		    if arr.Ubound <> -1 then
		      isEmpty = false
		    end if
		    
		    for i as integer = 0 to arr.Ubound
		      if prettyPrint then
		        ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		        outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		        outIndex = outIndex + nextIndentLen
		      end if
		      dim item as boolean = arr( i )
		      EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		      if i < arr.Ubound then
		        outPtr.Byte( outIndex ) = kComma
		        outIndex = outIndex + 1
		      end if
		    next
		    
		  case else
		    //
		    // Auto() ?
		    //
		    if Introspection.GetType( value ).Name = "Auto()" then
		      
		      dim autoValue as auto = value
		      dim arr() as auto = autoValue
		      if arr.Ubound <> -1 then
		        isEmpty = false
		      end if
		      
		      for i as integer = 0 to arr.Ubound
		        if prettyPrint then
		          ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		          outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		          outIndex = outIndex + nextIndentLen
		        end if
		        dim item as variant = arr( i )
		        EncodeValue item, level + 1, outBuffer, outPtr, outIndex, inBuffer
		        if i < arr.Ubound then
		          outPtr.Byte( outIndex ) = kComma
		          outIndex = outIndex + 1
		        end if
		      next
		      
		    else
		      
		      raise new IllegalCastException
		      
		    end if
		    
		  end select
		  
		  ExpandOutBuffer nextIndentLen + 2, outBuffer, outPtr, outIndex
		  if prettyPrint and not isEmpty then
		    outBuffer.StringValue( outIndex, thisIndent.LenB ) = thisIndent
		    outIndex = outIndex + thisIndent.LenB
		  end if
		  
		  outPtr.Byte( outIndex ) = kCloseSquareBracket
		  outIndex = outIndex + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeDictionary(dict As Dictionary, level As Integer, ByRef outBuffer As MemoryBlock, ByRef outPtr As Ptr, ByRef outIndex As Integer, ByRef inBuffer As MemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kColon as integer = 58
		  
		  dim prettyPrint as boolean = level > -1
		  
		  dim keys() as variant = dict.Keys
		  dim values() as variant = dict.Values
		  
		  ExpandOutBuffer ( keys.Ubound + 1 ) * 20 + 5, outBuffer, outPtr, outIndex
		  
		  dim thisIndent as string
		  dim nextIndent as string
		  dim nextIndentLen as integer
		  const kComma as integer = 44
		  dim colon as string = ":"
		  dim colonLen as integer = 1
		  if prettyPrint then
		    ExpandIndentArr( level + 1 )
		    thisIndent = IndentArr( level )
		    nextIndent = IndentArr( level + 1 )
		    nextIndentLen = nextIndent.LenB
		    colon = " : "
		    colonLen = 3
		  end if
		  
		  outBuffer.Byte( outIndex ) = kCurlyBrace
		  outIndex = outIndex + 1
		  
		  if keys.Ubound = -1 then
		    outBuffer.Byte( outIndex ) = kCloseCurlyBrace
		    outIndex = outIndex + 1
		    return
		  end if
		  
		  for i as integer = 0 to keys.Ubound
		    dim key as string = keys( i ).StringValue
		    dim value as variant = values( i )
		    
		    if prettyPrint then
		      ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		      outBuffer.StringValue( outIndex, nextIndentLen ) = nextIndent
		      outIndex = outIndex + nextIndentLen
		    end if
		    
		    EncodeString key, outBuffer, outPtr, outIndex, inBuffer
		    ExpandOutBuffer colonLen, outBuffer, outPtr, outIndex
		    if prettyPrint then
		      outBuffer.StringValue( outIndex, colonLen ) = colon
		    else
		      outPtr.Byte( outIndex ) = kColon
		    end if
		    outIndex = outIndex + colonLen
		    
		    EncodeValue value, level + 1, outBuffer, outPtr, outIndex, inBuffer
		    if i < keys.Ubound then
		      ExpandOutBuffer 1, outBuffer, outPtr, outIndex
		      outBuffer.Byte( outIndex ) = kComma
		      outIndex = outIndex + 1
		    end if
		  next
		  
		  if prettyPrint then
		    ExpandOutBuffer nextIndentLen, outBuffer, outPtr, outIndex
		    outBuffer.StringValue( outIndex, thisIndent.LenB ) = thisIndent
		    outIndex = outIndex + thisIndent.LenB
		  end if
		  
		  ExpandOutBuffer 1, outBuffer, outPtr, outIndex
		  outBuffer.Byte( outIndex ) = kCloseCurlyBrace
		  outIndex = outIndex + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeString(s As String, ByRef outBuffer As MemoryBlock, ByRef outPtr As Ptr, ByRef outIndex As Integer, ByRef inBuffer As MemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kB as integer = 98
		  const kF as integer = 102
		  const kN as integer = 110
		  const kR as integer = 114
		  const kT as integer = 116
		  const kU as integer = 117
		  
		  if s = "" then
		    ExpandOutBuffer 2, outBuffer, outPtr, outIndex
		    outBuffer.Byte( outIndex ) = kQuote
		    outBuffer.Byte( outIndex + 1 ) = kQuote
		    outIndex = outIndex + 2
		    return
		  end if
		  
		  if s.Encoding is nil then
		    if Encodings.UTF8.IsValidData( s ) then
		      s = s.DefineEncoding( Encodings.UTF8 )
		    else
		      s = s.DefineEncoding( Encodings.SystemDefault )
		      s = s.ConvertEncoding( Encodings.UTF8 )
		    end if
		    
		  elseif s.Encoding <> Encodings.UTF8 then
		    s = s.ConvertEncoding( Encodings.UTF8 )
		  end if
		  
		  dim sLen as integer = s.LenB
		  if inBuffer.Size < sLen then
		    inBuffer = new MemoryBlock( sLen * 2 )
		  end if
		  
		  inBuffer.StringValue( 0, sLen ) = s
		  dim pIn as ptr = inBuffer
		  
		  dim outSize as integer = sLen * 6 + 2
		  ExpandOutBuffer outSize, outBuffer, outPtr, outIndex
		  
		  dim pOut as ptr = outPtr
		  
		  pOut.Byte( outIndex ) = kQuote
		  outIndex = outIndex + 1
		  
		  dim lastInByte as integer = sLen - 1
		  for inIndex as integer = 0 to lastInByte
		    dim thisByte as integer = pIn.Byte( inIndex )
		    
		    select case thisByte
		    case kQuote, kBackslash
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      
		    case 8 // vertical tab
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kB
		      outIndex = outIndex + 1
		      
		    case 9 // tab
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kT
		      outIndex = outIndex + 1
		      
		    case 10 // linefeed
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kN
		      outIndex = outIndex + 1
		      
		    case 12 // form feed
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kF
		      outIndex = outIndex + 1
		      
		    case 13 // return
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kR
		      outIndex = outIndex + 1
		      
		    case is < 16 // have to encode it
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kU
		      outIndex = outIndex + 1
		      outBuffer.StringValue( outIndex, 3 ) = "000"
		      outIndex = outIndex + 3
		      outBuffer.StringValue( outIndex, 1 ) = Hex( thisByte )
		      outIndex = outIndex + 1
		      
		    case is < 32 // have to encode it
		      pOut.Byte( outIndex ) = kBackslash
		      outIndex = outIndex + 1
		      pOut.Byte( outIndex ) = kU
		      outIndex = outIndex + 1
		      outBuffer.StringValue( outIndex, 2 ) = "00"
		      outIndex = outIndex + 2
		      outBuffer.StringValue( outIndex, 2 ) = Hex( thisByte )
		      outIndex = outIndex + 2
		      
		    case else
		      pOut.Byte( outIndex ) = thisByte
		      outIndex = outIndex + 1
		      
		    end select
		    
		  next
		  
		  pOut.Byte( outIndex ) = kQuote
		  outIndex = outIndex + 1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncodeValue(value As Variant, level As Integer, ByRef outBuffer As MemoryBlock, ByRef outPtr As Ptr, ByRef outIndex As Integer, ByRef inBuffer As MemoryBlock)
		  //
		  // We don't know if this is being called from a broader encoder so
		  // we only append the raw value here
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if value.IsNull then
		    ExpandOutBuffer 4, outBuffer, outPtr, outIndex
		    outBuffer.StringValue( outIndex, 4 ) = "null"
		    outIndex = outIndex + 4
		    return // EARLY RETURN
		  end if
		  
		  select case value.Type
		  case Variant.TypeBoolean
		    ExpandOutBuffer 6, outBuffer, outPtr, outIndex
		    if value.BooleanValue then
		      outBuffer.StringValue( outIndex, 4 ) = "true"
		      outIndex = outIndex + 4
		    else
		      outBuffer.StringValue( outIndex, 5 ) = "false"
		      outIndex = outIndex + 5
		    end if
		    
		  case Variant.TypeInt32, Variant.TypeInt64, Variant.TypeInteger
		    dim s as string = value.StringValue
		    dim sLen as integer = s.LenB
		    ExpandOutBuffer sLen, outBuffer, outPtr, outIndex
		    outBuffer.StringValue( outIndex, sLen ) = s
		    outIndex = outIndex + sLen
		    
		  case Variant.TypeDouble, Variant.TypeSingle
		    dim d as double = value.DoubleValue
		    dim dAbs as double = abs( d )
		    
		    dim s as string
		    if dAbs > ( 10.0 ^ 12.0 ) or dAbs < 0.00001 then
		      s = value.StringValue
		    else
		      s = format( d, "-0.0########" )
		    end if
		    dim sLen as integer = s.LenB
		    ExpandOutBuffer sLen, outBuffer, outPtr, outIndex
		    outBuffer.StringValue( outIndex, sLen ) = s
		    outIndex = outIndex + sLen
		    
		  case Variant.TypeString
		    EncodeString( value.StringValue, outBuffer, outPtr, outIndex, inBuffer )
		    
		  case Variant.TypeText
		    dim t as text = value.TextValue
		    dim s as string = t
		    EncodeString( s, outBuffer, outPtr, outIndex, inBuffer )
		    
		  case Variant.TypeDate
		    EncodeString( value.DateValue.SQLDateTime, outBuffer, outPtr, outIndex, inBuffer )
		    
		  case else
		    if value.Type = Variant.TypeObject and value isa Dictionary then
		      EncodeDictionary( value, level, outBuffer, outPtr, outIndex, inBuffer )
		    elseif value.IsArray then
		      EncodeArray( value, level, outBuffer, outPtr, outIndex, inBuffer )
		    end if
		    
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExpandIndentArr(targetUbound As Integer)
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if IndentArr.Ubound < targetUbound then
		    dim startingIndex as integer = IndentArr.Ubound + 1
		    if startingIndex = 0 then
		      startingIndex = 1
		    end if
		    
		    redim IndentArr( targetUbound )
		    if IndentArr( 0 ) = "" then
		      IndentArr( 0 ) = EndOfLine
		    end if
		    
		    for i as integer = startingIndex to targetUbound
		      IndentArr( i ) = IndentArr( i - 1 ) + kDefaultIndent
		    next
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExpandOutBuffer(additionalBytes As Integer, ByRef outBuffer As MemoryBlock, ByRef outPtr As Ptr, outIndex As Integer)
		  dim targetSize as integer = outIndex + additionalBytes + 10
		  if targetSize >= outBuffer.Size then
		    targetSize = targetSize * 10
		    outBuffer.Size = targetSize
		    outPtr = outBuffer
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateJSON_MTC(json As Variant, prettyPrint As Boolean = False) As String
		  //
		  // Make sure we are starting with a Dictionary or array
		  //
		  
		  if json.IsNull then
		    return ""
		    
		  elseif json.Type = Variant.TypeObject and json isa Dictionary then
		    //
		    // Good
		    //
		    
		  elseif json.IsArray then
		    //
		    // Good
		    //
		    
		  else
		    raise new IllegalCastException
		    
		  end if
		  
		  if prettyPrint then
		    ExpandIndentArr( 256 )
		  end if
		  
		  dim level as integer = if( prettyPrint, 0, -2000000000 ) // Crazy low number to prevent pretty print
		  dim inBuffer as new MemoryBlock( 1024 )
		  dim outBuffer as new MemoryBlock( inBuffer.Size * 10 )
		  dim outPtr as ptr = outBuffer
		  dim outIndex as integer = 0
		  
		  EncodeValue( json, level, outBuffer, outPtr, outIndex, inBuffer )
		  
		  dim result as string = outBuffer.StringValue( 0, outIndex ).DefineEncoding( Encodings.UTF8 )
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HexValue(mb As MemoryBlock, p As Ptr, pos As Integer) As Integer
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kZero as integer = 48
		  const kNine as integer = 57
		  const kBigA as integer = 65
		  const kBigF as integer = 70
		  const kLittleA as integer = 97
		  const kLittleF as integer = 102
		  
		  if ( pos + 4 ) >= mb.Size then
		    raise new JSONException( "Illegal value", 10, pos - 1 )
		  end if
		  
		  dim value as integer
		  
		  dim lastPos as integer = pos + 3
		  for i as integer = pos to lastPos
		    value = value * 16
		    
		    dim thisByte as integer = p.Byte( i )
		    
		    select case thisByte
		    case kZero to kNine
		      value = value + ( thisByte - kZero )
		      
		    case kBigA to kBigF
		      value = value + ( thisByte - kBigA + 10 )
		      
		    case kLittleA to kLittleF
		      value = value + ( thisByte - kLittleA + 10 )
		      
		    case else
		      raise new JSONException( "Illegal value", 10, pos - 1 )
		      
		    end select
		  next
		  
		  return value
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseArray(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, isCaseSensitive As Boolean) As Variant()
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  dim result() as variant
		  
		  dim expectingComma as boolean
		  dim foundComma as boolean
		  
		  dim mbSize as integer = mb.Size
		  
		  while bytePos < mbSize
		    AdvancePastWhiteSpace mb, p, bytePos
		    
		    dim thisByte as integer = p.Byte( bytePos )
		    
		    if thisByte = kComma then
		      if not expectingComma then
		        raise new JSONException( "Illegal value", 10, bytePos + 1 )
		      end if
		      
		      expectingComma = false
		      foundComma = true
		      bytePos = bytePos + 1
		      continue while
		    end if
		    
		    if thisByte = kCloseSquareBracket then
		      if foundComma then 
		        raise new JSONException( "Illegal value", 10, bytePos + 1 )
		      end if
		      
		      bytePos = bytePos + 1
		      return result
		    end if
		    
		    if expectingComma and thisByte <> kComma then
		      raise new JSONException( "Illegal value", 10, bytePos + 1 )
		    end if
		    
		    foundComma = false
		    
		    dim value as variant = ParseValue( mb, p, bytePos, isCaseSensitive )
		    result.Append value
		    
		    expectingComma = true
		    
		  wend
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseJSON_MTC(json As String, isCaseSensitive As Boolean = True) As Variant
		  //
		  // Takes in JSON and returns either a Dictionary or Variant array
		  //
		  
		  if json = "" then
		    return nil
		  end if
		  
		  //
		  // First make sure we have a well encoded string.
		  // We'll try to be tolerant here.
		  //
		  if json.Encoding is nil then
		    dim threeNulls as string = ChrB( 0 ) + ChrB( 0 ) + ChrB( 0 )
		    dim oneNull as string = ChrB( 0 )
		    
		    dim firstFour as string = json.LeftB( 4 )
		    dim firstTwo as string = json.LeftB( 2 )
		    
		    if firstFour = ( "[" + threeNulls ) or firstFour = ( "{" + threeNulls ) then
		      json = json.DefineEncoding( Encodings.UTF32LE )
		    elseif firstFour = ( threeNulls + "[" ) or firstFour = ( threeNulls + "{" ) then
		      json = json.DefineEncoding( Encodings.UTF32BE )
		    elseif firstTwo = ( "[" + oneNull ) or firstTwo = ( "{" + oneNull ) then
		      json = json.DefineEncoding( Encodings.UTF16LE )
		    elseif firstTwo = ( oneNull + "[" ) or firstTwo = ( oneNull + "{" ) then
		      json = json.DefineEncoding( Encodings.UTF16BE )
		    elseif Encodings.UTF8.IsValidData( json ) then
		      json = json.DefineEncoding( Encodings.UTF8 )
		    else
		      //
		      // Best guess
		      //
		      json = json.DefineEncoding( Encodings.SystemDefault )
		    end if
		  end if
		  
		  json = json.ConvertEncoding( Encodings.UTF8 )
		  json = json.Trim
		  
		  if json = "" then
		    return nil
		  end if
		  
		  dim mbJSON as MemoryBlock = json
		  dim pJSON as Ptr = mbJSON
		  dim bytePos as integer = 0
		  
		  dim result as variant
		  dim thisByte as integer = pJSON.Byte( bytePos )
		  bytePos = bytePos + 1
		  
		  if thisByte = kSquareBracket then
		    result = ParseArray( mbJSON, pJSON, bytePos, isCaseSensitive )
		  elseif thisByte = kCurlyBrace then
		    result = ParseObject( mbJSON, pJSON, bytePos, isCaseSensitive )
		  else
		    raise new JSONException( "Illegal value", 10, 1 )
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseNumber(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As Variant
		  //
		  // Will either return a double or an integer
		  //
		  
		  //
		  // Will attempt to be very tolerant
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kZero as integer = 48
		  const kNine as integer = 57
		  const kPlus as integer = 43
		  const kMinus as integer = 45
		  const kBigE as integer = 69
		  const kLittleE as integer = 101
		  
		  const kDot as integer = 46
		  
		  dim result as variant
		  
		  dim isDouble as boolean
		  dim foundDot as boolean
		  dim foundValue as boolean
		  dim isScientificNotation as boolean
		  dim foundE as boolean
		  
		  dim startPos as integer = bytePos
		  dim mbSize as integer = mb.Size
		  
		  do
		    if bytePos >= mbSize then
		      raise new JSONException( "Illegal value", 10, startPos )
		    end if
		    
		    dim thisByte as integer = p.Byte( bytePos )
		    
		    select case thisByte
		    case kTab, kReturn, kLinefeed, kSpace, kComma, kCloseCurlyBrace, kCloseSquareBracket
		      exit
		    end select
		    
		    select case thisByte
		    case kPlus, kMinus
		      if bytePos <> startPos and not foundE then
		        //
		        // This is illegal here
		        //
		        exit
		      else
		        foundE = false
		      end if
		      
		    case kZero to kNine
		      //
		      // A number
		      //
		      foundE = false
		      foundValue = true
		      
		    case kDot
		      if foundDot or isScientificNotation then
		        //
		        // Bad dot
		        //
		        raise new JSONException( "Illegal value", 10, startPos )
		        
		      else
		        foundDot = true
		        isDouble = true
		      end if
		      
		    case kBigE, kLittleE
		      if not foundValue or bytePos = startPos or isScientificNotation then
		        //
		        // Can't have two "e"s
		        //
		        raise new JSONException( "Illegal value", 10, startPos )
		        
		      else
		        isDouble = true
		        isScientificNotation = true
		        foundE = true
		      end if
		      
		    case else
		      //
		      // It's something else
		      //
		      exit
		      
		    end select
		    
		    bytePos = bytePos + 1
		  loop
		  
		  if not foundValue then
		    raise new JSONException( "Illegal value", 10, startPos )
		  end if
		  
		  //
		  // Get the value
		  //
		  dim byteLen as integer = bytePos - startPos
		  dim s as string = mb.StringValue( startPos, byteLen )
		  if isDouble then
		    dim d as double = s.Val
		    result = d
		  else
		    dim i as integer = s.Val
		    result = i
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseObject(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, isCaseSensitive As Boolean) As Dictionary
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kColon as integer = 58
		  
		  dim result as Dictionary
		  if isCaseSensitive then
		    result = new M_JSON.JSONDictionary
		  else
		    result = new Dictionary
		  end if
		  
		  dim key as string
		  dim value as variant
		  
		  dim expectingComma as boolean
		  dim expectingColon as boolean
		  dim expectingValue as boolean
		  dim foundComma as boolean
		  
		  dim mbSize as integer = mb.Size
		  
		  while bytePos < mbSize
		    AdvancePastWhiteSpace mb, p, bytePos
		    
		    dim thisByte as integer = p.Byte( bytePos )
		    
		    if thisByte = kComma then
		      if expectingComma then
		        expectingComma = false
		        foundComma = true
		        key = ""
		        value = nil
		        bytePos = bytePos + 1
		        continue while
		      else
		        raise new JSONException( "Unexpected character", 10, bytePos + 1 )
		      end if
		    end if
		    
		    if thisByte = kColon then
		      if expectingColon then
		        expectingColon = false
		        expectingValue = true
		        bytePos = bytePos + 1
		        continue while
		      else
		        raise new JSONException( "Unexpected character", 10, bytePos + 1 )
		      end if
		    end if
		    
		    if thisByte = kCloseCurlyBrace then
		      if foundComma or expectingColon or expectingValue then
		        raise new JSONException( "Illegal value", 10, bytePos + 1 )
		      else
		        //
		        // We're done
		        //
		        bytePos = bytePos + 1
		        return result
		      end if
		    end if
		    
		    foundComma = false
		    
		    if expectingComma and thisByte <> kComma then
		      raise new JSONException( "Missing comma", 6, bytePos + 1 )
		    elseif expectingColon and thisByte <> kColon then
		      raise new JSONException( "Missing colon", 6, bytePos + 1 )
		    end if
		    
		    if expectingValue then
		      expectingValue = false
		      expectingComma = true
		      value = ParseValue( mb, p, bytePos, isCaseSensitive )
		      
		      result.Value( key ) = value
		      
		    elseif thisByte <> kQuote then
		      raise new JSONException( "Illegal value", 10, bytePos + 1 )
		      
		    else
		      
		      //
		      // It's a quote as expected for the key
		      //
		      expectingColon = true
		      bytePos = bytePos + 1
		      key = ParseString( mb, p, bytePos )
		      
		    end if
		  wend
		  
		  raise new JSONException( "Missing }", 6, bytePos + 1 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseString(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer) As String
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kSlash as integer = 47
		  const kB as integer = 98
		  const kF as integer = 102
		  const kN as integer = 110
		  const kR as integer = 114
		  const kT as integer = 116
		  const kU as integer = 117
		  
		  dim startPos as integer = bytePos
		  
		  dim builder() as string
		  dim inBackslash as boolean
		  dim expectingSurrogate as boolean
		  dim surrogateFirstHalf as integer
		  
		  dim mbSize as integer = mb.Size
		  while bytePos < mbSize
		    dim thisByte as integer = p.Byte( bytePos )
		    
		    if inBackslash then
		      inBackslash = false
		      
		      if expectingSurrogate and thisByte <> kU then
		        raise new JSONException( "Improperly formed JSON string", 0, bytePos + 1 )
		      end if
		      
		      select case thisByte
		      case kBackslash
		        builder.Append "\"
		        
		      case kSlash
		        builder.Append "/"
		        
		      case kQuote
		        builder.Append """"
		        
		      case kB
		        builder.Append &u08
		        
		      case kF
		        builder.Append &u0C
		        
		      case kN
		        builder.Append &u0A
		        
		      case kR
		        builder.Append &u0D
		        
		      case kT
		        builder.Append &u09
		        
		      case kU
		        dim codepoint as integer = HexValue( mb, p, bytePos + 1 )
		        bytePos = bytePos + 4
		        
		        if ( expectingSurrogate and ( codepoint < &hDC00 or codepoint > &hDFFF ) ) or _
		          ( not expectingSurrogate and codepoint >= &hDC00 and codepoint <= &hDFFF ) then
		          raise new JSONException( "Invalid codepoint", 10, bytePos - 1 )
		        end if
		        
		        if expectingSurrogate then
		          expectingSurrogate = false
		          
		          codepoint = Bitwise.ShiftLeft( surrogateFirstHalf - &hD800, 10, 20 ) + ( codepoint - &hDC00 ) + &h10000
		          builder.Append Chr( codepoint )
		          
		          
		        elseif codepoint < &hD800 or codepoint > &hDFFF then
		          builder.Append Chr( codepoint )
		          
		        else
		          surrogateFirstHalf = codepoint
		          expectingSurrogate = true
		          
		        end if
		        
		        
		      case else
		        //
		        // If we were strict, we would...
		        //   raise new JSONException( "Invalid character after \", 10, bytePos + 1 )
		        //
		        // But we're not, so...
		        //
		        builder.Append ChrB( thisByte )
		        
		      end select
		      
		      startPos = bytePos + 1
		      
		    elseif thisByte = kBackslash then
		      dim diff as integer = bytePos - startPos
		      if diff <> 0 then
		        builder.Append mb.StringValue( startPos, diff)
		      end if
		      
		      inBackslash = true
		      
		    elseif expectingSurrogate then
		      raise new JSONException( "Improperly formed JSON string", 0, bytePos + 1 )
		      
		    elseif thisByte = kQuote then
		      //
		      // We're done with this string
		      //
		      dim diff as integer = bytePos - startPos
		      dim s as string
		      if diff <> 0 then
		        s = mb.StringValue( startPos, diff )
		      end if
		      
		      bytePos = bytePos + 1
		      
		      if builder.Ubound <> -1 then
		        builder.Append s
		        s = join( builder, "" )
		      end if
		      
		      s = s.DefineEncoding( Encodings.UTF8 )
		      return s
		      
		    end if
		    
		    bytePos = bytePos + 1
		    
		  wend
		  
		  //
		  // If we get here...
		  //
		  raise new JSONException( "Invalid string", 10, startPos + 1 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseValue(mb As MemoryBlock, p As Ptr, ByRef bytePos As Integer, isCaseSensitive As Boolean) As Variant
		  #if not DebugBuild
		    #pragma BackgroundTasks kAllowBackgroudTasks
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kN as integer = 110
		  const kI as integer = 105
		  const kL as integer = 108
		  
		  const kF as integer = 102
		  const kA as integer = 97
		  const kS as integer = 115
		  const kE as integer = 101
		  
		  const kT as integer = 116
		  const kR as integer = 114
		  const kU as integer = 117
		  
		  AdvancePastWhiteSpace mb, p, bytePos
		  
		  dim thisByte as integer = p.Byte( bytePos )
		  
		  select case thisByte
		  case kSquareBracket
		    bytePos = bytePos + 1
		    return ParseArray( mb, p, bytePos, isCaseSensitive )
		    
		  case kCurlyBrace 
		    bytePos = bytePos + 1
		    return ParseObject( mb, p, bytePos, isCaseSensitive )
		    
		  case kN // Should be null
		    if ( bytePos + 4 ) < mb.Size and p.Byte( bytePos + 1 ) = kU and p.Byte( bytePos + 2 ) = kL and p.Byte( bytePos + 3 ) = kL then
		      bytePos = bytePos + 4
		      return nil
		    end if
		    
		  case kT // Should be true
		    if ( bytePos + 4 ) < mb.Size and p.Byte( bytePos + 1 ) = kR and p.Byte( bytePos + 2 ) = kU and p.Byte( bytePos + 3 ) = kE then
		      bytePos = bytePos + 4
		      return true
		    end if
		    
		  case kF // Should be false
		    if ( bytePos + 5 ) < mb.Size and p.Byte( bytePos + 1 ) = kA and p.Byte( bytePos + 2 ) = kL and p.Byte( bytePos + 3 ) = kS _
		      and p.Byte( bytePos + 4 ) = kE then
		      bytePos = bytePos + 5
		      return false
		    end if
		    
		  case kQuote 
		    bytePos = bytePos + 1
		    return ParseString( mb, p, bytePos )
		    
		  case else
		    //
		    // Should be a number since everything else failed
		    //
		    return ParseNumber( mb, p, bytePos )
		    
		  end select
		  
		  
		  //
		  // If we get here
		  //
		  raise new JSONException( "Illegal value", 10, bytePos + 1 )
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private IndentArr() As String
	#tag EndProperty


	#tag Constant, Name = kAllowBackgroudTasks, Type = Boolean, Dynamic = False, Default = \"False", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kBackslash, Type = Double, Dynamic = False, Default = \"92", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseCurlyBrace, Type = Double, Dynamic = False, Default = \"125", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCloseSquareBracket, Type = Double, Dynamic = False, Default = \"93", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kComma, Type = Double, Dynamic = False, Default = \"44", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCurlyBrace, Type = Double, Dynamic = False, Default = \"123", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDefaultIndent, Type = String, Dynamic = False, Default = \"  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLineFeed, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kQuote, Type = Double, Dynamic = False, Default = \"34", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kReturn, Type = Double, Dynamic = False, Default = \"13", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSpace, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSquareBracket, Type = Double, Dynamic = False, Default = \"91", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTab, Type = Double, Dynamic = False, Default = \"9", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"4.2", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
