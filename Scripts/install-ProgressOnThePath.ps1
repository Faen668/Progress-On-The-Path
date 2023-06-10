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
$latestversion = $response[0].name
$latestAssetUrl = "https://github.com/Faen668/Progress-On-The-Path/releases/latest/download/Progress-on-the-Path.zip"

echo ""
write-host "- Downloading Progress on the Path $($latestversion)"
echo ""

$extractingFolder = "./__install_PotP"


$latestAssetName = "Progress-on-the-Path.zip"
Invoke-WebRequest -Uri $latestAssetUrl -OutFile $latestAssetName

Expand-Archive -Force -LiteralPath $latestAssetName -DestinationPath ./$extractingFolder
remove-item $latestAssetName -recurse -force

$installMessage = "- Installing release {0}" -f $latestversion

echo ""
echo $installMessage
echo ""

if (test-path mods/modProgressOnThePath) 
{
	Remove-Item mods/modProgressOnThePath -force -recurse
}

if (test-path dlc/dlcProgressOnThePath) 
{
	Remove-Item dlc/dlcProgressOnThePath -force -recurse
}

if (test-path bin/config/r4game/user_config_matrix/pc/modProgressOnThePath.xml) 
{
	Remove-Item bin/config/r4game/user_config_matrix/pc/modProgressOnThePath.xml -force
}

$children = Get-ChildItem ./$extractingFolder
foreach ($child in $children) {
  $fullpath = "{0}/{1}" -f $extractingFolder, $child
  copy-item $fullpath . -force -recurse
}

#Install Scripts
echo ""
echo "- Installing Scripts"
$children = Get-ChildItem mods/modProgressOnThePath -recurse -exclude *.csv, *.w3strings, *.bundle, *.store, *.cache, *.txt, *.bat
foreach ($child in $children | Where-Object -Property PSIsContainer -eq $false)
{
  Write-Host -ForegroundColor green 'Installed' -NoNewline; Write-Host " - $($child.name)"
}

#Install Localisation
echo ""
echo "- Installing Localisation"
$children = Get-ChildItem mods/modProgressOnThePath -recurse -exclude *.ws, *.bundle, *.store, *.cache, *.txt, *.bat
foreach ($child in $children | Where-Object -Property PSIsContainer -eq $false)
{
  Write-Host -ForegroundColor green 'Installed' -NoNewline; Write-Host " - $($child.name)"
}

#Install Bundles
echo ""
echo "- Installing Mod Bundle"
$children = Get-ChildItem mods/modProgressOnThePath -recurse -exclude *.ws, *.csv, *.w3strings, *.txt, *.bat
foreach ($child in $children | Where-Object -Property PSIsContainer -eq $false)
{
  Write-Host -ForegroundColor green 'Installed' -NoNewline; Write-Host " - $($child.name)"
}

#Install Bundles
echo ""
echo "- Installing DLC Bundle"
$children = Get-ChildItem dlc/dlcProgressOnThePath -recurse -exclude *.ws, *.csv, *.w3strings, *.txt, *.bat
foreach ($child in $children | Where-Object -Property PSIsContainer -eq $false)
{
  Write-Host -ForegroundColor green 'Installed' -NoNewline; Write-Host " - $($child.name)"
}

if (test-path $extractingFolder) {
  remove-item $extractingFolder -recurse -force
}

$installedMessage = "=== Progress on the Path {0} installed ===" -f $latestversion

echo ""
write-host $installedMessage -ForegroundColor green -BackgroundColor black
echo ""

echo ""
pause

cls
write-host -BackgroundColor darkred "                                      "
write-host -ForegroundColor white -BackgroundColor darkred "   Installation Step: User Settings   "
write-host -BackgroundColor darkred "                                      "
echo ""

