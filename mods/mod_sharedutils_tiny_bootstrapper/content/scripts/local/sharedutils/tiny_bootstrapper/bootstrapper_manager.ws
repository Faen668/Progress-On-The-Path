statemachine class SU_TinyBootstrapperManager extends SU_StorageItem
{
	default tag = "SU_TinyBootstrapperManager";

	// Used internally by the manager to store the list of states 
	// that will bootstrap the mods.
	protected var states_to_process: array<name>;

	// The persistent list with the user-made mods
	protected saved var mods: array<SU_BaseBootstrappedMod>;

	// Cleared before bootstrapping mods, then contains the names of the 
	// mods that were bootstrapped this session. Meaning they were
	// injected BEFORE but no longer have a state that bootstraps them.
	protected var bootstrapped_mods_this_session: array<name>;
	
	public function init(): SU_TinyBootstrapperManager 
	{
		this.bootstrapped_mods_this_session.Clear();
		this.states_to_process = theGame.GetDefinitionsManager()
			.GetItemsWithTag('SU_TinyBootstrapperManager');
		
		this.GotoState('Initialising');
		return this;
	}
	
	protected function startMods()
	{
		var mod: SU_BaseBootstrappedMod;
		var i: int;

		for (i = 0; i < this.mods.Size(); i += 1) 
		{
			mod = this.mods[i];
			mod.start();
		}
	}
	
	public function stopMods() 
	{
		var mod: SU_BaseBootstrappedMod;
		var i: int;

		for (i = 0; i < this.mods.Size(); i += 1) 
		{
			mod = this.mods[i];
			mod.stop();
		}
	}

	// Remove the non bootstrapped mods from the list. The ones that were
	// injected previously but no longer have a state that bootstrapps them.
	protected function removeUnusedMods() 
	{
		var unused_tags: array<name>;
		var tag: name;
		var i: int;

		for (i = 0; i < this.bootstrapped_mods_this_session.Size(); i += 1) 
		{
			tag = this.bootstrapped_mods_this_session[i];

			if (this.hasModWithTag(tag)) {
				continue;
			}
			unused_tags.PushBack(tag);
		}

		for (i = 0; i < unused_tags.Size(); i += 1)
		{
				tag = unused_tags[i];
				this.removeMod(this.getModByTag(tag));
		}
	}
	
	public function hasModWithTag(tag: name): bool
	{
		var i: int;

		for (i = 0; i < this.mods.Size(); i += 1) 
		{
			if (this.mods[i].tag == tag) {
				return true;
			}
		}
		return false;
	}
	
	public function getModByTag(tag: name): SU_BaseBootstrappedMod
	{
		var i: int;

		for (i = 0; i < this.mods.Size(); i += 1)
		{
			if (this.mods[i].tag == tag)
			{
				return this.mods[i];
			}
		}
		return NULL;
	}
	
	public function addMod(mod: SU_BaseBootstrappedMod)
	{
		if (mod.tag == '') {
			return;
		}
		this.mods.PushBack(mod);
	}
	
	public function removeMod(mod: SU_BaseBootstrappedMod)
	{
		this.mods.Remove(mod);
	}

	protected function markModBootstrapped(tag: name)
	{
		this.bootstrapped_mods_this_session.PushBack(tag);
	}
}