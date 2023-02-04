//---------------------------------------------------
//-- Bootstrapper Class -----------------------------
//---------------------------------------------------

state CProgressOnThePath_BootStrapper in SU_TinyBootstrapperManager extends BaseMod 
{
	public function getTag(): name 
	{
		return 'CProgressOnThePath_BootStrapper';
	}
	
	public function getMod(): SU_BaseBootstrappedMod 
	{
		return new CProgressOnThePath in parent;
	}
}

