/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CR4HudModuleMinimap2 extends CR4HudModuleBase
{
	private const var MINIMAP_EXTERIOR_ZOOM					: float;	default MINIMAP_EXTERIOR_ZOOM = 1.0;
	private const var MINIMAP_INTERIOR_ZOOM					: float;	default MINIMAP_INTERIOR_ZOOM = 2.0;
	private const var MINIMAP_BOAT_ZOOM						: float;	default MINIMAP_BOAT_ZOOM = 0.5;
	private const var HINT_WAYPOINTS_MAX_REMOVAL_DISTANCE	: float;	default HINT_WAYPOINTS_MAX_REMOVAL_DISTANCE	= 4.0;
	private const var HINT_WAYPOINTS_MIN_PLACING_DISTANCE	: float;	default HINT_WAYPOINTS_MIN_PLACING_DISTANCE	= 5.0;
	private const var HINT_WAYPOINTS_REFRESH_INTERVAL		: float;	default HINT_WAYPOINTS_REFRESH_INTERVAL		= 2.0;
	private const var HINT_WAYPOINTS_PATHFIND_TOLERANCE		: float;	default HINT_WAYPOINTS_PATHFIND_TOLERANCE	= 20.0;
	private const var HINT_WAYPOINTS_MAX_COUNT				: int;		default HINT_WAYPOINTS_MAX_COUNT			= 8;
	
	private var m_flashValueStorage : CScriptedFlashValueStorage;
	
	private var m_fxSetMapSettingsSFF				: CScriptedFlashFunction;
	private var m_fxSetTextureExtensionsSFF			: CScriptedFlashFunction;
	private var m_fxSetZoomSFF						: CScriptedFlashFunction;
	private var m_fxSetPlayerRotationSFF			: CScriptedFlashFunction;
	private var m_fxSetPlayerPositionSFF			: CScriptedFlashFunction;
	private var m_fxSetPlayerPositionAndRotationSFF	: CScriptedFlashFunction;
	private var m_fxNotifyPlayerEnteredInteriorSFF	: CScriptedFlashFunction;
	private var m_fxNotifyPlayerExitedInteriorSFF	: CScriptedFlashFunction;
	private var m_fxDoFadingSFF						: CScriptedFlashFunction;
	private var m_fxEnableRotationSFF				: CScriptedFlashFunction;
	private var m_fxEnableMask						: CScriptedFlashFunction;
	private var m_fxEnableDebug						: CScriptedFlashFunction;
	private var m_fxEnableBorders					: CScriptedFlashFunction;
		
	private var m_previousPlayerPosition			: Vector;
	private var m_previousPlayerAngle				: float;	default m_previousPlayerAngle = 0.;
	private var m_previousCameraAngle				: float;	default m_previousCameraAngle = 0.;
	private var m_zoomValue							: float; 	default m_zoomValue = 1.0f;
	private var m_forceUpdate						: bool;		default m_forceUpdate = false;
	private var m_updateInterval					: float;	default m_updateInterval = 0;
	private var m_fadedOut							: bool;		default m_fadedOut = true;
	
	private var m_weatherType			: name;
	private var m_gameHour 				: int;			default m_gameHour = -1;
	private var m_gameMin				: int; 			default m_gameMin = -1;
	private var m_buffedMonsterIconPath	: name;	
	private var m_dayTimeName			: name;	
	
	private const var	PLAYER_ANGLE_EPSILON	: float;	default PLAYER_ANGLE_EPSILON = 1;
	private const var	CAMERA_ANGLE_EPSILON	: float;	default CAMERA_ANGLE_EPSILON = 1;
	private const var	GAME_HOUR_DAWN			: int;		default	GAME_HOUR_DAWN = 5;
	private const var	GAME_HOUR_DAY			: int;		default	GAME_HOUR_DAY = 8;
	private const var	GAME_HOUR_DUSK			: int;		default	GAME_HOUR_DUSK = 18;
	private const var	GAME_HOUR_NIGHT			: int;		default	GAME_HOUR_NIGHT = 20;
	
	public var b24HRFormat : bool;
	

	var bDisplayDayTime : bool;
	default bDisplayDayTime = true;
	var bDisplayBuffedMoster : bool;
	default bDisplayBuffedMoster = true;
	
	event  OnConfigUI()
	{
		var manager : CCommonMapManager;
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;
		
		
		var inGameConfigWrapper : CInGameConfigWrapper;

		m_flashValueStorage = GetModuleFlashValueStorage();
		m_anchorName = "mcAnchorMiniMap"; 
		
		super.OnConfigUI();

		flashModule = GetModuleFlash();

		m_fxSetMapSettingsSFF				= flashModule.GetMemberFlashFunction( "SetMapSettings" );
		m_fxSetTextureExtensionsSFF			= flashModule.GetMemberFlashFunction( "SetTextureExtensions" );
		m_fxSetZoomSFF						= flashModule.GetMemberFlashFunction( "SetZoom" );
		m_fxSetPlayerRotationSFF			= flashModule.GetMemberFlashFunction( "SetPlayerRotation" );
		m_fxSetPlayerPositionSFF			= flashModule.GetMemberFlashFunction( "SetPlayerPosition" );
		m_fxSetPlayerPositionAndRotationSFF	= flashModule.GetMemberFlashFunction( "SetPlayerPositionAndRotation" );
		m_fxNotifyPlayerEnteredInteriorSFF	= flashModule.GetMemberFlashFunction( "NotifyPlayerEnteredInterior" );
		m_fxNotifyPlayerExitedInteriorSFF	= flashModule.GetMemberFlashFunction( "NotifyPlayerExitedInterior" );
		m_fxDoFadingSFF						= flashModule.GetMemberFlashFunction( "DoFading" );
		m_fxEnableRotationSFF				= flashModule.GetMemberFlashFunction( "EnableRotation" );
		m_fxEnableMask						= flashModule.GetMemberFlashFunction( "EnableMask" );
		m_fxEnableDebug						= flashModule.GetMemberFlashFunction( "EnableDebug" );
		m_fxEnableBorders					= flashModule.GetMemberFlashFunction( "EnableBorders" );
		
		b24HRFormat = GetCurrentTextLocCode() != "EN";

		LoadMinimapSettings();
		
		m_zoomValue = MINIMAP_EXTERIOR_ZOOM;
		SetZoom( m_zoomValue, true );

		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
		{
			EnableRotation( hud.IsEnabledMinimapRotation() );
		}

		m_fadedOut = true;
		DoFading( !m_fadedOut, true );

		
		
		SetTickInterval( 1 );
		
		if (hud)
		{
			
			
			hud.UpdateHudConfig('Minimap2Module', true);		
			// sharedutils - mappins - BEGIN
			SU_updateMinimapPins();
			// sharedutils - mappins - END
		}
		
		manager = theGame.GetCommonMapManager();
		if ( manager )
		{
			manager.InitializeMinimapManager( this );
			manager.SetHintWaypointParameters(
				HINT_WAYPOINTS_MAX_REMOVAL_DISTANCE
				, HINT_WAYPOINTS_MIN_PLACING_DISTANCE
				, HINT_WAYPOINTS_REFRESH_INTERVAL
				, HINT_WAYPOINTS_PATHFIND_TOLERANCE
				, HINT_WAYPOINTS_MAX_COUNT );
		}
		
		
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		minimapDuringFocusCombat = inGameConfigWrapper.GetVarValue('Hud', 'MinimapDuringFocusCombat');
		
	}
	
	
	private var isInCombat : bool;
	private var isInFocus : bool;
	private var dlgPlaying : bool;
	public function SetIsInDlg(dlg : bool)
	{
		if(!minimapDuringFocusCombat)
			return;
	
		dlgPlaying = dlg;
		
		if(dlg)
		{			
			currentlyFading = false;
			isFading = false;
			SetEnabled(false);
		}
		else
		{
			currentlyFading = false;
			isFading = false;
		}
	}
	
	public function SetIsInCombat(combat : bool)
	{
		isInCombat = combat;
	}
	
	public function SetIsInFocus(focus : bool)
	{
		isInFocus = focus;
	}
	
	private var minimapDuringFocusCombat : bool;
	public function GetMinimapDuringFocusCombat() : bool
	{
		return minimapDuringFocusCombat;
	}
	
	public function SetMinimapDuringFocusCombat(enable : bool)
	{
		var hud : CR4ScriptedHud;
	
		minimapDuringFocusCombat = enable;
		if(!minimapDuringFocusCombat)
		{
			hud = (CR4ScriptedHud)theGame.GetHud();
			if ( hud )
				hud.UpdateHudConfig('Minimap2Module', true);	
		}
		else
		{
			fadeInTimer = 5.5;
		}
	}
	
	private var fadeInTimer : float;
	private var isFading, currentlyFading : bool;
	private var fadeOutTime : float;	default fadeOutTime = 0.3f;
	private var fadeTime : float;
	
	private function FadeMinimapOut(dt : float)
	{		
		if(dlgPlaying)
			return;
	
		fadeInTimer -= dt;
		if(fadeInTimer > 0)
			return;
	
		currentlyFading = true;
		fadeTime -= dt;
		
		if(!theGame.IsDialogOrCutscenePlaying() && !theGame.IsFading())
			GetModuleFlash().SetAlpha( 100 * MaxF( 0, fadeTime / fadeOutTime ) );
		
		if(fadeTime <= 0)
		{
			SetEnabled(false);
			currentlyFading = false;
			isFading = false;
		}
	}
	
	
	event  OnTick( timeDelta : float )
	{
		
		var hud : CR4ScriptedHud;		
		var horseRacing, dlg : bool;
		
		horseRacing = false;

		if(!dlgPlaying && minimapDuringFocusCombat)
		{		
			if(thePlayer.GetIsHorseRacing())
				horseRacing = true;
		
			if(currentlyFading || (isFading && !isInFocus && !isInCombat && !horseRacing))
			{
				FadeMinimapOut(timeDelta);
				UpdatePlayerPositionAndRotation( timeDelta );
				
			}		
		
			else if(!currentlyFading && (isInFocus || isInCombat || horseRacing))
			{
				hud = (CR4ScriptedHud)theGame.GetHud();
				if ( hud )
				{
					hud.UpdateHudConfig('Minimap2Module', true);
					fadeInTimer = 5.5f;
					isFading = false;
				}
			}
			else if (!isFading && GetEnabled())
			{
				isFading = true;
				fadeTime = fadeOutTime;
				FadeMinimapOut(timeDelta);
				
			}
		}
		
	
		UpdateZoom();
		UpdatePlayerPositionAndRotation( timeDelta );
		
		if ( !CanTick( timeDelta ) )
		{
			return true;
		}
		
		UpdateWeatherDisplay();
		
	}

	
	

	public function AddMapPath( path : SMapPathInstance )
	{
		var pathObject			: CScriptedFlashObject;
		var pointObject			: CScriptedFlashObject;
		var pointArray			: CScriptedFlashArray;
		var i 					: int;

		pathObject = GetModuleFlashValueStorage().CreateTempFlashObject();
		
		

		pathObject.SetMemberFlashInt(    "id",        path.id );
		pathObject.SetMemberFlashNumber( "x",         path.position.X );
		pathObject.SetMemberFlashNumber( "y",         path.position.Y );
		pathObject.SetMemberFlashInt(    "color",     path.color );
		pathObject.SetMemberFlashNumber( "lineWidth", path.lineWidth );

		pointArray = GetModuleFlashValueStorage().CreateTempFlashArray();
		for ( i = 0; i < path.splinePoints.Size(); i += 1 )
		{
			pointObject = m_flashValueStorage.CreateTempFlashObject();
			pointObject.SetMemberFlashNumber( "x", path.splinePoints[ i ].X );
			pointObject.SetMemberFlashNumber( "y", path.splinePoints[ i ].Y );
			pointArray.PushBackFlashObject( pointObject );
		}
		pathObject.SetMemberFlashArray(  "splinePoints",    pointArray );
		
		m_flashValueStorage.SetFlashObject( "hud.minimap.paths.add", pathObject );
	}
	
	public function DeleteMapPaths( ids : array< int > )
	{
		var idArray				: CScriptedFlashArray;
		var idObject			: CScriptedFlashObject;
		var i 					: int;

		idArray = GetModuleFlashValueStorage().CreateTempFlashArray();
		for ( i = 0; i < ids.Size(); i += 1 )
		{
			idObject = m_flashValueStorage.CreateTempFlashObject();
			idObject.SetMemberFlashInt( "id", ids[ i ] );
			idArray.PushBackFlashObject( idObject );
		}
		m_flashValueStorage.SetFlashArray( "hud.minimap.paths.delete", idArray );
	}
	
	public function NotifyPlayerEnteredInterior( areaPos : Vector, areaYaw : float, texture : string )
	{
		var fullPath : string;
		var hud : CR4ScriptedHud;

		fullPath = "interiors/" + texture + ".png";
		
		LogChannel( 'INTERIORS', "NotifyPlayerEnteredInterior " + texture );
		m_fxNotifyPlayerEnteredInteriorSFF.InvokeSelfFourArgs( FlashArgNumber( areaPos.X ), FlashArgNumber( areaPos.Y ), FlashArgNumber( areaYaw ), FlashArgString( fullPath ) );
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
		{
			hud.SetMinimapZoom( MINIMAP_INTERIOR_ZOOM );
		}
	}

	public function NotifyPlayerExitedInterior()
	{
		var hud : CR4ScriptedHud;
		
		LogChannel( 'INTERIORS', "NotifyPlayerExitedInterior" );
		m_fxNotifyPlayerExitedInteriorSFF.InvokeSelf();

		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
		{
			hud.SetMinimapZoom( MINIMAP_EXTERIOR_ZOOM );
		}
	}
	
	public function NotifyPlayerMountedBoat()
	{
		var hud : CR4ScriptedHud;

		hud = (CR4ScriptedHud)theGame.GetHud();
		if( hud )
		{
			hud.SetMinimapZoom( MINIMAP_BOAT_ZOOM );
		}
	}

	public function NotifyPlayerDismountedBoat()
	{
		var hud : CR4ScriptedHud;

		hud = (CR4ScriptedHud)theGame.GetHud();
		if( hud )
		{
			hud.SetMinimapZoom( MINIMAP_EXTERIOR_ZOOM );
		}
	}
	
	
	
	
	private function UpdateZoom()
	{
		var hud : CR4ScriptedHud;
		var zoomValue : float;
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		if ( hud )
		{
			zoomValue = hud.GetMinimapZoom();
			if ( m_zoomValue != zoomValue )
			{
				m_zoomValue = zoomValue;
				SetZoom( m_zoomValue, false );
			}
		}
	}
	
	private function UpdatePlayerPositionAndRotation( timeDelta : float )
	{
		var position : Vector;
		var playerRotation : EulerAngles;
		var playerAngle : float;
		var cameraAngle : float;
		var hud : CR4ScriptedHud;
		var updateMapPins : bool;
		var updatePlayerPosition : bool;
		var updatePlayerRotation : bool;

		updatePlayerPosition = false;
		updatePlayerRotation = false;

		hud = (CR4ScriptedHud)theGame.GetHud();

		position = thePlayer.GetWorldPosition();
		cameraAngle = theCamera.GetCameraHeading();
		playerRotation = thePlayer.GetWorldRotation();
		playerAngle = playerRotation.Yaw;
			
		if ( cameraAngle < 0 )
		{
			cameraAngle += 360.0;
		}
		if ( playerAngle < 0 )
		{
			playerAngle += 360.0;
		}

		if ( m_forceUpdate ||
			 AbsF( playerAngle - m_previousPlayerAngle ) > PLAYER_ANGLE_EPSILON ||
			 AbsF( cameraAngle - m_previousCameraAngle ) > CAMERA_ANGLE_EPSILON )
		{
			m_previousPlayerAngle = playerAngle;
			m_previousCameraAngle = cameraAngle;
			
			updatePlayerRotation = true;
		}

		m_updateInterval -= timeDelta;
		if ( m_forceUpdate )
		{
			m_updateInterval = 0;
		}
		
		updateMapPins = false;
		if ( m_updateInterval <= 0 )
		{
			updateMapPins = true;
			m_forceUpdate = true;
			m_updateInterval += 0.2;
		}

		if ( m_forceUpdate ||
			 position.X != m_previousPlayerPosition.X ||
			 position.Y != m_previousPlayerPosition.Y ||
			 position.Z != m_previousPlayerPosition.Z )
		{
			m_previousPlayerPosition = position;

			updatePlayerPosition = true;
		}	
		
		if ( updatePlayerPosition && updatePlayerRotation )
		{
			m_fxSetPlayerPositionAndRotationSFF.InvokeSelfSixArgs( FlashArgNumber( position.X ), FlashArgNumber( position.Y ), FlashArgNumber( position.Z ), FlashArgBool( updateMapPins ), FlashArgNumber( cameraAngle ), FlashArgNumber( playerAngle ) );
		}
		else if ( updatePlayerPosition )
		{
			m_fxSetPlayerPositionSFF.InvokeSelfFourArgs( FlashArgNumber( position.X ), FlashArgNumber( position.Y ), FlashArgNumber( position.Z ), FlashArgBool( updateMapPins ) );
		}
		else if ( updatePlayerRotation )
		{
			m_fxSetPlayerRotationSFF.InvokeSelfTwoArgs( FlashArgNumber( cameraAngle ), FlashArgNumber( playerAngle ) );
		}

		m_forceUpdate = false;
	}
	
	private function UpdateBuffedMonsterDisplay()
	{
		var monsterName : name;
		var monsterIcon : name;
		var journalManager : CWitcherJournalManager;

		journalManager = theGame.GetJournalManager();	
		
		if( bDisplayBuffedMoster && !thePlayer.IsCiri() )
		{			
			monsterName = journalManager.GetCurrentlyBuffedCreatureName();
			
			if (monsterName)
			{
				monsterIcon = HAXGetMonsterIconFromJournalName(monsterName);
			}

			if( m_buffedMonsterIconPath != monsterIcon )
			{
				m_buffedMonsterIconPath = monsterIcon;
				m_flashValueStorage.SetFlashString('hud.buffed.monster',m_buffedMonsterIconPath);
				m_flashValueStorage.SetFlashString('hud.buffed.text',HAXGetMonsterNameByIcon(m_buffedMonsterIconPath));
			}
		}
		else if( m_buffedMonsterIconPath != '' )
		{
			m_buffedMonsterIconPath = '';
			m_flashValueStorage.SetFlashString('hud.buffed.monster',"");
		}
	}
	
	private function HAXGetMonsterIconFromJournalName(jourName : name) : name
	{
		var iconName:name;
		
		switch (jourName)
		{
			case 'bestiary_siren':
				iconName = 'ICO_syrena.png';
				break;
			default:
			case 'bestiary_noonwright':
				iconName = 'ICO_poludnica.png';
				break;
			case 'bestiary_wildhunt': 
			case 'bestiary_werewolf':
				iconName = 'ICO_werewolf.png';
				break;
			case 'bestiary_ghoul':
				iconName = 'ICO_ghul.png';
				break;
			case 'bestiary_icegiant':
				iconName = 'ICO_icegiant.png';
				break;
			case 'bestiary_water_hag':
				iconName = 'ICO_waterhag.png';
				break;
		}
		
		return iconName;
	}
	
	private function HAXGetMonsterNameByIcon(icon : name ) : string
	{
		var locKey : string;
		switch(icon)
		{
			case 'ICO_poludnica.png' :
				locKey = "panel_hud_monstertype_noonwraith";
				break;

			case 'ICO_bies.png' :
				locKey = "panel_hud_monstertype_bies";
				break;

			case 'ICO_syrena.png' :
				locKey = "panel_hud_monstertype_siren";
				break;

			case 'ICO_ghul.png' :
				locKey = "panel_hud_monstertype_ghul";
				break;
			case 'ICO_werewolf.png' :
				locKey = "panel_hud_monstertype_werewolf";
				break;
			case 'ICO_waterhag.png' :
				locKey = "panel_hud_monstertype_waterhag";
				break;
		}
		return GetLocStringByKeyExt(locKey);
	}
	
	private function GetCurrentTimeString() : string
	{
		var gameTime : GameTime = theGame.GetGameTime();
		var hours : int;
		var minutes : int;
		var timeString : string = "";
		var timePeriod : string = "";
		
		hours = GameTimeHours( gameTime );
		minutes = GameTimeMinutes( gameTime );
		
		
		if ( !b24HRFormat )
		{
			if (hours >= 12)
			{
				if ( hours > 12 )
					hours -= 12;

                timePeriod = " PM";			
			}
			else 
			{
				if ( hours == 0 )
					hours = 12;

				timePeriod = " AM";
			}		
		}
		
		timeString = hours + ":";
		
		if (minutes < 10)
		{
			timeString += "0";
		}
		
		timeString += minutes;
		timeString += timePeriod; 
		
		return timeString;
	}
	
	function RefreshTimeDisplay() 
	{
		m_flashValueStorage.SetFlashString('hud.worldcondition.text', GetCurrentTimeString() + " / "+GetLocStringByKeyExt("panel_hud_weathertype_"+m_weatherType));
	}
	
	private function UpdateWeatherDisplay()
	{
		var currentWeather : name = 'Clear';
		var currentDayTimeName : name;
		var curGameTime : GameTime;
		var curGameHour: int;
		var curGameMin: int;
		var dayPart : EDayPart;

		currentDayTimeName = m_dayTimeName;
			
		curGameTime = GameTimeCreate();
		curGameHour = GameTimeHours( curGameTime );	
        curGameMin = GameTimeMinutes( curGameTime );			

		if ( m_gameMin != curGameMin )
		{
			if ( curGameHour >= 22 || curGameHour < 4 )
			{
				DoFading( true, false );
			}
			else
			{
				DoFading( false, false );
			}
		}

		if ( !thePlayer.IsCiri() && bDisplayDayTime && !thePlayer.GetWeatherDisplayDisabled() )
		{
			if ( m_gameHour != curGameHour)
			{
				dayPart = GetDayPart(curGameTime);
				
				if(dayPart == EDP_Dawn)
				{
					
					currentDayTimeName = 'Dawn';
				}
				else if(dayPart == EDP_Noon)
				{
					
					currentDayTimeName = 'Noon';
				}
				else if(dayPart == EDP_Dusk)
				{
					
					currentDayTimeName = 'Dusk';
				}
				else if(dayPart == EDP_Midnight)
				{
					
					currentDayTimeName = 'Midnight'; 
				}
				else
				{
					LogAssert(false, "UpdateWeatherDisplay: unknow day part!");
				}
			}
			
			if( GetRainStrength() > 0 ) 
			{
				currentWeather = 'Rain';
			}
			else if( GetSnowStrength() > 0 )
			{
				currentWeather = 'Snow';
			}			
			
			if ( currentWeather != m_weatherType || currentDayTimeName != m_dayTimeName || m_gameHour != curGameHour || curGameMin != m_gameMin )
			{
				m_weatherType = currentWeather;
				m_dayTimeName = currentDayTimeName;
				m_gameHour = curGameHour;
				m_gameMin = curGameMin;
				m_flashValueStorage.SetFlashString('hud.worldcondition.weather',(m_dayTimeName + m_weatherType));
				RefreshTimeDisplay();
			}
		}
		else
		{
			m_weatherType = '';
			m_dayTimeName = '';
			m_flashValueStorage.SetFlashString('hud.worldcondition.weather',"");
			
			if ( m_gameHour != curGameHour || m_gameMin != curGameMin )
			{
				m_gameHour = curGameHour;
				m_gameMin = curGameMin;
			}
		}
	}

	public function EnableMask( enable : bool )
	{
		m_fxEnableMask.InvokeSelfOneArg( FlashArgBool( enable ) );
	}
	
	public function EnableDebug( enable : bool )
	{
		m_fxEnableDebug.InvokeSelfOneArg( FlashArgBool( enable ) );
	}
	
	public function EnableBorders( enable : bool )
	{
		m_fxEnableBorders.InvokeSelfOneArg( FlashArgBool( enable ) );
	}

	private function LoadMinimapSettings() : void
	{
		var world : CWorld;
		var levelSize : float;
		var tileCount  : int;
		var exteriorTextureSize  : int;
		var interiorTextureSize  : int;
		var exteriorTextureExtension : string;
		var interiorTextureExtension : string;
		var areaName  : int;
		var levelName : string;
		
		world = theGame.GetWorld();
		world.GetTerrainParameters( levelSize, tileCount );

		levelName = StrAfterLast(theGame.GetWorld().GetPath(),StrChar(92)); 
		levelName = StrReplace( levelName, ".w2w", "" );
		
		areaName = (int) AreaNameToType(levelName);
		
		exteriorTextureSize			= theGame.GetMiniMapExteriorTextureSize( areaName );
		interiorTextureSize			= theGame.GetMiniMapInteriorTextureSize( areaName );
		exteriorTextureExtension	= theGame.GetMiniMapExteriorTextureExtension( areaName );
		interiorTextureExtension	= theGame.GetMiniMapInteriorTextureExtension( areaName );
		
		
		if ( levelSize == 0 )
		{
			levelSize = 6000;
		}
		if ( exteriorTextureSize == 0 )
		{
			exteriorTextureSize = 512;
		}
		if ( interiorTextureSize == 0 )
		{
			interiorTextureSize = 1024;
		}
		if ( tileCount == 0 )
		{
			tileCount = 16;
		}
		
		if ( m_fxSetMapSettingsSFF )
		{
			m_fxSetMapSettingsSFF.InvokeSelfFiveArgs(	FlashArgString( levelName ),
														FlashArgNumber( levelSize ),
														FlashArgInt   ( exteriorTextureSize ),
														FlashArgInt   ( interiorTextureSize ),
														FlashArgInt   (	tileCount )
													);
		}
		if ( m_fxSetTextureExtensionsSFF )
		{
			m_fxSetTextureExtensionsSFF.InvokeSelfTwoArgs(	FlashArgString( exteriorTextureExtension ),
															FlashArgString( interiorTextureExtension )
														);
		}
	}
	
	public function DoFading( fadeOut : bool,  immediately : bool )
	{
		if ( m_fadedOut != fadeOut )
		{
			m_fadedOut = fadeOut;
			m_fxDoFadingSFF.InvokeSelfTwoArgs( FlashArgBool( m_fadedOut ), FlashArgBool( immediately ) );
		}
	}

	public function EnableRotation( enable : bool )
	{
		m_fxEnableRotationSFF.InvokeSelfOneArg( FlashArgBool( enable ) );
		m_forceUpdate = true;
	}

	public function SetZoom( newValue : float, immediately : bool )
	{
		var manager : CCommonMapManager;

		m_fxSetZoomSFF.InvokeSelfTwoArgs( FlashArgNumber( newValue ), FlashArgBool( immediately ) );
		m_forceUpdate = true;
		
		manager = theGame.GetCommonMapManager();
		if ( manager )
		{
			manager.OnChangedMinimapRadius( 33 / newValue, newValue ); 
		}
	}
}

