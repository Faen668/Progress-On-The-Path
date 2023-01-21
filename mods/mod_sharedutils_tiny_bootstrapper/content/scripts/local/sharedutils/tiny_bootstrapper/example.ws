
/**
 * To create a bootstrapped mod you must add a state to the 
 * SU_TinyBootstrapperManager statemachine and extend BaseMod.
 *
 * In this example we are adding MyBootstrappedMod to the statemachine.
 *
 * Note that if two bootstrap mods have the same name the game won't compile,
 * this is intended to ensure good compatibility between mods. For this reason
 * you must use unique names.
 */ 

state MyBootstrappedMod in SU_TinyBootstrapperManager extends BaseMod
{
	public function getTag(): name
	{
		return 'MyBootstrappedMod';
	}
	
	public function getMod(): SU_BaseBootstrappedMod
	{
		return new MyBootstrappedMod in parent;
	}
}

class MyBootstrappedMod extends SU_BaseBootstrappedMod 
{
	public function start()
	{
		// ... do whatever you want
	}
}