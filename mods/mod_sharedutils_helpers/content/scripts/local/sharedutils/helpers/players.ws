/**
 * latent function that will sleep until the player reaches the position and
 * is in the supplied radius.
 */
latent function SUH_waitForPlayerToReachPoint(position: Vector, radius: float) {
  var distance_from_player: float;

  // squared radius to save performances by using VecDistanceSquared
  radius *= radius;
  distance_from_player = VecDistanceSquared2D(thePlayer.GetWorldPosition(), position);

  while (distance_from_player > radius) {
    SleepOneFrame();

    distance_from_player = VecDistanceSquared2D(thePlayer.GetWorldPosition(), position);
  }
}
