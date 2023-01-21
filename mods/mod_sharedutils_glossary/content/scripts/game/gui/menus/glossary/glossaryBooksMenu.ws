/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




class CR4GlossaryBooksMenu extends CR4MenuBase
{
	private var SORT_WEIGHT_PAINTINGS : int;
	default SORT_WEIGHT_PAINTINGS = 10000;	
	private var SORT_WEIGHT_BOOKS : int;
	default SORT_WEIGHT_BOOKS = 20000;
	private var SORT_WEIGHT_Q : int;
	default SORT_WEIGHT_Q = 5000;
	private var SORT_WEIGHT_SQ : int;
	default SORT_WEIGHT_SQ = 4000;
	private var SORT_WEIGHT_MQ : int;
	default SORT_WEIGHT_MQ = 3000;
	private var SORT_WEIGHT_MH : int;
	default SORT_WEIGHT_MH = 2000;
	private var SORT_WEIGHT_TH : int;
	default SORT_WEIGHT_TH = 1000;
	
	event  OnConfigUI()
	{
		super.OnConfigUI();
		
		m_initialSelectionsToIgnore = 2;
		PopulateData();
	}
	
	private function PopulateData()
	{
		var defMgr		  : CDefinitionsManagerAccessor;
		var booksList     : array< name >;
		var paintingsList : array< name >;
		var dataArray     : CScriptedFlashArray;
		
		dataArray = m_flashValueStorage.CreateTempFlashArray();
		defMgr = theGame.GetDefinitionsManager();
		
		paintingsList = defMgr.GetItemsWithTag( 'Painting' );
		booksList = defMgr.GetItemsWithTag( 'ReadableItem' );
		
		PopulateListData( booksList, dataArray );
		PopulateListData( paintingsList, dataArray );

		// sharedutils - glossary - BEGIN
		SUG_populateListData(dataArray, m_flashValueStorage);
		// sharedutils - glossary - END
		
		m_flashValueStorage.SetFlashArray( "glossary.books.list", dataArray );
	}
	
	private function PopulateListData( booksList : array< name >, out flashDataList : CScriptedFlashArray ) : void
	{
		var playerInv    : CInventoryComponent = thePlayer.inv;
		var defMgr		 : CDefinitionsManagerAccessor;
		var dataObject   : CScriptedFlashObject;
		
		var bookName	 : name;
		var groupTag	 : name;
		var itemCategory : name;
		var bookTitle	 : string;
		var bookText	 : string;
		var bookIcon	 : string;
		var groupTitle	 : string;
		
		var isQuest        : bool;
		var isBookRead     : bool;
		var isReadableItem : bool;
		var isPainting     : bool;
		
		var i, count, idx  : int;
		
		defMgr = theGame.GetDefinitionsManager();
		count = booksList.Size();
		
		for( i = 0; i < count; i += 1 )
		{
			bookName = booksList[i];
			
			if( playerInv.IsBookReadByName( bookName ) )
			{
				itemCategory = defMgr.GetItemCategory( bookName );
				
				if( itemCategory != 'crafting_schematic' && itemCategory != 'alchemy_recipe' )
				{
					dataObject = m_flashValueStorage.CreateTempFlashObject();
					
					isPainting = defMgr.ItemHasTag( bookName, 'Painting' );
					isQuest = defMgr.ItemHasTag( bookName, 'Quest' );
					idx = getSortWeightByName( bookName );
					
					if( isQuest || idx > 0 )
					{
						groupTag = 'QuestBook';
						groupTitle = GetLocStringByKeyExt( "panel_glossary_questbooks" );
						dataObject.SetMemberFlashUInt( "sortIdx", idx );
						
					}
					else if( isPainting )
					{
						groupTag = 'Paintings';
						groupTitle = GetLocStringByKeyExt( "panel_glossary_questbooks" );
						dataObject.SetMemberFlashUInt( "sortIdx", SORT_WEIGHT_PAINTINGS );
					}
					else
					{
						groupTag = 'Books';
						groupTitle = GetLocStringByKeyExt( "panel_glossary_books" );
						dataObject.SetMemberFlashUInt( "sortIdx", SORT_WEIGHT_BOOKS );
					}
					
					if( isPainting )
					{
						dataObject.SetMemberFlashString( "imagePath", "img://icons/inventory/paintings/" + bookName + ".png" );
					}
					
					bookTitle = GetLocStringByKeyExt( playerInv.GetItemLocalizedNameByName( bookName ) );
					bookText = playerInv.GetBookTextByName( bookName );
					
					bookIcon = defMgr.GetItemIconPath( bookName );
					
					dataObject.SetMemberFlashUInt( "itemId", NameToFlashUInt( bookName ) );
					dataObject.SetMemberFlashUInt( "tag", NameToFlashUInt( bookName ) );
					dataObject.SetMemberFlashUInt( "dropDownTag",  NameToFlashUInt( groupTag ) );
					dataObject.SetMemberFlashBool( "dropDownOpened", IsCategoryOpened( groupTag ) );
					dataObject.SetMemberFlashString( "dropDownLabel", groupTitle );
					
					if ( m_guiManager.GetShowItemNames() )
					{
						bookTitle = bookTitle + "<br><font color=\"#FFDB00\">Item name: '" + bookName + "'</font>";
					}
					
					
					
					
					dataObject.SetMemberFlashString( "label", bookTitle );
					dataObject.SetMemberFlashString( "text", bookText );
					dataObject.SetMemberFlashString( "iconPath", bookIcon);
					dataObject.SetMemberFlashBool( "isQuest", isQuest);
					dataObject.SetMemberFlashBool( "isPainting", isPainting);
					dataObject.SetMemberFlashBool( "isNew", GetWitcherPlayer().IsBookRead( bookName ) );
					
					
					
					
					flashDataList.PushBackFlashObject( dataObject );
				}
			}
		}
	}
	
