#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  App.StopProfiling
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub StartProfiling()
		  #if XojoVersion >= 2018.02 then
		    global.StartProfiling
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopProfiling()
		  #if XojoVersion >= 2018.02 then
		    global.StopProfiling
		  #endif
		End Sub
	#tag EndMethod


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
