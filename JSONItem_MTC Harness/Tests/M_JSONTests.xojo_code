#tag Class
Protected Class M_JSONTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BadJSONTest()
		  #pragma BreakOnExceptions false
		  
		  dim v as variant
		  
		  try
		    v = ParseJSON_MTC( "[1" )
		    Assert.Fail "Missing ]"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":null" )
		    Assert.Fail "Missing }"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "true]" )
		    Assert.Fail "Missing ["
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( """a"":true}" )
		    Assert.Fail "Missing {"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[1}" )
		    Assert.Fail "[ with }"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":null]" )
		    Assert.Fail "{ with ]"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[,]" )
		    Assert.Fail "Array with a single comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[1,]" )
		    Assert.Fail "Array with a trailing comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[,1]" )
		    Assert.Fail "Array with a leading comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[2,,1]" )
		    Assert.Fail "Array with an extra comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{,}" )
		    Assert.Fail "Object with a single comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":null,}" )
		    Assert.Fail "Object with a trailing comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{,""a"":null" )
		    Assert.Fail "Object with a leading comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":null,,""b"":true}" )
		    Assert.Fail "Object with an extra comma"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":null : ,""b"":true}" )
		    Assert.Fail "Object with stray"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"":,""b"":true}" )
		    Assert.Fail "Object with missing value"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "{""a"": null, :true}" )
		    Assert.Fail "Object with missing key"
		  catch err as JSONException
		    Assert.Pass
		  end try
		  
		  try
		    v = ParseJSON_MTC( "[""\ujohn""]" )
		    Assert.Fail "\ujohn"
		  catch err as JSONException
		    Assert.Pass 
		  end try
		  
		  #pragma BreakOnExceptions true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CaseSensitiveNamesTest()
		  dim s as string = "{""Abc"":1, ""ABC"":2, ""abc"":3}"
		  
		  dim d as Dictionary = ParseJSON_MTC( s )
		  Assert.IsTrue( Introspection.GetType( d ) = GetTypeInfo( M_JSON.JSONDictionary ), "Is not JSONDictionary" )
		  
		  Assert.AreEqual( 3, d.Count, "Dictionary.Count does not match" )
		  Assert.AreEqual( 1, d.Value( "Abc" ).IntegerValue, "Abc" )
		  Assert.AreEqual( 2, d.Value( "ABC" ).IntegerValue, "ABC" )
		  Assert.AreEqual( 3, d.Value( "abc" ).IntegerValue, "abc" )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DifferentEncodingsTest()
		  dim json as string = "[1,2,""©""]"
		  
		  dim tryEncodings() as TextEncoding = array( _
		  Encodings.UTF32BE, _
		  Encodings.UTF32LE, _
		  Encodings.UTF16BE, _
		  Encodings.UTF16LE, _
		  Encodings.SystemDefault _
		  )
		  
		  for each enc as TextEncoding in tryEncodings
		    dim diff as string = json.ConvertEncoding( enc )
		    dim arr() as variant = ParseJSON_MTC( diff )
		    Assert.AreEqual 2, Ctype( arr.Ubound, integer )
		    Assert.AreEqual "©", arr( 2 ).StringValue
		    
		    diff = diff.DefineEncoding( nil )
		    arr = ParseJSON_MTC( diff )
		    Assert.AreEqual 2, Ctype( arr.Ubound, integer )
		    Assert.AreEqual "©", arr( 2 ).StringValue
		    
		    diff = GenerateJSON_MTC( arr )
		    Assert.AreSame json, diff
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedBackslashTest()
		  dim jI as new Dictionary
		  jI.Value( "name" ) = "John \Doey\ Doe"
		  
		  dim raw as String = M_JSON.GenerateJSON_MTC( jI )
		  
		  dim jO as Dictionary = M_JSON.ParseJSON_MTC( raw )
		  
		  for each k as variant in jI.Keys
		    dim vI as string = jI.Value( k ).StringValue
		    dim vO as string = jO.Value( k ).StringValue
		    Assert.AreSame( vI, vO, k.StringValue.ToText )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmbeddedQuoteTest()
		  dim jI as new Dictionary
		  jI.Value( "name" ) = "John ""Doey"" Doe"
		  
		  dim raw as String = M_JSON.GenerateJSON_MTC( jI )
		  
		  dim jO as Dictionary = M_JSON.ParseJSON_MTC( raw )
		  
		  for each k as variant in jI.Keys
		    dim vI as string = jI.Value( k ).StringValue
		    dim vO as string = jO.Value( k ).StringValue
		    Assert.AreSame( vI, vO, k.StringValue.ToText )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmptyArrayTest()
		  dim arr() as variant = ParseJSON_MTC( "[  ]" )
		  Assert.AreEqual -1, Ctype( arr.Ubound, integer ), "With spaces"
		  
		  arr = ParseJSON_MTC( "[]" )
		  Assert.AreEqual -1, Ctype( arr.Ubound, integer ), "Without spaces"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EmptyObjectTest()
		  dim d as Dictionary = ParseJSON_MTC( "{ }" )
		  Assert.IsNotNil d
		  Assert.AreEqual 0, d.Count
		  
		  d = ParseJSON_MTC( "{}" )
		  Assert.IsNotNil d
		  Assert.AreEqual 0, d.Count
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EscapedCharactersTest()
		  dim jsonString() as string = Array( "\r", "\n", "\\", "\t", "\f", "\b", "\""", "\/", "\u0020", "\G" )
		  dim expectedString() as string = Array( EndOfLine.Macintosh,  EndOfLine.UNIX, "\", chr( 9 ), chr( 12 ), chr( 8 ), """", "/", " ", "G" )
		  
		  for i as integer = 0 to jsonString.Ubound
		    dim arr() as variant = ParseJSON_MTC( "[""" + jsonString( i ) + """]" )
		    Assert.AreEqual( expectedString( i ), arr( 0 ).StringValue )
		  next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GenerateBigJSONTest()
		  dim json as string = json_sample
		  dim out as string
		  
		  if true then
		    dim dict as Dictionary = ParseJSON_MTC( json )
		    
		    StartTestTimer "GenerateJSON_MTC"
		    #if XojoVersion >= 2018.02
		      App.StartProfiling
		    #endif
		    out = GenerateJSON_MTC( dict )
		    #if XojoVersion >= 2018.02
		      App.StopProfiling
		    #endif
		    LogTestTimer "GenerateJSON_MTC"
		    
		  end if
		  
		  if true then
		    dim jsonText as text = json.ToText
		    dim dict as Xojo.Core.Dictionary = Xojo.Data.ParseJSON( jsonText )
		    
		    StartTestTimer "Xojo.Data.GenerateJSON"
		    jsonText = Xojo.Data.GenerateJSON( dict )
		    LogTestTimer "Xojo.Data.GenerateJSON"
		  end if
		  
		  if true then
		    dim j as new JSONItem( json )
		    
		    StartTestTimer "JSONItem.ToString"
		    out = j.ToString
		    LogTestTimer "JSONItem.ToString"
		  end if
		  
		  if true then
		    dim j as new JSONItem_MTC( json )
		    
		    StartTestTimer "JSONItem_MTC.ToString"
		    out = j.ToString
		    LogTestTimer "JSONItem_MTC.ToString"
		  end if
		  
		  Assert.Pass
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GenerateTest()
		  dim d as new Date( 2001, 2, 25, 1, 2, 3 )
		  dim json as string
		  
		  dim arr() as variant
		  dim emptyDict as new Dictionary
		  arr.Append emptyDict
		  arr.Append nil
		  arr.Append 1
		  arr.Append 2.5
		  arr.Append false
		  arr.Append d
		  dim emptyArr() as boolean
		  arr.Append emptyArr
		  arr.Append "©" + ChrB( 0 ) + "123" + ChrB( 10 ) + ChrB( 13 ) + ChrB( 2 ) + ChrB( 31 )
		  
		  json = GenerateJSON_MTC( arr )
		  Assert.AreSame "[{},null,1,2.5,false,""2001-02-25 01:02:03"",[],""©\u0000123\n\r\u0002\u001F""]", json
		  
		  dim dict as new Dictionary
		  dict.Value( "nil" ) = nil
		  dict.Value( "1" ) = 1
		  dict.Value( "2.5" ) = 2.5
		  dict.Value( "false" ) = false
		  dict.Value( "arr" ) = arr
		  
		  json = GenerateJSON_MTC( dict, true )
		  Assert.Message json.ToText
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub JSONDictionaryTextKeyTest()
		  dim t as text = "someTextKey"
		  dim s as string = t
		  
		  dim d as new M_JSON.JSONDictionary
		  
		  d.Value( t ) = 1
		  Assert.AreEqual( 1, d.Value( s ).IntegerValue, "Text key does not match" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub JSONDIctionaryToDictionaryTest()
		  dim jd as M_JSON.JSONDictionary = ParseJSON_MTC( "{""aa"" : 1, ""AA"" : 2, ""Aa"" : 3}" )
		  Assert.AreEqual 3, jd.Count
		  
		  dim d as Dictionary = jd.ToDictionary
		  Assert.AreEqual "Dictionary", Introspection.GetType( d ).Name
		  Assert.AreEqual 1, d.Count
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NullTest()
		  dim json as Dictionary = M_JSON.ParseJSON_MTC( "{""nullvalue"":null, ""notnull"":1}" )
		  dim v as variant = json.Value( "nullvalue" )
		  Assert.IsNil v, "Should be nil"
		  Assert.AreEqual 1, json.Value( "notnull" ).IntegerValue, "notnull"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseArrayJSONTest()
		  const kUbound as integer = 5
		  dim v as variant = ParseJSON_MTC( "[1, 2.5, false, ""a string"", ""a string with \""quote\"""", null]" )
		  
		  Assert.IsTrue v.IsArray
		  
		  dim arr() as variant = v
		  Assert.AreEqual kUbound, Ctype( arr.Ubound, integer )
		  Assert.IsTrue arr( arr.Ubound ).IsNull
		  Assert.AreEqual Variant.TypeBoolean, arr( 2 ).Type
		  Assert.IsFalse arr( 2 ).BooleanValue
		  Assert.AreEqual 1, arr( 0 ).IntegerValue
		  Assert.AreEqual 2.5, arr( 1 ).DoubleValue
		  Assert.AreEqual "a string", arr( 3 ).StringValue
		  Assert.AreEqual "a string with ""quote""", arr( 4 ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseBigJSONTest()
		  dim json as string = json_sample
		  Assert.Message "JSON.Len = " + json.Len.ToText
		  
		  StartTestTimer "ParseJSON_MTC"
		  #if XojoVersion >= 2018.02
		    App.StartProfiling
		  #endif
		  dim dict as Dictionary = ParseJSON_MTC( json )
		  #if XojoVersion >= 2018.02
		    App.StopProfiling
		  #endif
		  LogTestTimer "ParseJSON_MTC"
		  
		  Assert.AreNotEqual 0, dict.Count
		  Assert.Message "Dictionary.Count = " + dict.Count.ToText
		  
		  dim jsonText as text = json.ToText
		  
		  StartTestTimer "Xojo.Data.ParseJSON"
		  dim autoDict as Xojo.Core.Dictionary = Xojo.Data.ParseJSON( jsonText )
		  LogTestTimer "Xojo.Data.ParseJSON"
		  
		  Assert.AreEqual dict.Count, autoDict.Count
		  
		  if true then
		    StartTestTimer "JSONItem"
		    dim j as new JSONItem( json )
		    LogTestTimer "JSONItem"
		    
		    Assert.AreEqual Ctype( dict.Count, integer ), Ctype( j.Count, integer)
		  end if
		  
		  if true then
		    StartTestTimer "JSONItem_MTC"
		    dim j as new JSONItem_MTC( json )
		    LogTestTimer "JSONItem_MTC"
		    
		    Assert.AreEqual Ctype( dict.Count, integer ), Ctype( j.Count, integer)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseHugeStringTest()
		  dim s as string = "A"
		  while s.LenB < 1024
		    s = s + s
		  wend
		  s = "\""" + s.Left( 1024 )
		  while s.LenB < 20000000
		    s = s + s
		  wend
		  s = s.Left( 20000000 )
		  
		  dim json as string = "{""key"":""" + s + """}"
		  
		  self.StartTestTimer "Parse string"
		  dim d as Dictionary = ParseJSON_MTC( json )
		  self.LogTestTimer "Parse string"
		  
		  Assert.AreEqual s.ReplaceAll( "\""", """" ), d.Value( "key" ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseObjectTest()
		  self.StopTestOnFail = true
		  
		  dim d as Dictionary = ParseJSON_MTC( "{""a"" : 1, ""b"" : true, ""c"":null}" )
		  
		  Assert.AreEqual d.Count, 3
		  Assert.IsTrue d.HasKey( "a" ), "Has a"
		  Assert.IsTrue d.HasKey( "b" ), "Has b"
		  Assert.IsTrue d.HasKey( "c" ), "Has c"
		  
		  Assert.AreEqual 1, d.Value( "a" ).IntegerValue
		  Assert.IsTrue d.Value( "b" ).BooleanValue, "b"
		  Assert.IsNil d.Value( "c" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseWebAppTest()
		  StopTestOnFail = true
		  
		  dim json as string = kExampleWebApp
		  
		  self.StartTestTimer
		  dim d as Dictionary = ParseJSON_MTC( json )
		  self.LogTestTimer
		  
		  Assert.AreNotEqual 0, d.Count
		  
		  Assert.IsTrue d.HasKey( "web-app" )
		  dim webAppDict as Dictionary = d.Value( "web-app" )
		  Assert.IsNotNil webAppDict
		  
		  Assert.IsTrue webAppDict.HasKey( "servlet" )
		  dim arr() as variant = webAppDict.Value( "servlet" )
		  Assert.AreNotEqual 0, Ctype( arr.Ubound, integer )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SurrogatePairTest()
		  dim arr() as variant = ParseJSON_MTC( "[""ab\u0000\u0020""]" )
		  
		  Assert.AreEqual 0, Ctype( arr.Ubound, integer )
		  Assert.AreEqual "ab" + &u00 + " ", arr( 0 ).StringValue
		  
		  dim highChar as string = Chr( &h10149 )
		  dim asEncoded as string = "[""\uD800\uDD49""]"
		  
		  arr = ParseJSON_MTC( asEncoded )
		  Assert.AreEqual highChar, arr( 0 ).StringValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VariousArraysTest()
		  dim d as new Dictionary
		  
		  if true then
		    dim s1() as string
		    d.Value( "string empty" ) = s1
		    dim s2() as string = array( "hey", "ho", "howdy" )
		    d.Value( "string" ) = s2
		  end if
		  
		  if true then
		    dim t1() as text
		    d.Value( "text empty" ) = t1
		    dim t2() as text = array( "hey", "ho", "howdy" )
		    d.Value( "text" ) = t2
		  end if
		  
		  dim b1() as boolean
		  d.Value( "boolean empty" ) = b1
		  dim b2() as boolean = array( true, true, false )
		  d.Value( "boolean" ) = b2
		  
		  dim d1() as double
		  d.Value( "double empty" ) = d1
		  dim d2() as double = array( 1.3, 4.5, 5.0 )
		  d.Value( "double" ) = d2
		  
		  if true then
		    dim s1() as single
		    d.Value( "single empty" ) = s1
		    dim s2() as single
		    s2.Append 1.3
		    s2.Append 4.5
		    s2.Append 5.0
		    d.Value( "single" ) = s2
		  end if
		  
		  dim i321() as int32
		  d.Value( "int32 empty" ) = i321
		  dim i322() as int32
		  i322.Append 1
		  i322.Append 2
		  i322.Append 3
		  d.Value( "int32" ) = i322
		  
		  dim i641() as int64
		  d.Value( "int64 empty" ) = i641
		  dim i642() as int64
		  i642.Append 1
		  i642.Append 2
		  i642.Append 3
		  d.Value( "int64" ) = i642
		  
		  dim i1() as integer
		  d.Value( "integer empty" ) = i1
		  dim i2() as integer
		  i2.Append 1
		  i2.Append 2
		  i2.Append 3
		  d.Value( "integer" ) = i2
		  
		  dim v1() as variant
		  d.Value( "variant empty" ) = v1
		  dim v2() as variant
		  v2.Append nil
		  v2.Append Ctype( "hi", string )
		  v2.Append 1.3
		  v2.Append 5
		  v2.Append true
		  v2.Append Ctype( "ho", text )
		  v2.Append new Date
		  d.Value( "variant" ) = v2
		  
		  dim a1() as auto
		  d.Value( "auto empty" ) = a1
		  dim a2() as auto
		  a2.Append nil
		  a2.Append Ctype( "hi", string )
		  a2.Append 1.3
		  a2.Append 5
		  a2.Append true
		  a2.Append Ctype( "ho", text )
		  a2.Append new Date
		  d.Value( "auto" ) = a2
		  
		  dim dt1() as Date
		  d.Value( "date empty" ) = dt1
		  dim dt2() as Date = array( new Date )
		  d.Value( "date" ) = dt2
		  
		  dim json as string = GenerateJSON_MTC( d, true )
		  Assert.AreNotEqual "", json // Important part here is, no RuntimeException
		  
		  Assert.Message json.ToText
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kExampleWebApp, Type = String, Dynamic = False, Default = \"{\"web-app\": {\n  \"servlet\": [   \n    {\n      \"servlet-name\": \"cofaxCDS\"\x2C\n      \"servlet-class\": \"org.cofax.cds.CDSServlet\"\x2C\n      \"init-param\": {\n        \"configGlossary:installationAt\": \"Philadelphia\x2C PA\"\x2C\n        \"configGlossary:adminEmail\": \"ksm@pobox.com\"\x2C\n        \"configGlossary:poweredBy\": \"Cofax\"\x2C\n        \"configGlossary:poweredByIcon\": \"/images/cofax.gif\"\x2C\n        \"configGlossary:staticPath\": \"/content/static\"\x2C\n        \"templateProcessorClass\": \"org.cofax.WysiwygTemplate\"\x2C\n        \"templateLoaderClass\": \"org.cofax.FilesTemplateLoader\"\x2C\n        \"templatePath\": \"templates\"\x2C\n        \"templateOverridePath\": \"\"\x2C\n        \"defaultListTemplate\": \"listTemplate.htm\"\x2C\n        \"defaultFileTemplate\": \"articleTemplate.htm\"\x2C\n        \"useJSP\": false\x2C\n        \"jspListTemplate\": \"listTemplate.jsp\"\x2C\n        \"jspFileTemplate\": \"articleTemplate.jsp\"\x2C\n        \"cachePackageTagsTrack\": 200\x2C\n        \"cachePackageTagsStore\": 200\x2C\n        \"cachePackageTagsRefresh\": 60\x2C\n        \"cacheTemplatesTrack\": 100\x2C\n        \"cacheTemplatesStore\": 50\x2C\n        \"cacheTemplatesRefresh\": 15\x2C\n        \"cachePagesTrack\": 200\x2C\n        \"cachePagesStore\": 100\x2C\n        \"cachePagesRefresh\": 10\x2C\n        \"cachePagesDirtyRead\": 10\x2C\n        \"searchEngineListTemplate\": \"forSearchEnginesList.htm\"\x2C\n        \"searchEngineFileTemplate\": \"forSearchEngines.htm\"\x2C\n        \"searchEngineRobotsDb\": \"WEB-INF/robots.db\"\x2C\n        \"useDataStore\": true\x2C\n        \"dataStoreClass\": \"org.cofax.SqlDataStore\"\x2C\n        \"redirectionClass\": \"org.cofax.SqlRedirection\"\x2C\n        \"dataStoreName\": \"cofax\"\x2C\n        \"dataStoreDriver\": \"com.microsoft.jdbc.sqlserver.SQLServerDriver\"\x2C\n        \"dataStoreUrl\": \"jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName\x3Dgoon\"\x2C\n        \"dataStoreUser\": \"sa\"\x2C\n        \"dataStorePassword\": \"dataStoreTestQuery\"\x2C\n        \"dataStoreTestQuery\": \"SET NOCOUNT ON;select test\x3D\'test\';\"\x2C\n        \"dataStoreLogFile\": \"/usr/local/tomcat/logs/datastore.log\"\x2C\n        \"dataStoreInitConns\": 10\x2C\n        \"dataStoreMaxConns\": 100\x2C\n        \"dataStoreConnUsageLimit\": 100\x2C\n        \"dataStoreLogLevel\": \"debug\"\x2C\n        \"maxUrlLength\": 500}}\x2C\n    {\n      \"servlet-name\": \"cofaxEmail\"\x2C\n      \"servlet-class\": \"org.cofax.cds.EmailServlet\"\x2C\n      \"init-param\": {\n      \"mailHost\": \"mail1\"\x2C\n      \"mailHostOverride\": \"mail2\"}}\x2C\n    {\n      \"servlet-name\": \"cofaxAdmin\"\x2C\n      \"servlet-class\": \"org.cofax.cds.AdminServlet\"}\x2C\n \n    {\n      \"servlet-name\": \"fileServlet\"\x2C\n      \"servlet-class\": \"org.cofax.cds.FileServlet\"}\x2C\n    {\n      \"servlet-name\": \"cofaxTools\"\x2C\n      \"servlet-class\": \"org.cofax.cms.CofaxToolsServlet\"\x2C\n      \"init-param\": {\n        \"templatePath\": \"toolstemplates/\"\x2C\n        \"log\": 1\x2C\n        \"logLocation\": \"/usr/local/tomcat/logs/CofaxTools.log\"\x2C\n        \"logMaxSize\": \"\"\x2C\n        \"dataLog\": 1\x2C\n        \"dataLogLocation\": \"/usr/local/tomcat/logs/dataLog.log\"\x2C\n        \"dataLogMaxSize\": \"\"\x2C\n        \"removePageCache\": \"/content/admin/remove\?cache\x3Dpages&id\x3D\"\x2C\n        \"removeTemplateCache\": \"/content/admin/remove\?cache\x3Dtemplates&id\x3D\"\x2C\n        \"fileTransferFolder\": \"/usr/local/tomcat/webapps/content/fileTransferFolder\"\x2C\n        \"lookInContext\": 1\x2C\n        \"adminGroupID\": 4\x2C\n        \"betaServer\": true}}]\x2C\n  \"servlet-mapping\": {\n    \"cofaxCDS\": \"/\"\x2C\n    \"cofaxEmail\": \"/cofaxutil/aemail/*\"\x2C\n    \"cofaxAdmin\": \"/admin/*\"\x2C\n    \"fileServlet\": \"/static/*\"\x2C\n    \"cofaxTools\": \"/tools/*\"}\x2C\n \n  \"taglib\": {\n    \"taglib-uri\": \"cofax.tld\"\x2C\n    \"taglib-location\": \"/WEB-INF/tlds/cofax.tld\"}}}", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
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
