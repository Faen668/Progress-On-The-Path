# Reasons to use a sharedutils storage system
The `SU_Storage` module allows anyone to store data in the player's save in an efficient and merge friendly way.
The advantage of using a sharedutils module for storage is that even if 10 mods were to use the storage it would
still result in a single line to merge compared to 10 unique merges. All of the other sharedutils module were updated
to use the storage, greatly reducing the amount of merges created by the modules (even if they were already pretty small).

# Using it
Start by creating the type that will hold your data:
```js
class MyData extends SU_StorageEntry {
  default tag = "MyData";

  var anything: string;
}
```
make yourself a function to retrieve and create the data if it's the first retrieval:
```js
function getMyData(): MyData {
  var data: MyData;

  data = SU_getStorage().getItem("MyData");
  // create the data if it's the first time:
  if (!data) {
    data = new MyData in thePlayer;
    SU_getStorage().setItem(data);
  }

  return data;
}
```
finally use it like any other class:
```js
function example() {
  var my_data: MyData = getMyData();

  my_data.anything = "This string will be stored for later";
}
```