exec function mm_zoom( zoom : float )
{
	var hud : CR4ScriptedHud;
	
	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		hud.SetMinimapZoom( zoom );
	}
}

exec function mm_mask( enable : bool )
{
	var hud : CR4ScriptedHud;
	var minimapModule : CR4HudModuleMinimap2;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule( "Minimap2Module" );
		if ( minimapModule )
		{
			minimapModule.EnableMask( enable );
		}
	}
}

exec function mm_debug( enable : bool )
{
	var hud : CR4ScriptedHud;
	var minimapModule : CR4HudModuleMinimap2;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule( "Minimap2Module" );
		if ( minimapModule )
		{
			minimapModule.EnableDebug( enable );
		}
	}
}

exec function mm_borders( enable : bool )
{
	var hud : CR4ScriptedHud;
	var minimapModule : CR4HudModuleMinimap2;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule( "Minimap2Module" );
		if ( minimapModule )
		{
			minimapModule.EnableBorders( enable );
		}
	}
}

exec function mm_fade( fadeOut : bool, immediately : bool )
{
	var hud : CR4ScriptedHud;
	var minimapModule : CR4HudModuleMinimap2;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if ( hud )
	{
		minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule( "Minimap2Module" );
		if ( minimapModule )
		{
			minimapModule.DoFading( fadeOut, immediately );
		}
	}
}