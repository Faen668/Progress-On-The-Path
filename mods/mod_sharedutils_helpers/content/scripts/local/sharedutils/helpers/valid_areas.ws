/* This file contains utilities to get coordinates (a point) in any region
 * excluding things like: bodies of water, settlements, cities, mountains etc...
 *
 * Each function achieves one thing, you can then combine them. Here is an
 * example of how to do it:
 *
 * SUH_getSafeCoordinatesFromPoint(
 *   SUH_moveCoordinatesAwayFromSafeAreas(
 *     SUH_moveCoordinatesInsideValidAreas(thePlayer.GetWorldPosition())
 *   )
 * );
 */

/**
 * returns percent values in the [0;1] range based on the coordinates that were
 * supplied.
 */
function SUH_getPercentValuesFromCoordinates(point: Vector): Vector {
  var output: Vector;
  var min_x: float;
  var max_x: float;
  var min_y: float;
  var max_y: float;

  SUH_setMinAndMaxFromRegion(min_x, max_x, min_y, max_y);

  output.X = (point.X - min_x) / (max_x - min_x);
  output.Y = (point.Y - min_y) / (max_y - min_y);

  return output;
}

/**
 * because lots of bounties end up in bodies of water, this function returns 
 * the closest piece of land.
 */
function SUH_getSafeCoordinatesFromPoint(point: Vector): Vector {
  // we will use water depth to detect if the point is on land or in water
  // every other functions failed certainly because the game doesn't load
  // the data about the chunks until the player gets close enough.
  //
  // This function works everywhere, and returns 10 000 when it's on land
  // and a value between 0 and 100 or 200 when in a body of water.
  var water_depth: float;
  var signposts: array<CGameplayEntity>;
  var array_of_nodes: array<CNode>;
  var closest_signpost_node: CNode;
  var closest_signpost_position: Vector;
  var distance_in_z_level: float;
  var i: int;
  var output: Vector;

  return point;

  water_depth = theGame.GetWorld().GetWaterDepth(point);

  // it's on land, we can return now
  if (water_depth >= 5000) {
    return point;
  }

  // get all the signposts in the map
  FindGameplayEntitiesInRange(
    signposts,
    thePlayer,
    5000, // range, we'll have to check if 50 is too big/small
    100, // max results
    , // tag: optional value
    FLAG_ExcludePlayer,
    , // optional value
    'W3FastTravelEntity'
  );

  for (i = 0; i < signposts.Size(); i += 1) {
    array_of_nodes.PushBack((CNode)signposts[i]);
  }

  // then find the closest one
  closest_signpost_node = FindClosestNode(point, array_of_nodes);
  closest_signpost_position = closest_signpost_node.GetWorldPosition();

  // set the output at the starting point
  output = point;

  // note: we reuse i here, it will be used to calculate the iterations
  i = 0;

  do {
    i += 1;

    // then slowly get closer to the signpost position
    output = VecInterpolate(output, closest_signpost_position, 0.05 * i);

    // update the water depth
    water_depth = theGame.GetWorld().GetWaterDepth(Vector(output.X, output.Y, 2), true);
    
    distance_in_z_level = closest_signpost_position.Z - output.Z;

  // while the water depth is not over 5000 which means there is a body of water
  // at the current position
  } while ((water_depth < 5000 || distance_in_z_level > closest_signpost_position.Z * 0.05) && VecDistanceSquared2D(output, closest_signpost_position) > 5 * 5);

  // we do it one last time because the water level gets below 500 on shore too,
  // where this is still a bit of water.
  output = VecInterpolate(output, closest_signpost_position, 0.2);

  return output;
}

/**
 * the goal of this function is to move the supplied from outside pre-defined
 * safe areas in the world. The safe areas were made because the original bounds
 * are rectangular and sometimes to avoid a single unreachable area it would mean
 * removing 50% of the bound width, which we don't want.
 *
 * The safe areas are circles with a radius. We then loop over all the safe areas
 * and calculate a mean vector that will eventually move `point` out of ALL the
 * safe areas.
 *
 * The `exception_areas` are areas you can supply where if the point is inside one,
 * it will short-circuit the function and the point will not be moved by any of the
 * safe areas.
 */
