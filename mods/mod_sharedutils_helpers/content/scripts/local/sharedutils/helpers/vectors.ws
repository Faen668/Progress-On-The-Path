/**
 * corrects the Z position of the supplied vector
 */
function SUH_groundPosition(out position : Vector) {
  var world : CWorld;
  var z : float;

  world = theGame.GetWorld();

  if (world.NavigationComputeZ(position, position.Z - 128, position.Z + 128, z)) {
    position.Z = z;
  }
  else if (world.PhysicsCorrectZ(position, z)) {
    position.Z = z;
  }
}