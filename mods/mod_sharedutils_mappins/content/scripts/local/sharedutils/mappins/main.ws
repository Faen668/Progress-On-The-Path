

function SU_updateCustomMapPins(out flash_array: CScriptedFlashArray, value_storage: CScriptedFlashValueStorage, shown_area: EAreaName) {
  var flash_object: CScriptedFlashObject;
  var custom_pins: array<SU_MapPin>;
  var current_pin: SU_MapPin;
  var region, shown_region: String;
  var i: int;

  custom_pins = SUMP_getCustomPins();

  region = SUH_getCurrentRegion();
  shown_region = AreaTypeToName(shown_area);

  for (i = 0; i < custom_pins.Size(); i += 1) {
    current_pin = custom_pins[i];
  
    // the player is not in the right region or right map view, we skip the pin.
    if (current_pin.region != region && current_pin.region != shown_region) {
      continue;
    }

    flash_object = value_storage.CreateTempFlashObject("red.game.witcher3.data.StaticMapPinData");
    flash_object.SetMemberFlashString("type", current_pin.type);
    flash_object.SetMemberFlashString("filteredType", current_pin.filtered_type);
    flash_object.SetMemberFlashString("label", current_pin.label);
    flash_object.SetMemberFlashString("description", current_pin.description);
    flash_object.SetMemberFlashNumber("posX", current_pin.position.X);
    flash_object.SetMemberFlashNumber("posY", current_pin.position.Y);
    flash_object.SetMemberFlashNumber("radius", RoundF(current_pin.radius));
    flash_object.SetMemberFlashBool("is_quest", current_pin.is_quest);
      
    //Constants - Should not be modified from these values for our purposes.
    flash_object.SetMemberFlashUInt("id", NameToFlashUInt('User'));
    flash_object.SetMemberFlashNumber("rotation", 0);
    flash_object.SetMemberFlashBool("isPlayer", false);
    flash_object.SetMemberFlashBool("isUserPin", false);
    flash_object.SetMemberFlashBool("highlighted", false);
    flash_object.SetMemberFlashBool("tracked", false);
    flash_object.SetMemberFlashBool("hidden", false);
    flash_array.PushBackFlashObject(flash_object);
  }
}


function SU_updateMinimapPins() {
  var minimapModule : CR4HudModuleMinimap2;
  var m_AddMapPin : CScriptedFlashFunction;
  var m_MovePin : CScriptedFlashFunction;
  var flashModule : CScriptedFlashSprite;
  var custom_pins: array<SU_MapPin>;
  var hud : CR4ScriptedHud;
  var pin: SU_MapPin;
  var i: int;

  hud = (CR4ScriptedHud)theGame.GetHud();
  if (hud) {
    minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

    if (minimapModule) {
      flashModule = minimapModule.GetModuleFlash();
      m_AddMapPin = flashModule.GetMemberFlashFunction( "AddMapPin" );
      m_MovePin = flashModule.GetMemberFlashFunction( "MoveMapPin" );

      custom_pins = SUMP_getCustomPins();

      for (i = 0; i < custom_pins.Size(); i += 1) {
        pin = custom_pins[i];

        if (!pin.appears_on_minimap) {
          continue;
        }

        m_AddMapPin.InvokeSelfNineArgs(
          FlashArgInt(i),
          FlashArgString("Enemy"), // tag
          FlashArgString("Enemy"), 
          FlashArgNumber(pin.radius), // radius
          FlashArgBool(pin.pointed_by_arrow), // can be pointed by arrows
          FlashArgInt(0), // priority
          FlashArgBool(true), // is quest pin
          FlashArgBool(false), // is user pin
          FlashArgBool(pin.highlighted), // highlighted
        );

        m_MovePin.InvokeSelfFourArgs(
          FlashArgInt(i),
          FlashArgNumber(pin.position.X),
          FlashArgNumber(pin.position.Y),
          FlashArgNumber(pin.radius)
        );
      }
    }
  }
}

function SUMP_addCustomPin(pin: SU_MapPin) {
  var manager: SUMP_Manager;

  manager = SUMP_getManager();
  manager.mappins.PushBack(pin);
}

function SUMP_getCustomPins(): array<SU_MapPin> {
  return SUMP_getManager().mappins;
}

function SUMP_Logger(message: string, optional informGUI: bool) {
	LogChannel('SUMP', message);
	
	if (informGUI) {
		theGame.GetGuiManager().ShowNotification("SUMP: " + message, 5, true);
	}
}
