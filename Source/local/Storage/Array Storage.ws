//---------------------------------------------------
//-- Storage Class ----------------------------------
//---------------------------------------------------
	
class CProgressOnThePath_ArrayStorage
{
	var TotalEntList	: array<PotP_PreviewEntry>;
	var TotalVarList	: array<string>;
	var TotalGrpList	: array<string>;
	var TotalIdeList	: array<string>;

	var fileName		: name;
	default fileName 	= 'PotP Array Storage';

//---------------------------------------------------

	function inititalise()
	{
		this.TotalVarList.Clear();
		this.TotalGrpList.Clear();
		this.TotalIdeList.Clear();
		this.TotalEntList.Clear();
	}
}