	private function getSortWeightByName( itemName : name ) : int
	{
		var strName  : string;
		var questStr : string;
		var weight	 : int;
		
		
		
		strName = NameToString( itemName );
		questStr = StrBeforeFirst( strName, "_" );
		
		if( StrBeginsWith( questStr, "q" ) )
		{
			weight = SORT_WEIGHT_Q + StringToInt( StrMid( questStr, 1 ) );
		}
		else
		if( StrBeginsWith( questStr, "sq" ) )
		{
			weight = SORT_WEIGHT_SQ + StringToInt( StrMid( questStr, 2 ) );
		}
		else
		if( StrBeginsWith( questStr, "mq" ) )
		{
			weight = SORT_WEIGHT_MQ + StringToInt( StrMid( questStr, 2 ) );
		}
		else
		if( StrBeginsWith( questStr, "mh" ) )
		{
			weight = SORT_WEIGHT_MH + StringToInt( StrMid( questStr, 2 ) );
		}
		else
		if( StrBeginsWith( questStr, "th" ) )
		{
			weight = SORT_WEIGHT_TH + StringToInt( StrMid( questStr, 2 ) );
		}
		
		return weight;
	}
	
	event OnReadBook( itemName : name )
	{
		GetWitcherPlayer().RemoveReadBook( itemName );
	}	
	
	event  OnClosingMenu() 
	{
		super.OnClosingMenu();
		theGame.GetGuiManager().SetLastOpenedCommonMenuName( GetMenuName() );
	}

	event  OnCloseMenu()
	{
		var commonMenu : CR4CommonMenu;
		
		commonMenu = (CR4CommonMenu)m_parentMenu;
		
		if( commonMenu )
		{
			commonMenu.ChildRequestCloseMenu();
		}
		
		theSound.SoundEvent( 'gui_global_quit' );
		
		CloseMenu();
	}
	
	
	event OnEntryRead( tag : name ) { }	
	event OnCategoryOpened( tag : name, opened : bool ) { }
	event OnEntrySelected( tag : name ) { }
	
	
	
	
	

	
	
	
	
}