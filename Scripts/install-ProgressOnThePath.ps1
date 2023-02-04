#Progress on the Path Install script by Faen668

cls

echo ""
write-host -BackgroundColor darkred "                                    "
write-host -ForegroundColor white -BackgroundColor darkred "  Progress on the Path Installer    "
write-host -BackgroundColor darkred "                                    "
echo ""
echo "- This script will automatically install Progress on the Path and its dependencies."
echo ""
write-Host '- Please make sure this script is placed in your ' -NoNewline; Write-Host -ForegroundColor green 'The Witcher 3 installation folder' -NoNewline; Write-Host '.'
echo ""
write-Host '- If you can see the folders ' -NoNewline; Write-Host -ForegroundColor green 'bin' -NoNewline; Write-Host ', ' -NoNewline; Write-Host -ForegroundColor green 'content'-NoNewline; Write-Host ' and ' -NoNewline; Write-Host -ForegroundColor green 'dlc' -NoNewline; Write-Host ', the script is in the correct place.'
echo ""
echo ""

$shouldInstall = Read-Host "- Install Progress on the Path [Y/N]"
while($shouldInstall -ne "y")
{
    if ($shouldInstall -eq 'n') 
	{
		exit
	}
	write-Host '*** Please Type ' -NoNewline; Write-Host -ForegroundColor darkgreen 'Y' -NoNewline; Write-Host ' to install the mod or ' -NoNewline; Write-Host -ForegroundColor darkred 'N' -NoNewline; Write-Host ' to exit.'
	echo ""
	$shouldInstall = Read-Host "- Install Progress on the Path [Y/N]"
}

cls

if (!(test-path dlc)) 
{
  echo ""
  write-host -ForegroundColor red "Please make sure the script is placed inside your The Witcher 3 installation directly."
  echo ""
  echo "- The script must be placed in the same folder alongside the bin, content, and dlc folders."
  echo ""
  echo "- Place it in your The Witcher 3 root directory correctly and run the script again."
  echo ""

  pause
  exit
}

# first we create the mods folder if it doesn't exist, because in clean installs
# this folder may be missing.
if (!(test-path mods)) {
  mkdir mods | out-null
}

write-host -BackgroundColor darkred "                                    "
write-host -ForegroundColor white -BackgroundColor darkred "  Progress on the Path Installer    "
write-host -BackgroundColor darkred "                                    "

echo ""
echo "- Fetching latest release from Github..."
echo ""

$response = Invoke-RestMethod -Uri "https://api.github.com/repos/Faen668/Progress-On-The-Path/releases"

echo ""
write-host "- Downloading Progress on the Path $($response[0].name)"
echo ""

$extractingFolder = "./__install_PotP"

$latestAssetUrl = "https://github.com/Faen668/Progress-On-The-Path/releases/download/5.1.1/Progress-on-the-Path.zip"
$latestAssetName = "Progress-on-the-Path.zip"
Invoke-WebRequest -Uri $latestAssetUrl -OutFile $latestAssetName

Expand-Archive -Force -LiteralPath $latestAssetName -DestinationPath ./$extractingFolder
remove-item $latestAssetName -recurse -force

$installMessage = "- Installing release {0}" -f $response[0].name

echo ""
echo $installMessage
echo ""

if (test-path mods/modProgressOnThePath) {
	Remove-Item mods/modProgressOnThePath -force -recurse
}

$children = Get-ChildItem ./$extractingFolder
foreach ($child in $children) {
  $fullpath = "{0}/{1}" -f $extractingFolder, $child
  copy-item $fullpath . -force -recurse
  write-host "    - $($child.name) Installed"
}

if (test-path $extractingFolder) {
  remove-item $extractingFolder -recurse -force
}

echo ""
write-Host '- Open the following two txt files:'
echo ""
Write-Host -ForegroundColor green 'bin\config\r4game\user_config_matrix\pc\dx11filelist.txt'
echo ""
Write-Host -ForegroundColor green 'bin\config\r4game\user_config_matrix\pc\dx12filelist.txt'
echo ""
write-Host '- If the line ' -NoNewline; Write-Host -ForegroundColor green 'modProgressOnThePath.xml;' -NoNewline; Write-Host ' does not exist in either of the files, add it.'
echo ""
write-Host '- A ' -NoNewline; Write-Host -ForegroundColor green 'README' -NoNewline; Write-Host ' file with all keybinds and settings can be found in the modProgressOnThePath folder.'
echo ""