function SUH_moveCoordinatesAwayFromSafeAreas(point: Vector, optional exception_areas: array<Vector>): Vector {
  var current_distance_percentage: float;
  var distance_from_center: float;
  var displacement_vector: Vector;
  var safe_areas: array<Vector>;
  var squared_radius: float;
  var i: int;

  // short-circuit:
  // If the point is inside any of the exception areas, we leave early and return
  // the unmodified `point`.
  for (i = 0; i < exception_areas.Size(); i += 1) {
    if (SUH_isPositionInsideArea(point, exception_areas[i])) {
      return point;
    }
  }

  safe_areas = SUH_getSafeAreasByRegion(
    AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea())
  );

  for (i = 0; i < safe_areas.Size(); i += 1) {
    squared_radius = safe_areas[i].Z * safe_areas[i].Z;
    distance_from_center = VecDistanceSquared2D(safe_areas[i], point);

    // the point is not inside the circle, skip
    if (distance_from_center > squared_radius) {
      continue;
    }

    current_distance_percentage = distance_from_center / squared_radius;

    displacement_vector += (
      point 
      - Vector(safe_areas[i].X, safe_areas[i].Y, point.Z)
    ) * (1 - current_distance_percentage);
  }

  return point + displacement_vector;
}

/**
 * the goal of this function is to move the supplied point inside the pre-defined
 * valid areas in the world. It will work in big steps:
 *  - 1. it will take the closest valid area
 *  - 2. then we move the point in the closest circle based on its X:Y coordinates.
 */
