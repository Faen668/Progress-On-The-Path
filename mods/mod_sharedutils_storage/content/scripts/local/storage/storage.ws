
class SU_Storage {
  private var items: array<SU_StorageItem>;

  private function isTagValid(tag: string): bool {
    return tag != "";
  }

  private function isItemValid(item: SU_StorageItem): bool {
    if (!item) {
      return false;
    }

    return this.isTagValid(item.tag);
  }

  public function getItem(tag: string): SU_StorageItem {
    var i: int;

    SUST_Logger("SU_Storage::getItem(tag), tag = " + tag);

    if (!this.isTagValid(tag)) {
      SUST_Logger("SU_Storage::getItem(tag), invalid tag");

      return NULL;
    }

    SUST_Logger("SU_Storage::getItem(tag), items.Size() = " + this.items.Size());
    for (i = 0; i < this.items.Size(); i += 1) {
      if (this.items[i].tag == tag) {
        SUST_Logger("SU_Storage::getItem(tag), matching item found, i = " + i);

        return this.items[i];
      }
    }

    SUST_Logger("SU_Storage::getItem(tag), no matching item found");

    return NULL;
  }

  public function getItemIndex(tag: string): int {
    var i: int;

    if (!this.isTagValid(tag)) {
      return -1;
    }

    for (i = 0; i < this.items.Size(); i += 1) {
      if (this.items[i].tag == tag) {
        return i;
      }
    }

    return -1;
  }

  public function hasItem(tag: string): bool {
    return this.getItemIndex(tag) >= 0;
  }

  public function setItem(item: SU_StorageItem): bool {
    var i: int;

    if (!this.isItemValid(item)) {
      return false;
    }

    // if an item with the same tag already exists, replace it:
    if (!this.setItemAt(this.getItemIndex(item.tag), item)) {
      // otherwise push it to the array of items:
      this.items.PushBack(item);  
    }

    return true;
  }

  public function removeItem(item: SU_StorageItem) {
    this.items.Remove(item);
  }

  private function setItemAt(index: int, item: SU_StorageItem): bool {
    // out of bound
    if (index < 0 || index >= this.items.Size()) {
      return false;
    }

    if (!this.isItemValid(item)) {
      return false;
    }

    this.items[index] = item;

    return true;
  }
}
