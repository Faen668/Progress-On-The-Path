exec function SUG_example() {
  var book: SU_GlossaryEntry;

  book = new SU_GlossaryEntry in thePlayer;
  book.entry_unique_id = 'SUGentryUniqueIdExample';

  book.drop_down_label = "Sharedutils - Custom Glossary Entries";
  book.drop_down_tag = 'SharedutilsCustomGlossaryEntries';
  
  book.title = "Custom glossary entry example";
  book.description = "Lorem ipsum dolor sit amet consectitur";

  LogChannel('SUG', "added = " + SU_addGlossaryEntry(book));
}

exec function SUG_exampleRemove() {
  var book: SU_GlossaryEntry;

  book = SUG_getManager().getEntry("Custom glossary entry example");

  if (book) {
    SU_removeGlossaryEntry(book);
  }
}

exec function SUG_exampleChangeIcon() {
  var book: SU_GlossaryEntry;

  book = SUG_getManager().getEntry("Custom glossary entry example");

  if (book) {
    book.icon_path = "icons/inventory/scrolls/scroll1.dds";
  }
}