function SUH_moveCoordinatesInsideValidAreas(point: Vector): Vector {
  var areas: array<Vector>;
  var closest_area: Vector;
  var distance_from_area: float;
  var distance_from_closest_area: float;
  var region: string;
  var output: Vector;
  var i: int;

  region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

  if (region != "skellige") {
    return point;
  }

  areas.PushBack(Vector(-1828, 1190, 58));
  areas.PushBack(Vector(-1758, 1239, 56));
  areas.PushBack(Vector(-1641, 1284, 85));
  areas.PushBack(Vector(-1637, 1434, 61));
  areas.PushBack(Vector(-1555, 1543, 88));
  areas.PushBack(Vector(-1439, 1486, 60));
  areas.PushBack(Vector(-1355, 1411, 52));
  areas.PushBack(Vector(340, 1544, 32));
  areas.PushBack(Vector(313, 1591, 22));
  areas.PushBack(Vector(274, 1602, 19));
  areas.PushBack(Vector(1600, 1896, 74));
  areas.PushBack(Vector(1493, 1917, 60));
  areas.PushBack(Vector(1358, 1933, 94));
  areas.PushBack(Vector(1339, 1960, 85));
  areas.PushBack(Vector(2752, -116, 84));
  areas.PushBack(Vector(2759, 42, 89));
  areas.PushBack(Vector(2535, 203, 103));
  areas.PushBack(Vector(2541, 306, 47));
  areas.PushBack(Vector(2402, 155, 59));
  areas.PushBack(Vector(2212, 82, 26));
  areas.PushBack(Vector(2267, 35, 27));
  areas.PushBack(Vector(2419, 34, 27));
  areas.PushBack(Vector(2443, -16, 35));
  areas.PushBack(Vector(2491, -83, 36));
  areas.PushBack(Vector(2602, -132, 47));
  areas.PushBack(Vector(1536, -1921, 35));
  areas.PushBack(Vector(1709, -1925, 50));
  areas.PushBack(Vector(1675, -1804, 20));
  areas.PushBack(Vector(1592, -1809, 23));
  areas.PushBack(Vector(1863, -1942, 56));
  areas.PushBack(Vector(1936, -1902, 42));
  areas.PushBack(Vector(1999, -1982, 39));
  areas.PushBack(Vector(2130, -1946, 28));
  areas.PushBack(Vector(2201, -1944, 38));
  areas.PushBack(Vector(2302, -1977, 73));
  areas.PushBack(Vector(-1575, -758, 75));
  areas.PushBack(Vector(-1676, -632, 113));
  areas.PushBack(Vector(-1816, -619, 75));
  areas.PushBack(Vector(-1954, -638, 83));
  areas.PushBack(Vector(-2118, -655, 46));
  areas.PushBack(Vector(-1947, -820, 44));
  areas.PushBack(Vector(-1744, -824, 76));
  areas.PushBack(Vector(420, -1352, 54));
  areas.PushBack(Vector(172, -1322, 49));
  areas.PushBack(Vector(88, -1230, 53));
  areas.PushBack(Vector(-41, -1209, 54));
  areas.PushBack(Vector(-353, -940, 71));
  areas.PushBack(Vector(-429, -785, 78));
  areas.PushBack(Vector(-520, -566, 86));
  areas.PushBack(Vector(-520, -303, 182));
  areas.PushBack(Vector(-406, -206, 155));
  areas.PushBack(Vector(-200, -297, 175));
  areas.PushBack(Vector(-192, -537, 63));
  areas.PushBack(Vector(-124, -448, 53));
  areas.PushBack(Vector(31, -229, 132));
  areas.PushBack(Vector(237, -249, 198));
  areas.PushBack(Vector(188, -40, 103));
  areas.PushBack(Vector(310, -501, 143));
  areas.PushBack(Vector(436, -485, 90));
  areas.PushBack(Vector(361, -685, 66));
  areas.PushBack(Vector(254, -815, 78));
  areas.PushBack(Vector(298, -971, 80));
  areas.PushBack(Vector(543, -795, 59));
  areas.PushBack(Vector(631, -805, 31));
  areas.PushBack(Vector(380, -24, 123));
  areas.PushBack(Vector(203, 92, 64));
  areas.PushBack(Vector(223, 244, 77));
  areas.PushBack(Vector(-10, 419, 122));
  areas.PushBack(Vector(319, 555, 69));
  areas.PushBack(Vector(365, 298, 84));
  areas.PushBack(Vector(514, 184, 121));
  areas.PushBack(Vector(497, 357, 72));
  areas.PushBack(Vector(553, 588, 73));
  areas.PushBack(Vector(490, 629, 41));
  areas.PushBack(Vector(357, 738, 29));
  areas.PushBack(Vector(324, 795, 30));
  areas.PushBack(Vector(649, 694, 42));
  areas.PushBack(Vector(756, 706, 47));
  areas.PushBack(Vector(982, 627, 94));
  areas.PushBack(Vector(1092, 492, 34));
  areas.PushBack(Vector(1107, 404, 50));
  areas.PushBack(Vector(1164, 415, 38));
  areas.PushBack(Vector(1234, 373, 45));
  areas.PushBack(Vector(1307, 367, 31));
  areas.PushBack(Vector(1013, 213, 177));
  areas.PushBack(Vector(834, -89, 165));
  areas.PushBack(Vector(570, 13, 84));
  areas.PushBack(Vector(803, -310, 274));

  // 1. finding the closest area
  distance_from_closest_area = 10000000;

  for (i = 0; i < areas.Size(); i += 1) {
    distance_from_area = VecDistanceSquared2D(point, areas[i]);

    if (distance_from_area < distance_from_closest_area) {
      distance_from_closest_area = distance_from_area;
      closest_area = areas[i];
    }
  }

  // output = closest_area + VecRingRand(0, closest_area.Z);
  // output.Z = 0;

  // return output;

  return SUH_placeCircleCoordinatesAroundPoint(
    SUH_mapSquareToCircleCoordinates(
      SUH_getPercentValuesFromCoordinates(point)
    ),
    closest_area
  );
  
  // return point;
}

/**
 * this function returns if the position is inside any safe area. If it is it will
 * return true, if it is not inside a safe area then it will return false.
 */
