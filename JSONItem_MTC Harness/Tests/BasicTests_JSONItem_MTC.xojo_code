#tag Class
Protected Class BasicTests_JSONItem_MTC
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ArrayMethodsTest()
		  dim items() as Variant = Array( "a", "A", true, 1.3, 2, nil )
		  
		  dim j as new JSONItem_MTC
		  for i as integer = 0 to items.Ubound
		    j.Append items( i )
		  next
		  
		  Assert.IsTrue( j.IsArray )
		  Assert.AreEqual( items.Ubound + 1, j.Count )
		  
		  for i as integer = 0 to items.Ubound
		    Assert.IsTrue( items( i ) = j.Value( i ) )
		  next
		  
		  j = new JSONItem_MTC
		  j.Value( 5 ) = "a"
		  Assert.AreSame( "a", j.Value( 0 ).StringValue )
		  
		  j = new JSONItem_MTC
		  j.Append true
		  j.Append false
		  j.Remove 0
		  
		  Assert.IsTrue( j.Value( 0 ) = false )
		  
		  j.Insert( 0, "a" )
		  
		  Assert.AreSame( "a", j( 0 ).StringValue )
		  Assert.IsTrue( j( 1 ) = false )
		  
		  #pragma BreakOnExceptions false
		  try
		    j.Insert( 5, "c" )
		    Assert.Fail( "Insert with an out of bounds index" )
		  catch err as OutOfBoundsException
		    // Worked
		  end
		  #pragma BreakOnExceptions true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssignArrayTest()
		  dim j as new JSONItem_MTC
		  dim key as string
		  
		  key = "StringArray"
		  try
		    dim arr() as string = array( "a", "b", "c" )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "TextArray"
		  try
		    dim arr() as text = array( "a", "b", "c" )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "IntegerArray"
		  try
		    dim arr() as integer = array( 1, 2, 3 )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "BooleanArray"
		  try
		    dim arr() as boolean = array( true, true, false )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "DoubleArray"
		  try
		    dim arr() as double = array( 1.1, 2.2, 3.3 )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "SingleArray"
		  try
		    dim arr() as single
		    arr.Append 1.1
		    arr.Append 2.2
		    arr.Append 3.3
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  key = "VariantArray"
		  try
		    dim d as new Dictionary
		    d.Value( 1 ) = 2
		    dim arr() as variant = array( true, nil, 3, d )
		    j.Value( key ) = arr
		    Assert.Pass key.ToText
		    Assert.IsTrue j.Value( key ) isa JSONItem_MTC
		    dim subj as JSONItem_MTC = j.Value( key )
		    Assert.IsTrue subj.Value( 3 ) isa JSONItem_MTC
		  catch err as RuntimeException
		    Assert.Fail key.ToText + ": " + err.Reason
		  end try
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BadlyFormedJSONLoadTest()
		  dim j as JSONItem_MTC
		  dim loads() as string = Array( """""", "12", "[1", "2]", "[bad]" )
		  
		  Assert.Pass "Running tests"
		  
		  for each load as string in loads
		    #pragma BreakOnExceptions false
		    try
		      j = new JSONItem_MTC( load )
		      Assert.Fail "Loading '" + load.ToText + " should have failed"
		      return
		    catch err as JSONException
		    end
		    #pragma BreakOnExceptions true
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CaseSensitiveKeyTest()
		  dim j as new JSONItem_MTC
		  
		  dim storedKeys() as string = array( _
		  "a", _
		  "A", _
		  "a" + &u200B + "A", _
		  "A" + &u200B + "A", _
		  "a" + &u200B + "a" _
		  )
		  
		  for i as integer = 0 to storedKeys.Ubound
		    dim key as string = storedKeys( i )
		    j.Value( key ) = i + 1
		  next
		  
		  Assert.AreEqual( CType( storedKeys.Ubound, integer ) + 1, j.Count, "Should be 5 objects" )
		  Assert.AreEqual( 1, j.Value( "a" ).IntegerValue )
		  
		  dim keys() as string = j.Names
		  
		  for each storedKey as string in storedKeys
		    dim startingUb as integer = keys.Ubound
		    for i as integer = keys.Ubound downto 0
		      if StrComp( keys( i ), storedKey, 0 ) = 0 then
		        keys.Remove i
		        exit for i
		      end if
		    next
		    dim endingUb as integer = keys.Ubound
		    Assert.AreEqual( startingUb - 1, endingUb, storedKey.ToText + " was not found" )
		  next
		  
		  Assert.AreEqual( -1, CType( keys.Ubound, integer ), "keys should be empty" )
		  
		  j.Value( "Man" ) = 6
		  Assert.IsFalse( j.HasName( "MaT" ), "Keys with same Base64 encoding return incorrect results" )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompareTest()
		  dim j1 as new JSONItem_MTC
		  dim j2 as JSONItem_MTC
		  Assert.IsFalse j1 = j2, "Right is nil"
		  
		  j2 = j1
		  j1 = nil
		  Assert.IsFalse j1 = j2, "Left is nil"
		  
		  j1 = new JSONItem_MTC
		  Assert.IsTrue j1 = j2, "Both empty"
		  
		  j1.Append( 1 )
		  Assert.IsFalse j1 = j2, "Left has 1 element"
		  
		  j2.Append( 1 )
		  Assert.IsTrue j1 = j2, "Both have 1 element"
		  
		  dim d1 as new Dictionary
		  dim d2 as new Dictionary
		  
		  j1.Append d1
		  Assert.IsFalse j1 = j2, "Left added empty dictionary"
		  
		  j2.Append d2
		  Assert.IsTrue j1 = j2, "Both added empty dictionary"
		  
		  d1.Value( "1" ) = true
		  d1.Value( "2" ) = nil
		  d2.Value( "2" ) = nil
		  j1.Append d1
		  j2.Append d2
		  Assert.IsFalse j1 = j2, "Left added dict with 2 values, right added dict with 1 value"
		  
		  d2.Value( "1" ) = true
		  j1 = d1
		  j2 = d2
		  Assert.IsTrue j1 = j2, "Both converted from dicts with same values"
		  
		  j1 = new JSONItem_MTC
		  j2 = new JSONItem_MTC
		  j1.Append 1
		  j2.Append "1"
		  Assert.IsFalse j1 = j2, "Same value but different types"
		  
		  j1 = new JSONItem_MTC
		  j2 = new JSONItem_MTC
		  j1.Append CType( 1, Int32 )
		  j2.Append CType( 1, Int64 )
		  Assert.IsTrue j1 = j2, "Same value with different Int types"
		  
		  j1 = new JSONItem_MTC
		  j2 = new JSONItem_MTC
		  dim s as string = "1"
		  j1.Append s
		  j2.Append s.ToText
		  Assert.IsTrue j1 = j2, "Same value with different Text types"
		  
		  j1 = new JSONItem_MTC
		  j2 = new JSONItem_MTC
		  j1.Append 1
		  j1.Append "2"
		  j2.Append "2"
		  j2.Append 1
		  Assert.IsFalse j1 = j2, "Same values but different order"
		  
		  j1 = new JSONItem_MTC
		  j2 = new JSONItem_MTC
		  d2.Value( "4" ) = nil
		  j1.Append "1"
		  j1.Append d1
		  j2.Append "1"
		  j2.Append d2
		  Assert.IsFalse j1 = j2, "Right Dictionary has more values"
		  
		  d1 = new Dictionary
		  d2 = new Dictionary
		  d1.Value( "1" ) = 1
		  d1.Value( "2" ) = 2
		  d2.Value( "2" ) = 2
		  d2.Value( "3" ) = 3
		  j1 = d1
		  j2 = d2
		  Assert.IsFalse j1 = j2, "Dictionaries with same count, different values"
		  
		  d1 = new Dictionary
		  d2 = new Dictionary
		  d1.Value( "a" ) = 1
		  d2.Value( "A" ) = 1
		  j1 = d1
		  j2 = d2
		  Assert.IsFalse j1 = j2, "Keys of different case"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertFromArrayTest()
		  dim arr() as variant
		  arr.Append 1
		  arr.Append nil
		  arr.Append new Dictionary
		  
		  dim j as JSONItem_MTC = arr
		  Assert.AreEqual 3, j.Count
		  Assert.IsTrue j( 2 ) isa JSONItem_MTC
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertFromDictionaryTest()
		  dim d as new Dictionary
		  d.Value( "1" ) = true
		  d.Value( "2" ) = new Dictionary
		  
		  dim arr() as string
		  d.Value( 3 )  = arr
		  
		  dim j as JSONItem_MTC = d
		  Assert.AreEqual 3, j.Count
		  
		  Assert.IsTrue j.Value( "2" ) isa JSONItem_MTC
		  
		  dim expected as new JSONItem_MTC( "{""1"":true,""2"":{},""3"":[]}" )
		  Assert.IsTrue j = expected
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertToArrayTest()
		  dim j as new JSONItem_MTC
		  j.Append 1
		  j.Append true
		  j.Append nil
		  
		  dim arr() as variant = j
		  Assert.AreEqual 2, CType( arr.Ubound, Integer )
		  
		  j = new JSONItem_MTC
		  arr = j
		  Assert.IsTrue arr <> nil, "Should have been an empty array"
		  Assert.AreEqual -1, CType( arr.Ubound, Integer )
		  
		  j = new JSONItem_MTC
		  j.Value( "a" ) = 1
		  
		  #pragma BreakOnExceptions false
		  try
		    arr = j
		    Assert.Fail "Should have raised an exception"
		  catch err as TypeMismatchException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConvertToDictionaryTest()
		  dim j as new JSONItem_MTC
		  
		  j.Value( "a" ) = 1
		  j.Value( "b" ) = 2
		  
		  j.Value( "c" ) = array( 1, 2, 3 )
		  
		  dim d as Dictionary = j
		  Assert.AreEqual 1, d.Value( "a" ).IntegerValue
		  Assert.AreEqual 2, d.Value( "b" ).IntegerValue
		  
		  dim arr() as variant = d.Value( "c" )
		  Assert.AreEqual 2, CType( arr.Ubound, Integer )
		  
		  j = new JSONItem_MTC
		  d = j
		  Assert.IsNotNil d
		  Assert.AreEqual 0, d.Count
		  
		  j = new JSONItem_MTC
		  j.Append 1
		  
		  #pragma BreakOnExceptions false
		  try
		    d = j
		    Assert.Fail "Should have raised an exception"
		  catch err as TypeMismatchException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DictionaryMethodsTest()
		  dim j as new JSONItem_MTC
		  
		  j.Value( "a" ) = "a"
		  j.Value( "A" ) = "A"
		  
		  Assert.IsFalse( j.IsArray )
		  Assert.AreEqual( 2, j.Count )
		  
		  Assert.IsTrue( j.HasName( "a" ), "HasName 'a'" )
		  Assert.IsTrue( j.HasName( "A" ), "HasName 'A'" )
		  
		  Assert.AreSame( "a", j.Value( "a" ).StringValue )
		  Assert.AreSame( "A", j.Value( "A" ).StringValue )
		  
		  dim names() as string = j.Names
		  Assert.AreEqual( CType( 1, Int32 ), CType( names.Ubound, Int32 ) )
		  Assert.AreSame( "a", names( 0 ), "First name is 'a'" )
		  Assert.AreSame( "A", names( 1 ), "Second name is 'A'" )
		  
		  Assert.AreSame( "A", j.Lookup( "A", "" ).StringValue, "Lookup 'A'" )
		  Assert.AreSame( "", j.Lookup( "b", "" ).StringValue, "Lookup 'b'" )
		  
		  Assert.AreSame( "a", j.Name( 0 ) )
		  Assert.AreSame( "A", j.Name( 1 ) )
		  
		  dim child as new JSONItem_MTC( "[1]" )
		  j.Child( "c" ) = child
		  Assert.AreEqual( 1, j.Child( "c" ).Value( 0 ).IntegerValue )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedBackslashTest()
		  dim jI as new JSONItem_MTC
		  jI.Value( "name" ) = "John \Doey\ Doe"
		  
		  dim raw as String = jI.ToString
		  
		  dim jO as new JSONItem_MTC( raw )
		  
		  for each k as String in jI.Names
		    Assert.IsTrue( jI.Value( k ) = jO.Value( k ), k.ToText )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedQuoteTest()
		  dim jI as new JSONItem_MTC
		  jI.Value( "name" ) = "John ""Doey"" Doe"
		  
		  dim raw as String = jI.ToString
		  
		  dim jO as new JSONItem_MTC( raw )
		  
		  for each k as String in jI.Names
		    Assert.IsTrue( jI.Value( k ) = jO.Value( k ), k.ToText )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmptyStringTest()
		  Dim jI As New JSONItem_MTC
		  jI.Value("name") = ""
		  
		  Dim raw As String = jI.ToString
		  Dim jO As New JSONItem_MTC(raw)
		  
		  Assert.AreEqual("", jO.Value("name").StringValue )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EscapedCharactersTest()
		  dim j as JSONItem_MTC
		  dim jsonString() as string = Array( "\r", "\n", "\\", "\t", "\f", "\b", "\""", "\/", "\u0020", "\G" )
		  dim expectedString() as string = Array( EndOfLine.Macintosh,  EndOfLine.UNIX, "\", chr( 9 ), chr( 12 ), chr( 8 ), """", "/", " ", "G" )
		  
		  for i as integer = 0 to jsonString.Ubound
		    j = new JSONItem_MTC( "[""" + jsonString( i ) + """]" )
		    Assert.AreEqual( expectedString( i ), j( 0 ).StringValue )
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IllegalStringTest()
		  Assert.Pass( "Running tests" )
		  
		  dim j as JSONItem_MTC
		  
		  dim badStrings() as string = Array( Chr( 13 ), Chr( 9 ), Chr( 8 ), Chr( 5 ), Chr( 29 ) )
		  
		  for each s as string in badStrings
		    dim load as string = "[""this" + s + "that""]"
		    
		    #pragma BreakOnExceptions false
		    
		    try
		      j = new JSONItem_MTC( load )
		    catch err as JSONException
		      Assert.Fail( EncodeHex( s ).ToText + " should not have failed" )
		      return
		    end try
		    
		    try
		      j = new JSONItem_MTC( load, true )
		      Assert.Fail( EncodeHex( s ).ToText + " should have failed with Strict" )
		      return
		    catch err as JSONException
		    end try
		    
		    load = "[""this\" + s + "that""]"
		    
		    try
		      j = new JSONItem_MTC( load, true )
		      Assert.Fail( "\" + EncodeHex( s ).ToText + " should have failed with Strict" )
		      return
		    catch err as JSONException
		    end try
		    
		    #pragma BreakOnExceptions true
		    
		  next
		  
		  dim load as string = "[""\w""]"
		  j = new JSONItem_MTC( load )
		  Assert.AreEqual( "w", j( 0 ).StringValue )
		  
		  #pragma BreakOnExceptions false
		  try
		    j = new JSONItem_MTC( load, true )
		    Assert.Fail( load.ToText + " should have failed with strict" )
		  catch err as JSONException
		  end try
		  #pragma BreakOnExceptions true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadAdditionalTest()
		  dim j as new JSONItem_MTC
		  j.Value( "one" ) = 1.0
		  
		  j.Load( "{""one"" : ""that"", ""two"": ""this""}" )
		  Assert.AreEqual( "that", j.Value( "one" ).StringValue )
		  Assert.AreEqual( "this", j.Value( "two" ).StringValue )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadEncodingTest()
		  const kOriginal = "[""abc""]"
		  
		  dim testString as string
		  dim j as JSONItem_MTC
		  
		  Assert.Message "Testing UTF8"
		  testString = kOriginal
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing nil encoding"
		  testString = kOriginal.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF16BE"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF16LE"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF32BE"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF32LE"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF16BE (nil encoding)"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16BE )
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF16LE (nil encoding)"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF32BE (nil encoding)"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message "Testing UTF32LE (nil encoding)"
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32LE )
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  //
		  // With BOM
		  //
		  Assert.Message( "Testing BOM with UTF16LE" )
		  testString = kOriginal.ConvertEncoding( Encodings.UTF16LE )
		  testString = ChrB( &hFF ) + ChrB( &hFE ) + testString
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  Assert.Message( "Testing BOM with UTF32BE" )
		  testString = kOriginal.ConvertEncoding( Encodings.UTF32BE )
		  testString = ChrB( 0 ) + ChrB( 0 ) + ChrB( &hFE ) + ChrB( &hFF ) + testString
		  testString = testString.DefineEncoding( nil )
		  try
		    j = new JSONItem_MTC( testString )
		    Assert.AreSame( "abc", j( 0 ).StringValue )
		  catch err as JSONException
		    Assert.Fail err.Reason
		  end try
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadInterruptionTest()
		  dim j as JSONItem_MTC
		  dim load as string = "{""first"" : 1.0, ""second"" : interrupt}"
		  
		  #pragma BreakOnExceptions false
		  
		  try
		    j = new JSONItem_MTC( load )
		    Assert.Fail( "Loading through Constructor should have failed" )
		    return
		  catch err as JSONException
		  end
		  
		  Assert.IsTrue( j is nil, "An interrupted load in the Constructor should lead to a nil object" )
		  
		  j = new JSONItem_MTC
		  try
		    j.Load load
		    Assert.Fail( "The Load method should have failed" )
		    return
		  catch err as JSONException
		  end
		  
		  Assert.IsTrue( j.Count = 0, "Interrupted load should not have a value" )
		  
		  j = new JSONItem_MTC
		  j.Value( "zero" ) = true
		  
		  try
		    j.Load load
		    Assert.Fail( "Loading into an existing Object should have failed" )
		    return
		  catch err as JSONException
		  end
		  
		  Assert.IsTrue( j.Count = 1 and j.Value( "zero" ) = true, "Interrupted load should not have replaced value" )
		  
		  j = new JSONItem_MTC
		  j.Append "zero"
		  load = "[""one"", interrupt]"
		  
		  try
		    j.Load load
		    Assert.Fail( "Loading into an existing Array should have failed" )
		    return
		  catch err as JSONException
		  end
		  
		  Assert.IsTrue( j.Count = 1 and j( 0 ) = "zero", "Interrupted load should not have replaced value" )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectsTest()
		  #pragma BreakOnExceptions false
		  
		  dim j as new JSONItem_MTC
		  
		  try
		    j.Append new date
		    Assert.Fail( "Shouldn't be able to add a date" )
		  catch err as JSONException
		    Assert.Pass()
		  end try
		  
		  dim f as FolderItem = SpecialFolder.Desktop
		  try
		    j.Append f
		    Assert.Fail( "Shouldn't be able to add a FolderItem" )
		  catch err as JSONException
		    Assert.Pass()
		  end try
		  
		  dim child as new JSONItem_MTC( "[]" ) // Empty array
		  try
		    j.Append child
		    Assert.Pass
		  catch err as JSONException
		    Assert.Pass( "Should be allowed to append JSONItem_MTC" )
		  end try
		  
		  dim d as new Dictionary
		  try
		    j.Append d
		    Assert.Pass
		  catch err as JSONException
		    Assert.Pass( "Should be allowed to append Dictionary" )
		  end try
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimpleToFromTest()
		  Dim jI As New JSONItem_MTC
		  jI.Value("name") = "John Doe"
		  jI.Value("age") = 32
		  jI.Value("wage") = 14.56
		  
		  Dim jO As New JSONItem_MTC(jI.ToString)
		  
		  For Each k As String In jI.Names
		    Assert.IsTrue(jI.Value(k) = jO.Value(k), k.ToText + " matches")
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StrictTest()
		  #pragma BreakOnExceptions false
		  
		  dim j as new JSONItem_MTC
		  
		  dim d as double = val( "inf" )
		  j.Append d
		  
		  Assert.AreSame( "[inf]", j.ToString, "INF test" )
		  
		  j.Strict = true
		  try
		    dim s as string = j.ToString
		    #pragma unused s
		    Assert.Fail( "ToString should have failed with ""inf""" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC( "[nan]" )
		  dim nanVal as double = val( "nan" )
		  Assert.IsTrue( j( 0 ).DoubleValue.Equals( nanVal, 1 ), "NAN parsing" )
		  
		  try
		    j = new JSONItem_MTC( "[TRUE]", true )
		    Assert.Fail( "Load should have failed with [TRUE]" )
		  catch err as JSONException
		  end
		  
		  try
		    j = new JSONItem_MTC( "[+1]", true )
		    Assert.Fail( "Load should have failed with [+1]" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC( "[+1]" )
		  Assert.AreEqual( 1, j( 0 ).IntegerValue, """+1"" parsing" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TextTest()
		  dim j as new JSONItem_MTC
		  
		  dim t1 as text = "hi"
		  dim k1 as text = "1"
		  
		  dim t2 as text = "there"
		  dim k2 as text = "2"
		  
		  j.Append t1
		  j.Append t2
		  
		  Assert.AreEqual( "[""hi"",""there""]", j.ToString )
		  
		  j = new JSONItem_MTC
		  j.Value( k1 ) = t1
		  j.Value( k2 ) = t2
		  
		  dim asJSONString as string = j.ToString
		  Assert.IsTrue( asJSONString = "{""1"":""hi"",""2"":""there""}" or asJSONString = "{""2"":""there"",""1"":""hi""}")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnicodeTest()
		  dim j as new JSONItem_MTC
		  
		  j.Value( "a" + chr( 1 ) ) = "something" + chr( 2 )
		  Assert.AreSame( "{""a\u0001"":""something\u0002""}", j.ToString )
		  
		  j = new JSONItem_MTC
		  j.Append( "a" + chr( 1 ) )
		  Assert.AreSame( "[""a\u0001""]", j.ToString )
		  
		  j = new JSONItem_MTC
		  j.Append "©"
		  
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.None
		  Assert.AreEqual( "[""©""]", j.ToString )
		  
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreEqual( "[""\u00A9""]", j.ToString )
		  
		  j = new JSONItem_MTC( "[""Norm’s dog""]" )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreSame( "[""Norm\u2019s dog""]", j.ToString )
		  
		  j = new JSONItem_MTC( "[""this char \u00AD""]" )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.None
		  Assert.AreSame( "[""this char " + Chr( &hAD ) + """]", j.ToString )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.JavaScriptCompatible
		  Assert.AreSame( "[""this char \u00AD""]", j.ToString )
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreSame( "[""this char \u00AD""]", j.ToString )
		  
		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as string = "[""\uD800\uDD49""]"
		  
		  j = new JSONItem_MTC
		  j.Append highChar
		  Assert.AreEqual( "[""" + highChar + """]", j.ToString )
		  
		  j.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  Assert.AreEqual( asEncoded, j.ToString )
		  
		  j = new JSONItem_MTC( asEncoded )
		  Assert.AreEqual( EncodeHex( highChar, true ), EncodeHex( j( 0 ).StringValue, true ) )
		  
		  #pragma BreakOnExceptions false
		  
		  j = new JSONItem_MTC
		  try
		    j.Load( "[""\ujohn""]" )
		    Assert.Fail( "Loading '\ujohn' should have failed" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC
		  try
		    j.Load( "[""\uDC01\uDC02""]" )
		    Assert.Fail( "Loading '\uDC01\uDC02' should have failed" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC
		  try
		    j.Load( "[""\uD801\uD802""]" )
		    Assert.Fail( "Loading '\uD801\uD802' should have failed" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC
		  try
		    j.Load( "[""\uD801\u0020""]" )
		    Assert.Fail( "Loading '\uD801\u0020' should have failed" )
		  catch err as JSONException
		  end
		  
		  j = new JSONItem_MTC
		  try
		    j.Load( "[""\uD801A""]" )
		    Assert.Fail( "Loading '\uD801A' should have failed" )
		  catch err as JSONException
		  end
		  
		  #pragma BreakOnExceptions true
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
End Class
#tag EndClass
