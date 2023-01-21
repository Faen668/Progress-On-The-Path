
function SU_addGlossaryEntry(glossary_entry: SU_GlossaryEntry): bool {
  return SUG_getManager().setEntry(glossary_entry);
}

function SU_removeGlossaryEntry(glossary_entry: SU_GlossaryEntry) {
  SUG_getManager().removeEntry(glossary_entry);
}

function SUG_getManager(): SU_GlossaryManager {
	var manager: SU_GlossaryManager;
	var storage: SU_Storage;

	storage = SU_getStorage();
	manager = (SU_GlossaryManager)storage.getItem("SU_GlossaryManager");

	if (!manager) {
		manager = new SU_GlossaryManager in storage;

		storage.setItem(manager);
	}

	return manager;
}

function SUG_populateListData(out flashDataList : CScriptedFlashArray, out m_flashValueStorage: CScriptedFlashValueStorage) {
  var dataObject: CScriptedFlashObject;
  var glossary_entry: SU_GlossaryEntry;
  var manager: SU_GlossaryManager;
  var i: int;

  manager = SUG_getManager();
  LogChannel('SUG', "entries count = " + manager.entries.Size());

  for (i = 0; i < manager.entries.Size(); i += 1) {
    glossary_entry = manager.entries[i];

    dataObject = m_flashValueStorage.CreateTempFlashObject();
    dataObject.SetMemberFlashUInt("sortIdx", glossary_entry.sort_index);
    dataObject.SetMemberFlashUInt("itemId", NameToFlashUInt(glossary_entry.entry_unique_id));
    dataObject.SetMemberFlashUInt("tag", NameToFlashUInt(glossary_entry.entry_unique_id));
    dataObject.SetMemberFlashUInt("dropDownTag",  NameToFlashUInt(glossary_entry.drop_down_tag));
    dataObject.SetMemberFlashBool("dropDownOpened", false);
    dataObject.SetMemberFlashString("dropDownLabel", glossary_entry.drop_down_label);
    dataObject.SetMemberFlashString("label", glossary_entry.getTitle());
    dataObject.SetMemberFlashString("text", glossary_entry.getDescription());
    dataObject.SetMemberFlashString("iconPath", glossary_entry.icon_path);
    dataObject.SetMemberFlashBool("isQuest", glossary_entry.is_quest);
    dataObject.SetMemberFlashBool("isPainting", glossary_entry.is_painting);
    dataObject.SetMemberFlashBool("isNew", glossary_entry.getIsNew());

    flashDataList.PushBackFlashObject(dataObject);
  }
}