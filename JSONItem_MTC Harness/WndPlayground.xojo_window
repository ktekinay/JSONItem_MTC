#tag Window
Begin Window WndPlayground
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   618
   ImplicitInstance=   True
   LiveResize      =   True
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
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   888
   End
   Begin PushButton btnTests
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
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
      Underline       =   False
      Visible         =   True
      Width           =   108
   End
   Begin PushButton btnLoad
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
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
      Underline       =   False
      Visible         =   True
      Width           =   132
   End
   Begin TextField fldJSON
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "{""name"":""something"",""properties"":{""prop1"":""value1"",""prop2"":true,""prop3"":[""item1"", ""item2"", null]}}"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   278
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
      ButtonStyle     =   "0"
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
		  dim j3 as JSONMBS = JSONMBS.NewObjectNode
		  
		  j2.EncodeUnicode = JSONItem_MTC.EncodeType( mnuEncodeType.ListIndex )
		  
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
		    dim j3Child as JSONMBS = JSONMBS.NewArrayNode
		    for inner as integer = 1 to 10
		      j3Child.AddItemToArray JSONMBS.NewNumberNode( inner )
		    next
		    j3.AddItemToObject( str( i ), j3Child )
		  next i
		  
		  sw.Stop
		  AddToResult "JSONMBS Create: " + format( sw.ElapsedMicroseconds, "#," )
		  
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
		  
		  dim s3 as string = j3.ToString( false )
		  
		  sw.Stop
		  AddToResult "JSONMBS.ToString: " + format( sw.ElapsedMicroseconds, "#," )
		  
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
		  
		  j3 = new JSONMBS( s3 )
		  
		  sw.Stop
		  AddToResult "JSONMBS.Load: " + format( sw.ElapsedMicroseconds, "#," )
		  
		  //
		  // Stress test
		  //
		  
		  j1 = new JSONItem
		  j2 = new JSONItem_MTC
		  j3 = JSONMBS.NewObjectNode
		  
		  j2.EncodeUnicode = JSONItem_MTC.EncodeType( mnuEncodeType.ListIndex )
		  
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
		    j3.AddItemToObject( str( i ), JSONMBS.NewStringNode( str( i ) + chr( 127 + i ) ) )
		  next i
		  
		  sw.Stop
		  AddToResult "JSONMBS.Create (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
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
		  
		  if StrComp( s1, s2, 0 ) <> 0 then
		    AddToResult "... but they don't match"
		    dim c as new Clipboard
		    c.Text = "JSONItem:" + EndOfLine + s1 + EndOfLine + EndOfLine + "JSONItem_MTC:" + EndOfLine + s2
		    c.Close
		  end if
		  
		  sw.Reset
		  sw.Start
		  
		  s3 = j3.ToString( false )
		  
		  sw.Stop
		  AddToResult "JSONMBS.ToString (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
		  if StrComp( s1, s3, 0 ) <> 0 then
		    AddToResult "... but it doesn't match JSONItem"
		  end if
		  
		  if StrComp( s2, s3, 0 ) <> 0 then
		    AddToResult "... but it doesn't match JSONItem_MTC"
		  end if
		  
		  
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
		  
		  j3 = new JSONMBS( s3 )
		  
		  sw.Stop
		  AddToResult "JSONMBS.Load (big): " + format( sw.ElapsedMicroseconds, "#," )
		  
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
		  sw.Stop
		  
		  AddToResult( "Load Native: " + format( sw.ElapsedMicroseconds, "#," ) )
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
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
			"10 - Drawer Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
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
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