function SUH_isPositionInsideSafeAreas(position: Vector): bool {
  var distance_from_center: float;
  var safe_areas: array<Vector>;
  var squared_radius: float;
  var i: int;

  safe_areas = SUH_getSafeAreasByRegion(
    AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea())
  );


  for (i = 0; i < safe_areas.Size(); i += 1) {
    if (SUH_isPositionInsideArea(position, safe_areas[i])) {
      return true;
    }
  }

  return false;
}

function SUH_isPositionInsideArea(point: Vector, area: Vector): bool {
  return VecDistanceSquared2D(
    Vector(point.X, point.Y, 0),
    Vector(area.X, area.Y, 0)
  ) <= area.Z * area.Z;
}

/**
 * internal function:
 * the safe areas are Vectors where X and Y are used for the coordinates,
 * and Z is the radius. I didn't want to create yet another struct for it.
 */
function SUH_getSafeAreasByRegion(region: string): array<Vector> {
  var areas: array<Vector>;

  /*
  // the javascript code used to generate the coordinates.
  // combined with the rergetpincoord command
  {
  // center of the circle
  const a = { x: -340, y: -450 };
  // edge of the circle
  const b = { x: -140, y: -320 };

  const radius = Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));

  `areas.PushBack(Vector(${a.x}, ${a.y}, ${Math.round(radius)}));`
  }

  */

  switch (region) {
    case "prolog_village":
    case "prolog_village_winter":
    break;

    case "no_mans_land":
    case "novigrad":
    areas.PushBack(Vector(340, 1980, 502)); // novigrad
    areas.PushBack(Vector(1760, 900, 215)); // oxenfurt
    // huge circle right of oxenfurt in the forest.
    areas.PushBack(Vector(2854, 1001, 529));
    areas.PushBack(Vector(193, -790, 362)); // lake around fyke island
    // huge circle on the left of the map,
    // a bit below novigrad on the Y axis
    areas.PushBack(Vector(-1368, 2139, 1778));

    // huge circle on top of novigrad,
    // covering the top left part of the map.
    areas.PushBack(Vector(240, 2760, 574));

    // wedding zone of HoS
    areas.PushBack(Vector(2271, 2512, 53));

    areas.PushBack(Vector(2369, -235, 310)); // lake on the bottom right part

    areas.PushBack(Vector(207, 136, 149)); // crow's perch

    break;

    case "skellige":
    areas.PushBack(Vector(-100, -636, 110)); // kaer trolde
    areas.PushBack(Vector(-90, -800, 162)); // big mountain south of the main island
    areas.PushBack(Vector(-1700, -1000, 304)); // forge mountain on the giant's island

    areas.PushBack(Vector(62, -149, 56)); // fayrlund
    areas.PushBack(Vector(81, 68, 77)); // rannvaig
    areas.PushBack(Vector(632, 39, 58)); // blandare
    areas.PushBack(Vector(388, -720, 57)); // fyresdal
    areas.PushBack(Vector(-201, -1000, 143)); // kaer muir & port
    break;

    case "kaer_morhen":
    areas.PushBack(Vector(-11, 19, 95)); // the keep
    areas.PushBack(Vector(130, 210, 183)); // the big mountain north of the keep
    areas.PushBack(Vector(-500, -700, 330)); // the mountain south west of the map
    areas.PushBack(Vector(-340, -450, 239)); // same
    areas.PushBack(Vector(-620, 500, 330)); // a mountain north west of the map
    areas.PushBack(Vector(-100, -106, 30)); // the tower near the keep
    break;

    case "bob":
    areas.PushBack(Vector(-2430, 1230, 2077)); // top left mountain
    areas.PushBack(Vector(1840, 1070, 1729)); // top right mountain
    areas.PushBack(Vector(1920, -2700, 1809)); // bottom right mountain
    areas.PushBack(Vector(-1700, -2700, 1294)); // bottom left mountain

    areas.PushBack(Vector(-750, -1230, 158)); // beauclair palace
    areas.PushBack(Vector(-490, -1415, 169)); // beauclair lower part
    areas.PushBack(Vector(-440, -1260, 311)); // beauclair top part
    break;
  }

  return areas;
}


