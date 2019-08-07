#tag Class
Protected Class JsonOrgExampleTests
Inherits TestGroup
	#tag Method, Flags = &h21
		Sub BackAndForthTest()
		  dim j1 as new JSONItem_MTC( kExampleWebApp )
		  dim j2 as new JSONItem_MTC( j1.ToString )

		  j2.Compact = false
		  j1 = new JSONItem_MTC( j2.ToString )

		  j1.EncodeUnicode = JSONItem_MTC.EncodeType.All
		  j2 = new JSONItem_MTC( j1.ToString )

		  RecurseJSONItems( j1, j2 )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Sub GlossaryTest()
		  Dim j1 As New JSONItem_MTC(kExampleGlossary)
		  Dim jG1 As JSONItem_MTC = j1.Value("glossary")

		  Assert.AreEqual("example glossary", jG1.Value("title").StringValue)

		  Dim j2 As New JSONItem(kExampleGlossary)
		  Dim jG2 As JSONItem = j2.Value("glossary")

		  Assert.AreEqual("example glossary", jG2.Value("title").StringValue)

		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RecurseJSONItems(item1 As JSONItem_MTC, item2 As JSONItem_MTC)
		  Assert.IsTrue( item1.IsArray = item2.IsArray )
		  if item1.IsArray <> item2.IsArray then
		    return
		  end if

		  Assert.AreEqual( item1.Count, item2.Count )
		  if item1.Count <> item2.Count then
		    return
		  end if

		  if item1.IsArray then

		    dim lastIndex as integer = item1.Count - 1
		    for i as integer = 0 to lastIndex
		      dim value1 as variant = item1.Value( i )
		      dim value2 as variant = item2.Value( i )
		      Assert.AreEqual( value1.Type, value2.Type )
		      if value1.Type <> value2.Type then
		        return
		      end if

		      if value1 IsA JSONItem_MTC then
		        Assert.IsTrue( value2 IsA JSONItem_MTC )
		        if value2 IsA JSONItem_MTC then
		          RecurseJSONItems( value1, value2 )
		        else
		          return
		        end if
		      else
		        Assert.IsTrue( value1 =value2 )
		      end if
		    next i

		  else // Object

		    dim names1() as string = item1.Names
		    dim names2() as string = item2.Names
		    Assert.AreEqual( names1.Ubound, names2.Ubound )
		    if names1.Ubound <> names2.Ubound then
		      return
		    end if

		    for i as integer = 0 to names1.Ubound
		      Assert.AreSame( names1( i ), names2( i ) )
		      if StrComp( names1( i ), names2( i ), 0 ) <> 0 then
		        return
		      end if

		      dim value1 as variant = item1.Value( names1( i ) )
		      dim value2 as variant = item2.Value( names2( i ) )
		      Assert.AreEqual( value1.Type, value2.Type )
		      if value1.Type <> value2.Type then
		        return
		      end if

		      if value1 IsA JSONItem_MTC then
		        Assert.IsTrue( value2 IsA JSONItem_MTC )
		        if value2 IsA JSONItem_MTC then
		          RecurseJSONItems( value1, value2 )
		        else
		          return
		        end if
		      else
		        Assert.IsTrue( value1 =value2 )
		      end if
		    next
		  end if

		End Sub
	#tag EndMethod


	#tag Constant, Name = kExampleGlossary, Type = String, Dynamic = False, Default = \"{\n    \"glossary\": {\n        \"title\": \"example glossary\"\x2C\n\t\t\"GlossDiv\": {\n            \"title\": \"S\"\x2C\n\t\t\t\"GlossList\": {\n                \"GlossEntry\": {\n                    \"ID\": \"SGML\"\x2C\n\t\t\t\t\t\"SortAs\": \"SGML\"\x2C\n\t\t\t\t\t\"GlossTerm\": \"Standard Generalized Markup Language\"\x2C\n\t\t\t\t\t\"Acronym\": \"SGML\"\x2C\n\t\t\t\t\t\"Abbrev\": \"ISO 8879:1986\"\x2C\n\t\t\t\t\t\"GlossDef\": {\n                        \"para\": \"A meta-markup language\x2C used to create markup languages such as DocBook.\"\x2C\n\t\t\t\t\t\t\"GlossSeeAlso\": [\"GML\"\x2C \"XML\"]\n                    }\x2C\n\t\t\t\t\t\"GlossSee\": \"markup\"\n                }\n            }\n        }\n    }\n}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleMenu, Type = String, Dynamic = False, Default = \"{\"menu\": {\n  \"id\": \"file\"\x2C\n  \"value\": \"File\"\x2C\n  \"popup\": {\n    \"menuitem\": [\n      {\"value\": \"New\"\x2C \"onclick\": \"CreateNewDoc()\"}\x2C\n      {\"value\": \"Open\"\x2C \"onclick\": \"OpenDoc()\"}\x2C\n      {\"value\": \"Close\"\x2C \"onclick\": \"CloseDoc()\"}\n    ]\n  }\n}}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleMenu2, Type = String, Dynamic = False, Default = \"{\"menu\": {\n    \"header\": \"SVG Viewer\"\x2C\n    \"items\": [\n        {\"id\": \"Open\"}\x2C\n        {\"id\": \"OpenNew\"\x2C \"label\": \"Open New\"}\x2C\n        null\x2C\n        {\"id\": \"ZoomIn\"\x2C \"label\": \"Zoom In\"}\x2C\n        {\"id\": \"ZoomOut\"\x2C \"label\": \"Zoom Out\"}\x2C\n        {\"id\": \"OriginalView\"\x2C \"label\": \"Original View\"}\x2C\n        null\x2C\n        {\"id\": \"Quality\"}\x2C\n        {\"id\": \"Pause\"}\x2C\n        {\"id\": \"Mute\"}\x2C\n        null\x2C\n        {\"id\": \"Find\"\x2C \"label\": \"Find...\"}\x2C\n        {\"id\": \"FindAgain\"\x2C \"label\": \"Find Again\"}\x2C\n        {\"id\": \"Copy\"}\x2C\n        {\"id\": \"CopyAgain\"\x2C \"label\": \"Copy Again\"}\x2C\n        {\"id\": \"CopySVG\"\x2C \"label\": \"Copy SVG\"}\x2C\n        {\"id\": \"ViewSVG\"\x2C \"label\": \"View SVG\"}\x2C\n        {\"id\": \"ViewSource\"\x2C \"label\": \"View Source\"}\x2C\n        {\"id\": \"SaveAs\"\x2C \"label\": \"Save As\"}\x2C\n        null\x2C\n        {\"id\": \"Help\"}\x2C\n        {\"id\": \"About\"\x2C \"label\": \"About Adobe CVG Viewer...\"}\n    ]\n}}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleWebApp, Type = String, Dynamic = False, Default = \"{\n\"web-app\": {\n  \"servlet\": [   \n    {\n      \"servlet-name\": \"cofaxCDS\"\x2C\n      \"servlet-class\": \"org.cofax.cds.CDSServlet\"\x2C\n      \"init-param\": {\n        \"configGlossary:installationAt\": \"Philadelphia\x2C PA\"\x2C\n        \"configGlossary:adminEmail\": \"ksm@pobox.com\"\x2C\n        \"configGlossary:poweredBy\": \"Cofax\"\x2C\n        \"configGlossary:poweredByIcon\": \"/images/cofax.gif\"\x2C\n        \"configGlossary:staticPath\": \"/content/static\"\x2C\n        \"templateProcessorClass\": \"org.cofax.WysiwygTemplate\"\x2C\n        \"templateLoaderClass\": \"org.cofax.FilesTemplateLoader\"\x2C\n        \"templatePath\": \"templates\"\x2C\n        \"templateOverridePath\": \"\"\x2C\n        \"defaultListTemplate\": \"listTemplate.htm\"\x2C\n        \"defaultFileTemplate\": \"articleTemplate.htm\"\x2C\n        \"useJSP\": false\x2C\n        \"jspListTemplate\": \"listTemplate.jsp\"\x2C\n        \"jspFileTemplate\": \"articleTemplate.jsp\"\x2C\n        \"cachePackageTagsTrack\": 200\x2C\n        \"cachePackageTagsStore\": 200\x2C\n        \"cachePackageTagsRefresh\": 60\x2C\n        \"cacheTemplatesTrack\": 100\x2C\n        \"cacheTemplatesStore\": 50\x2C\n        \"cacheTemplatesRefresh\": 15\x2C\n        \"cachePagesTrack\": 200\x2C\n        \"cachePagesStore\": 100\x2C\n        \"cachePagesRefresh\": 10\x2C\n        \"cachePagesDirtyRead\": 10\x2C\n        \"searchEngineListTemplate\": \"forSearchEnginesList.htm\"\x2C\n        \"searchEngineFileTemplate\": \"forSearchEngines.htm\"\x2C\n        \"searchEngineRobotsDb\": \"WEB-INF/robots.db\"\x2C\n        \"useDataStore\": true\x2C\n        \"dataStoreClass\": \"org.cofax.SqlDataStore\"\x2C\n        \"redirectionClass\": \"org.cofax.SqlRedirection\"\x2C\n        \"dataStoreName\": \"cofax\"\x2C\n        \"dataStoreDriver\": \"com.microsoft.jdbc.sqlserver.SQLServerDriver\"\x2C\n        \"dataStoreUrl\": \"jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName\x3Dgoon\"\x2C\n        \"dataStoreUser\": \"sa\"\x2C\n        \"dataStorePassword\": \"dataStoreTestQuery\"\x2C\n        \"dataStoreTestQuery\": \"SET NOCOUNT ON;select test\x3D\'test\';\"\x2C\n        \"dataStoreLogFile\": \"/usr/local/tomcat/logs/datastore.log\"\x2C\n        \"dataStoreInitConns\": 10\x2C\n        \"dataStoreMaxConns\": 100\x2C\n        \"dataStoreConnUsageLimit\": 100\x2C\n        \"dataStoreLogLevel\": \"debug\"\x2C\n        \"maxUrlLength\": 500}}\x2C\n    {\n      \"servlet-name\": \"cofaxEmail\"\x2C\n      \"servlet-class\": \"org.cofax.cds.EmailServlet\"\x2C\n      \"init-param\": {\n      \"mailHost\": \"mail1\"\x2C\n      \"mailHostOverride\": \"mail2\"}}\x2C\n    {\n      \"servlet-name\": \"cofaxAdmin\"\x2C\n      \"servlet-class\": \"org.cofax.cds.AdminServlet\"}\x2C\n \n    {\n      \"servlet-name\": \"fileServlet\"\x2C\n      \"servlet-class\": \"org.cofax.cds.FileServlet\"}\x2C\n    {\n      \"servlet-name\": \"cofaxTools\"\x2C\n      \"servlet-class\": \"org.cofax.cms.CofaxToolsServlet\"\x2C\n      \"init-param\": {\n        \"templatePath\": \"toolstemplates/\"\x2C\n        \"log\": 1\x2C\n        \"logLocation\": \"/usr/local/tomcat/logs/CofaxTools.log\"\x2C\n        \"logMaxSize\": \"\"\x2C\n        \"dataLog\": 1\x2C\n        \"dataLogLocation\": \"/usr/local/tomcat/logs/dataLog.log\"\x2C\n        \"dataLogMaxSize\": \"\"\x2C\n        \"removePageCache\": \"/content/admin/remove\?cache\x3Dpages&id\x3D\"\x2C\n        \"removeTemplateCache\": \"/content/admin/remove\?cache\x3Dtemplates&id\x3D\"\x2C\n        \"fileTransferFolder\": \"/usr/local/tomcat/webapps/content/fileTransferFolder\"\x2C\n        \"lookInContext\": 1\x2C\n        \"adminGroupID\": 4\x2C\n        \"betaServer\": true}}]\x2C\n  \"servlet-mapping\": {\n    \"cofaxCDS\": \"/\"\x2C\n    \"cofaxEmail\": \"/cofaxutil/aemail/*\"\x2C\n    \"cofaxAdmin\": \"/admin/*\"\x2C\n    \"fileServlet\": \"/static/*\"\x2C\n    \"cofaxTools\": \"/tools/*\"}\x2C\n \n  \"taglib\": {\n    \"taglib-uri\": \"cofax.tld\"\x2C\n    \"taglib-location\": \"/WEB-INF/tlds/cofax.tld\"}}\n}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kExampleWidget, Type = String, Dynamic = False, Default = \"{\"widget\": {\n    \"debug\": \"on\"\x2C\n    \"window\": {\n        \"title\": \"Sample Konfabulator Widget\"\x2C\n        \"name\": \"main_window\"\x2C\n        \"width\": 500\x2C\n        \"height\": 500\n    }\x2C\n    \"image\": { \n        \"src\": \"Images/Sun.png\"\x2C\n        \"name\": \"sun1\"\x2C\n        \"hOffset\": 250\x2C\n        \"vOffset\": 250\x2C\n        \"alignment\": \"center\"\n    }\x2C\n    \"text\": {\n        \"data\": \"Click Here\"\x2C\n        \"size\": 36\x2C\n        \"style\": \"bold\"\x2C\n        \"name\": \"text1\"\x2C\n        \"hOffset\": 250\x2C\n        \"vOffset\": 100\x2C\n        \"alignment\": \"center\"\x2C\n        \"onMouseUp\": \"sun1.opacity \x3D (sun1.opacity / 100) * 90;\"\n    }\n}}", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
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
