
/**
 * This class doesn't offer much, it was initially created to be future proof
 * in case i want to add methods to the class later.
 */
class SU_StaticCamera extends CStaticCamera {
  public function start() {
    this.Run();
  }

  public function teleportAndLookAt(position: Vector, target: Vector) {
    var current_rotation: EulerAngles;
    
    current_rotation = VecToRotation(target - position);
    // because the Pitch (Y axis) is inverted by default
    current_rotation.Pitch *= -1;

    this.TeleportWithRotation(position, current_rotation);
  }
}

/**
 * helper function to quickly get a SU_StaticCamera
 */
latent function SU_getStaticCamera(): SU_StaticCamera {
  var template: CEntityTemplate;
  var camera: SU_StaticCamera;

  template = (CEntityTemplate)LoadResourceAsync(
    "dlc\dlcsharedutils\data\su_static_camera.w2ent",
    true
  );
  
  camera = (SU_StaticCamera)theGame.CreateEntity(
    template,
    thePlayer.GetWorldPosition(),
    thePlayer.GetWorldRotation()
  );

  return camera;
}