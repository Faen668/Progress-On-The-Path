/**
 * This is a simple example to show to add your own custom pins at the given coordinates
 */
exec function SU_CustomMapPins_addPin(x: float, y: float) {
  var pin: SU_MapPin;

  pin = new SU_MapPin in thePlayer;
  pin.tag = "SU_ExampleMapPin";
  pin.position = Vector(x, y);
  pin.description = "This pin was added as an example of custom pins";
  pin.label = "custom pin example";
  pin.type = "MonsterQuest";
  pin.radius = 15;
  pin.region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

  thePlayer.addCustomPin(pin);
}
