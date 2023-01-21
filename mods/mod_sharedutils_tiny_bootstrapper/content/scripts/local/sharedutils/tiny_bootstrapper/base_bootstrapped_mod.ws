class SU_BaseBootstrappedMod 
{
	public saved var tag: name;
		default tag = 'SU_BaseBootstrappedMod';

	// This function is called on all bootstrapped mods 
	// when Initialize is called in CPlayerInput
	public function start(){;}

	// This function is called on all bootstrapped mods 
	// when OnDestroy is called in CPlayerInput.
	public function stop(){;}
}