/**
 * internal function:
 * maps coordinates that are in a square to a circle. The coordinates should be
 * expressed in % around the center  so values between -1 and 1.
 * It ignores the Z value too, and uses only X and Y.
 *
 * The formula used is from this website:
 * https://www.xarg.org/2017/07/how-to-map-a-square-to-a-circle/
 */
function SUH_mapSquareToCircleCoordinates(point: Vector): Vector {
  var x, y: float;
  var output: Vector;

  // in case the Z and W of the point are needed, we copy them.
  output = point;

  // first we convert the coordinates that are in the range [0; 1] to coordinates
  // in the range [-1; 1]
  x = point.X * 2 - 1;
  y = point.Y * 2 - 1;

  // convert to circle units
  output.X = x * SqrtF(1 - y * y / 2);
  output.Y = y * SqrtF(1 - x * x / 2);

  // // then we convert back to [0; 1] range
  // output.X = (output.X + 1) / 2;
  // output.Y = (output.Y + 1) / 2;

  return output;
}

/**
 * internal function:
 * the input is supposed to be a Vector where only X and Y matter and both values
 * range between -1 and 1 to represent a % value around the center of the circle.
 * You can map square coordinates to circle coordinates with the function:
 * SUH_mapSquareToCircleCoordinates
 *
 * This function however returns real coordinates around the `circle_center` based
 * on the supplied `circle_coordinates` that were supplied.
 * NOTE: the Vector for `circle_center` uses the Z in XYZ for the radius.
 */
function SUH_placeCircleCoordinatesAroundPoint(circle_coordinates: Vector, circle_center: Vector): Vector {
  return Vector(
    circle_center.X + circle_center.Z * circle_coordinates.X,
    circle_center.Y + circle_center.Z * circle_coordinates.Y
  );
}

/**
 * internal function:
 * returns the bounds of the current world
 */
function SUH_setMinAndMaxFromRegion(out min_x: float, out max_x: float, out min_y: float, out max_y: float) {
  var area: EAreaName;
  var area_string: string;

  area = theGame.GetCommonMapManager().GetCurrentArea();

  switch (area) {
    case AN_Prologue_Village:
    case AN_Prologue_Village_Winter:
    case AN_Spiral:
    case AN_CombatTestLevel:
    case AN_Wyzima:
    case AN_Island_of_Myst:
      min_x = -350;
      max_x = 375;
      min_y = -150;
      max_y = 235;
      break;

    case AN_Skellige_ArdSkellig:
      min_x = -1750;
      max_x = 1750;
      min_y = -1750;
      max_y = 1750;
      break;

    case AN_Kaer_Morhen:
      min_x = -180;
      max_x = 50;
      min_y = -500;
      max_y = 900;
      break;

    case AN_NMLandNovigrad:
    case AN_Velen:
      min_x = -350;
      max_x = 2500;
      min_y = -1000;
      max_y = 2500;
      break;

    default:
      area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

      if (area_string == "bob") {
        min_x = -1100;
        max_x = 1100;
        min_y = -1800;
        max_y = 800;
      }
      else {
        min_x = -300;
        max_x = 300;
        min_y = -300;
        max_y = 300;
      }

      break;
  }
}

/**
 * internal function:
 * returns real world coordinates from the percent values that were supplied.
 */
function SUH_getCoordinatesFromPercentValues(percent_x: float, percent_y: float): Vector {
  var output: Vector;
  var min_x: float;
  var max_x: float;
  var min_y: float;
  var max_y: float;

  SUH_setMinAndMaxFromRegion(min_x, max_x, min_y, max_y);

  output.X = min_x + (max_x - min_x) * percent_x;
  output.Y = min_y + (max_y - min_y) * percent_y;
  
  return output;
}