$shouldShowKeybinds = Read-Host "- Would you like to view the README Now? [Y/N]"
while($shouldShowKeybinds -ne "y")
{
    if ($shouldShowKeybinds -eq 'n') 
	{
		break
	}

	write-Host '*** Please Type ' -NoNewline; Write-Host -ForegroundColor darkgreen 'Y' -NoNewline; Write-Host ' to install the mod or ' -NoNewline; Write-Host -ForegroundColor darkred 'N' -NoNewline; Write-Host ' to exit.'
	echo ""
	$shouldShowKeybinds = Read-Host "- Would you like to view the README Now? [Y/N]"
}

cls
write-host -BackgroundColor darkred "                                    "
write-host -ForegroundColor white -BackgroundColor darkred "  Progress on the Path Installer    "
write-host -BackgroundColor darkred "                                    "
echo ""

if ($shouldShowKeybinds -eq 'y')
{
	write-Host '- Open the following two files:'
	Write-Host -ForegroundColor green '\Documents\The Witcher 3\user.settings'
	Write-Host -ForegroundColor green '\Documents\The Witcher 3\dx12user.settings'
	echo ""
	echo "- At the top of the files copy and paste the following:"
	echo ""
	write-host -ForegroundColor gray -BackgroundColor black "[ProgressOnThePath_PreviewSettings]"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_Hide=false"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_Comp=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_Igno=false"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_Iden=false"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_QArea=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_QType=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_IType=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_GArea=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_GType=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_WArea=0"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_Preview_WType=0"
	echo ""
	write-host -ForegroundColor gray -BackgroundColor black "[ProgressOnThePath_GeneralSettings]"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_MeditationUpdate=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EnableHotKey=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_ShowMapPins=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_MapPinDescription=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_MapPinRadius=30"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_MapPinType=1"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_ShowMiniMap=false"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_ArrowPointers=false"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_EventMapPins_HighlightedPointers=false"
	echo ""
	write-host -ForegroundColor gray -BackgroundColor black "[ProgressOnThePath_NotificationSettings]"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_GlobalNotification_Time=7"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_GlobalNotification_Size=18"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_GlobalNotification_Font=1"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_Quest=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_World=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_Items=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_Gwent=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_Event=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_FullNotification_Nulls=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_BackNotification_Quest=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_BackNotification_World=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_BackNotification_Items=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_BackNotification_Gwent=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_BackNotification_Event=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_MiscNotification_Event=true"
	write-host -ForegroundColor gray -BackgroundColor black "ProgressOnThePath_MiscNotification_Enter=true"
	echo ""

	write-Host '- Open the following file:'
	Write-Host -ForegroundColor green '\Documents\The Witcher 3\input.settings'
	echo ""
	echo "- At the top of the files copy and paste the following:"
	echo ""
	write-host -ForegroundColor gray -BackgroundColor black "[Exploration]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[Horse]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[Swimming]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[Boat]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[BoatPassenger]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[Combat]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	write-host -ForegroundColor gray -BackgroundColor black "[Diving]"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad5=(Action=UpdateProgressOnThePath)"
	write-host -ForegroundColor gray -BackgroundColor black "IK_NumPad6=(Action=DisplayProgressPreview)"
	echo ""

	write-Host '- Open the following file:'
	Write-Host -ForegroundColor green '\The Witcher 3\bin\config\r4game\user_config_matrix\pc\input.xml'
	echo ""
	echo "- At the top of the files copy and paste the following:"
	echo ""	
	
	
	write-host -ForegroundColor gray -BackgroundColor black "<!-- Progress on the Path Begin --> "
	write-host -ForegroundColor gray -BackgroundColor black "<Var builder="Input" id="UpdateProgressOnThePath" 		displayName="UpdateProgressOnThePath" 		displayType="INPUTPC" actions="UpdateProgressOnThePath"/>"
	write-host -ForegroundColor gray -BackgroundColor black "<Var builder="Input" id="DisplayProgressPreview" 		displayName="DisplayProgressPreview" 		displayType="INPUTPC" actions="DisplayProgressPreview"/>"
	write-host -ForegroundColor gray -BackgroundColor black "<!-- Progress on the Path End -->"
	write-host -ForegroundColor gray -BackgroundColor black ""
}

echo "- I hope you enjoy using the mod!"
echo ""
pause