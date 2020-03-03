#tag Window
Begin Window WndPlayground
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   618
   ImplicitInstance=   True
   LiveResize      =   "True"
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   410277764
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Playground"
   Visible         =   True
   Width           =   928
   Begin TextArea fldResult
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   189
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   46
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   888
   End
   Begin PushButton btnTests
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Tests"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   27
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   108
   End
   Begin PushButton btnLoad
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Load && Compare"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   776
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   279
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   132
   End
   Begin TextArea fldJSON
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   40
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "{""name"":""something"",""properties"":{""prop1"":""value1"",""prop2"":true,""prop3"":[""item1"", ""item2"", null]}}"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   278
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   744
   End
   Begin TextArea fldJSONOut
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   247
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   349
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   421
   End
   Begin TextArea fldJSONMTCOut
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   247
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   487
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   349
      Transparent     =   False
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   421
   End
   Begin CheckBox cbCompact
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Compact"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   808
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   247
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   100
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   0
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "JSONItem"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   317
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   1
      InitialParent   =   ""
      Italic          =   False
      Left            =   495
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "JSONItem_MTC"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   317
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin PopupMenu mnuEncodeType
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "None\nJavaScript Compatible\nAll"
      Italic          =   False
      Left            =   149
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   247
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   133
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   2
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Encode Unicode:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   247
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   117
   End
   Begin PushButton btnSpeedTests
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   0
      Cancel          =   False
      Caption         =   "Speed Tests"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   793
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   108
   End
   Begin CheckBox cbStrict
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "Strict"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   708
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      State           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   247
      Transparent     =   False
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   73
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub AddToResult(msg As String)
		  fldResult.AppendText msg
		  fldResult.AppendText EndOfLine
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events btnTests
	#tag Event
		Sub Action()
		  dim j1 as new JSONItem
		  dim j2 as new JSONItem_MTC
		  dim j3 as new Xojo.Core.Dictionary
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  
		  for i as integer = 1 to 1000
		    dim j1Child as new JSONItem
		    for inner as integer = 1 to 10
		      j1Child.Append inner
		    next
		    j1.Value( str( i ) ) = j1Child
		  next i
		  
		  sw.Stop
		  AddToResult "JSONItem Create: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  for i as integer = 1 to 1000
		    dim j2Child as new JSONItem_MTC
		    for inner as integer = 1 to 10
		      j2Child.Append inner
		    next
		    j2.Value( str( i ) ) = j2Child
		  next i
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC Create: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  for i as integer = 1 to 1000
		    dim j3Child() as Auto
		    for inner as integer = 1 to 10
		      j3Child.Append inner
		    next
		    j3.Value( str( i ) ) = j3Child
		  next i
		  
		  sw.Stop
		  AddToResult "Xojo.Core.Dictionary Create: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  dim s1 as string = j1.ToString
		  
		  sw.Stop
		  AddToResult "JSONItem.ToString: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  dim s2 as string = j2.ToString
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC.ToString: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  if StrComp( s1, s2, 0 ) <> 0 then
		    AddToResult "... but they don't match"
		  end if
		  
		  sw.Reset
		  sw.Start
		  
		  dim s3 as string = Xojo.Data.GenerateJSON( j3 )
		  
		  sw.Stop
		  AddToResult "Xojo.Data.GenerateJSON: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  if StrComp( s1, s3, 0 ) <> 0 then
		    AddToResult "... but they don't match"
		  end if
		  
		  j1.Load s2
		  if StrComp( j1.ToString, s1, 0 ) <> 0 then
		    AddToResult "JSONItem didn't load the output correctly"
		  end if
		  
		  j2.Load s1
		  if StrComp( j2.ToString, s2, 0 ) <> 0 then
		    AddToResult "JSONItem_MTC didn't load the output correctly"
		  end if
		  
		  j1.Load s3
		  if StrComp( j1.ToString, s3, 0 ) <> 0 then
		    AddToResult "JSONItem didn't load the output correctly"
		  end if
		  
		  sw.Reset
		  sw.Start
		  
		  j1 = new JSONItem()
		  j1.Load s1
		  
		  sw.Stop
		  AddToResult "JSONItem.Load: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  j2 = new JSONItem_MTC()
		  j2.Load s2
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC.Load: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  j3 = Xojo.Data.ParseJSON( s3.ToText )
		  
		  sw.Stop
		  AddToResult "Xojo.Data.ParseJSON: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  //
		  // Stress test
		  //
		  
		  j1 = new JSONItem
		  j2 = new JSONItem_MTC
		  j3 = new Xojo.Core.Dictionary
		  
		  sw.Reset
		  sw.Start
		  
		  for i as integer = 1 to 10000
		    dim jChild as new JSONItem
		    jChild.Append i
		    jChild.Append chr( 127 + i )
		    jChild.Append true
		    jChild.Append CType( i, double )
		    j1.Value( str( i ) ) = jChild
		  next i
		  
		  sw.Stop
		  AddToResult "JSONItem.Create (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  for i as integer = 1 to 10000
		    dim jChild as new JSONItem_MTC
		    jChild.Append i
		    jChild.Append chr( 127 + i )
		    jChild.Append true
		    jChild.Append CType( i, double )
		    j2.Value( str( i ) ) = jChild
		  next i
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC.Create (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  for i as integer = 1 to 10000
		    dim jChild() as Auto
		    jChild.Append i
		    jChild.Append chr( 127 + i )
		    jChild.Append true
		    jChild.Append CType( i, double )
		    j3.Value( str( i ) ) = jChild
		  next i
		  
		  sw.Stop
		  AddToResult "Xojo.Core.Dictionay (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  s1 = j1.ToString
		  
		  sw.Stop
		  AddToResult "JSONItem.ToString (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  s2 = j2.ToString
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC.ToString (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  s3 = Xojo.Data.GenerateJSON( j3 )
		  
		  sw.Stop
		  AddToResult "Xojo.Data.GenerateJSON (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  j1 = new JSONItem( s1 )
		  
		  sw.Stop
		  AddToResult "JSONItem.Load (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  j2 = new JSONItem_MTC( s2 )
		  
		  sw.Stop
		  AddToResult "JSONItem_MTC.Load (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  sw.Reset
		  sw.Start
		  
		  j3 = Xojo.Data.ParseJSON( s3.ToText )
		  
		  sw.Stop
		  AddToResult "Xojo.Data.ParseJSON (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  return
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnLoad
	#tag Event
		Sub Action()
		  fldJSONOut.Text = ""
		  fldJSONMTCOut.Text = ""
		  
		  try
		    
		    dim j1 as new JSONItem( fldJSON.Text )
		    j1.Compact = cbCompact.Value
		    fldJSONOut.Text = j1.ToString
		    
		  catch err as RuntimeException
		    
		    fldJSONOut.Text = "Error: " + EndOfLine
		    fldJSONOut.AppendText err.Message
		    fldJSONOut.AppendText EndOfLine
		    fldJSONOut.AppendText str( err.ErrorNumber )
		    
		  end try
		  
		  try
		    
		    dim j2 as new JSONItem_MTC( fldJSON.Text, cbStrict.Value )
		    j2.Compact = cbCompact.Value
		    j2.EncodeUnicode = JSONItem_MTC.EncodeType( mnuEncodeType.ListIndex )
		    fldJSONMTCOut.Text = j2.ToString
		    
		  catch err as RuntimeException
		    
		    fldJSONMTCOut.Text = "Error: " + EndOfLine
		    fldJSONMTCOut.AppendText err.Message
		    fldJSONMTCOut.AppendText EndOfLine
		    fldJSONMTCOut.AppendText str( err.ErrorNumber )
		    
		  end try
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnSpeedTests
	#tag Event
		Sub Action()
		  dim s as string = json_sample
		  s = s.DefineEncoding( Encodings.UTF8 )
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  
		  dim j as new JSONItem_MTC( s )
		  
		  sw.Stop
		  
		  AddToResult( "Load: " + format( sw.ElapsedMicroseconds, "#," ) )
		  
		  j.Compact = false
		  dim s1 as string = j.ToString
		  
		  if StrComp( s, s1, 0 ) <> 0 then
		    AddToResult "... but they don't match"
		  end if
		  
		  'sw.Reset
		  'sw.Start
		  'dim j1 as new JSONMBS( s )
		  'sw.Stop
		  '
		  'AddToResult( "Load MBS: " + format( sw.ElapsedMicroseconds, "#," ) )
		  
		  sw.Reset
		  sw.Start
		  dim j2 as new JSONItem( s )
		  #pragma unused j2
		  sw.Stop
		  
		  AddToResult( "Load Native: " + format( sw.ElapsedMicroseconds, "#," ) )
		  
		  sw.Reset
		  sw.Start
		  dim d as Xojo.Core.Dictionary = Xojo.Data.ParseJSON( s.ToText )
		  #pragma unused d
		  sw.Stop
		  
		  AddToResult( "Load New: " + format( sw.ElapsedMicroseconds, "#," ) )
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="0"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
		EditorType="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="MenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
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
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
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
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
