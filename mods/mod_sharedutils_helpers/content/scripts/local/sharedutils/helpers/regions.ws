/**
  * list of possible regions:
  *  - no_mans_land
  *  - skellige
  *  - bob
  *  - prolog_village
  *  - kaer_morhen
  */
function SUH_getCurrentRegion(): string {
  var region: string;

  region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

  if (region == "novigrad") {
    return "no_mans_land";
  }

  if (region == "prolog_village_winter") {
    return "prolog_village";
  }

  return region;
}

/**
 * list of available regions:
 *  - no_mans_land
 *  - skellige
 *  - bob
 *  - prolog_village
 *  - kaer_morhen
 */
function SUH_isPlayerInRegion(region: string): bool {
  return SUH_getCurrentRegion() == region;
}

