
class SU_GlossaryEntry {
  var entry_unique_id: name;
  
  var sort_index: int;
  default sort_index = 2000;

  var drop_down_label: string;

  var drop_down_tag: name;

  var title: string;

  var description: string;

  var icon_path: string;
  default icon_path = "icons/inventory/books/book_1.png";

  var is_quest: bool;

  var is_painting: bool;

  var is_new: bool;

  function getDescription(): string {
    return this.description;
  }

  function getTitle(): string {
    return this.title;
  }

  function getIsNew(): bool {
    return this.is_new;
  }
}
