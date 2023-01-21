
//The state all global event listeners should extend.
state BaseMod in SU_TinyBootstrapperManager 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		SUTB_Logger(
			"SU_TinyBootstrapperManager Entered state [BaseMod]", false);
		
		this.registerMod();
		this.finish(); 
	}
	
	public function getTag(): name {
		return '';
	}
	
	public function getMod(): SU_BaseBootstrappedMod {
		return new SU_BaseBootstrappedMod in parent;
	}
	
	public final function finish() {
		parent.GotoState('Waiting');
	}
	
	public final function registerMod() {
		var tag: name;

		tag = this.getTag();
		parent.markModBootstrapped(tag);

		if (parent.hasModWithTag(tag)) 
		{
			return;
		}
		parent.addMod(this.getMod());
	}
}

state Empty in SU_TinyBootstrapperManager
{	
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		SUTB_Logger(
			"SU_TinyBootstrapperManager Entered state [Empty]", false);
		
		this.Empty_main();
	}
	
	entry function Empty_main() 
	{
		parent.removeUnusedMods();
		parent.startMods();
	}
}

state Initialising in SU_TinyBootstrapperManager 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		SUTB_Logger(
			"SU_TinyBootstrapperManager Entered state [Initialising]", false);
		
		this.Initialising_main();
	}
	
	entry function Initialising_main() 
	{
		while (!FactsDoesExist("q001_nightmare_ended")) 
		{
			Sleep(10);
		}
		parent.GotoState('Waiting');
	}
}

state Waiting in SU_TinyBootstrapperManager 
{
	event OnEnterState(previous_state_name: name) 
	{
		super.OnEnterState(previous_state_name);
		SUTB_Logger(
			"SU_TinyBootstrapperManager Entered state [Waiting]", false);
		
		this.Waiting_main(previous_state_name);
	}
	
	entry function Waiting_main(previous_state_name: name) 
	{
		this.startProcessingLastState();
	}
	
	function startProcessingLastState() {
		var last_state: name;
    
		if (parent.states_to_process.Size() <= 0) 
		{
			parent.GotoState('Empty');
			return;
		}

		last_state = parent.states_to_process.PopBack();
		parent.GotoState(last_state);
	}
}