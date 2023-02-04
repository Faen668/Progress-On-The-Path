//--------------------------------------------------------
//-------------------- Installation ----------------------
//--------------------------------------------------------

Completely remove any old version.

Skip this step if you have installed the mod with the install script.

Copy the 'mods', 'dlc' and 'bin' folder into your witcher 3 directory.

If you get a prompt to overwrite files go ahead and do so.

//--------------------------------------------------------
//---------------- Adding User Settings ------------------
//--------------------------------------------------------

- Copy and paste the following:

[ProgressOnThePath_PreviewSettings]
ProgressOnThePath_Preview=0
ProgressOnThePath_Preview_Hide=false
ProgressOnThePath_Preview_Comp=true
ProgressOnThePath_Preview_Igno=false
ProgressOnThePath_Preview_Iden=false
ProgressOnThePath_Preview_QArea=0
ProgressOnThePath_Preview_QType=0
ProgressOnThePath_Preview_IType=0
ProgressOnThePath_Preview_GArea=0
ProgressOnThePath_Preview_GType=0
ProgressOnThePath_Preview_WArea=0
ProgressOnThePath_Preview_WType=0

[ProgressOnThePath_GeneralSettings]
ProgressOnThePath_MeditationUpdate=true
ProgressOnThePath_EnableHotKey=true
ProgressOnThePath_EventMapPins_ShowMapPins=true
ProgressOnThePath_EventMapPins_MapPinDescription=true
ProgressOnThePath_EventMapPins_MapPinRadius=30
ProgressOnThePath_EventMapPins_MapPinType=1
ProgressOnThePath_EventMapPins_ShowMiniMap=false
ProgressOnThePath_EventMapPins_ArrowPointers=false
ProgressOnThePath_EventMapPins_HighlightedPointers=false

[ProgressOnThePath_NotificationSettings]
ProgressOnThePath_GlobalNotification_Time=7
ProgressOnThePath_GlobalNotification_Size=18
ProgressOnThePath_GlobalNotification_Font=1
ProgressOnThePath_FullNotification_Quest=true
ProgressOnThePath_FullNotification_World=true
ProgressOnThePath_FullNotification_Items=true
ProgressOnThePath_FullNotification_Gwent=true
ProgressOnThePath_FullNotification_Event=true
ProgressOnThePath_FullNotification_Nulls=true
ProgressOnThePath_BackNotification_Quest=true
ProgressOnThePath_BackNotification_World=true
ProgressOnThePath_BackNotification_Items=true
ProgressOnThePath_BackNotification_Gwent=true
ProgressOnThePath_BackNotification_Event=true
ProgressOnThePath_MiscNotification_Event=true
ProgressOnThePath_MiscNotification_Enter=true

- Into These 2 Files:

*\Documents\The Witcher 3\user.settings
*\Documents\The Witcher 3\dx12user.settings (NG Only)

//--------------------------------------------------------
//-------- Adding Hotkey Support (Optional) --------------
//--------------------------------------------------------

- Copy and paste the following:

[Exploration]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[Horse]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[Swimming]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[Boat]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[BoatPassenger]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[Combat]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)
[Diving]
IK_NumPad5=(Action=UpdateProgressOnThePath)
IK_NumPad6=(Action=DisplayProgressPreview)

- Into This File:

*\Documents\The Witcher 3\input.settings

- Copy and paste the following:

<!-- Progress on the Path Begin --> 
<Var builder="Input" id="UpdateProgressOnThePath" 		displayName="UpdateProgressOnThePath" 		displayType="INPUTPC" actions="UpdateProgressOnThePath"/>
<Var builder="Input" id="DisplayProgressPreview" 		displayName="DisplayProgressPreview" 		displayType="INPUTPC" actions="DisplayProgressPreview"/>
<!-- Progress on the Path End -->

- Into This File:

*\The Witcher 3\bin\config\r4game\user_config_matrix\pc\input.xml

//--------------------------------------------------------
//----------------- Menu Building (NG ONLY) --------------
//--------------------------------------------------------

-Copy and paste the following:

modProgressOnThePath.xml;

- Into These 2 Files:

*The Witcher 3\bin\config\r4game\user_config_matrix\pc\dx11filelist.txt
*The Witcher 3\bin\config\r4game\user_config_matrix\pc\dx12filelist.txt

NOTE: Some users have reported problems if this line is at the very end of the file list, if you have any issues displaying the menu then move the line further up the file list.

//--------------------------------------------------------
//-------------------------- End -------------------------
//--------------------------------------------------------