write-Host '- Open the following two files:'
echo ""
Write-Host -ForegroundColor green '\Documents\The Witcher 3\user.settings'
Write-Host -ForegroundColor green '\Documents\The Witcher 3\dx12user.settings'
echo ""
echo "- At the top of the files copy and paste the following:"
echo ""
write-host -ForegroundColor yellow "[ProgressOnThePath_PreviewSettings]"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_Hide=false"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_Comp=true"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_Igno=false"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_Iden=false"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_QArea=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_QType=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_IType=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_GArea=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_GType=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_WArea=0"
write-host -ForegroundColor yellow "ProgressOnThePath_Preview_WType=0"
echo ""
write-host -ForegroundColor yellow "[ProgressOnThePath_GeneralSettings]"
write-host -ForegroundColor yellow "ProgressOnThePath_MeditationUpdate=true"
write-host -ForegroundColor yellow "ProgressOnThePath_EnableHotKey=true"
write-host -ForegroundColor yellow "ProgressOnThePath_EventMapPins_ShowMapPins=true"
write-host -ForegroundColor yellow "ProgressOnThePath_EventMapPins_MapPinDescription=true"
write-host -ForegroundColor yellow "ProgressOnThePath_EventMapPins_MapPinRadius=30"
write-host -ForegroundColor yellow "ProgressOnThePath_EventMapPins_MapPinType=1"
echo ""
write-host -ForegroundColor yellow "[ProgressOnThePath_NotificationSettings]"
write-host -ForegroundColor yellow "ProgressOnThePath_GlobalNotification_Time=7"
write-host -ForegroundColor yellow "ProgressOnThePath_GlobalNotification_Size=18"
write-host -ForegroundColor yellow "ProgressOnThePath_GlobalNotification_Font=1"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_Quest=true"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_World=true"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_Items=true"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_Gwent=true"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_Event=true"
write-host -ForegroundColor yellow "ProgressOnThePath_FullNotification_Nulls=true"
write-host -ForegroundColor yellow "ProgressOnThePath_BackNotification_Quest=true"
write-host -ForegroundColor yellow "ProgressOnThePath_BackNotification_World=true"
write-host -ForegroundColor yellow "ProgressOnThePath_BackNotification_Items=true"
write-host -ForegroundColor yellow "ProgressOnThePath_BackNotification_Gwent=true"
write-host -ForegroundColor yellow "ProgressOnThePath_BackNotification_Event=true"
write-host -ForegroundColor yellow "ProgressOnThePath_MiscNotification_Event=true"
write-host -ForegroundColor yellow "ProgressOnThePath_MiscNotification_Enter=true"
echo ""

write-host -BackgroundColor darkred "                                           "
write-host -ForegroundColor white -BackgroundColor darkred "   Installation Step: Hotkeys (Optional)   "
write-host -BackgroundColor darkred "                                           "
echo ""
write-Host '- Open the following file:'
echo ""
Write-Host -ForegroundColor green '\Documents\The Witcher 3\input.settings'
echo ""
echo "- At the top of the file copy and paste the following:"
echo ""
write-host -ForegroundColor yellow "[Exploration]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[Horse]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[Swimming]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[Boat]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[BoatPassenger]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[Combat]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
write-host -ForegroundColor yellow "[Diving]"
write-host -ForegroundColor yellow "IK_NumPad5=(Action=UpdateProgressOnThePath)"
write-host -ForegroundColor yellow "IK_NumPad6=(Action=DisplayProgressPreview)"
echo ""

write-Host '- Open the following file:'
echo ""
Write-Host -ForegroundColor green '\The Witcher 3\bin\config\r4game\user_config_matrix\pc\input.xml'
echo ""
Write-Host '- Copy and paste the following code block into the file just before ' -NoNewline; Write-Host -ForegroundColor green '<!-- [BASE_CharacterMovement] -->'
echo ""	

write-host -ForegroundColor yellow "<!-- Progress on the Path Begin --> "
write-host -ForegroundColor yellow "<Var builder=""Input"" id=""UpdateProgressOnThePath"" 		displayName=""UpdateProgressOnThePath"" 	displayType=""INPUTPC"" actions=""UpdateProgressOnThePath""/>"
write-host -ForegroundColor yellow "<Var builder=""Input"" id=""DisplayProgressPreview"" 		displayName=""DisplayProgressPreview"" 		displayType=""INPUTPC"" actions=""DisplayProgressPreview""/>"
write-host -ForegroundColor yellow "<!-- Progress on the Path End -->"
write-host -ForegroundColor yellow ""

write-host -BackgroundColor darkred "                             "
write-host -ForegroundColor white -BackgroundColor darkred "   Installation Finished     "
write-host -BackgroundColor darkred "                             "
echo ""

echo "- I hope you enjoy using the mod!"
echo ""
pause