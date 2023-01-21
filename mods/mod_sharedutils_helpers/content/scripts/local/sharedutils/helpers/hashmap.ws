
// class SU_HashMap {
//   public var buckets: array<SU_HashMapBucket>;

//   public var buckets_count: int;

//   public var items_count: int;

//   public function init(): SU_HashMap {
//     var i: int;

//     this.buckets.Grow(29); // prime number
//     this.buckets_count = this.buckets.Size();

//     for (i = 0; i < this.buckets_count; i += 1) {
//       this.buckets[i] = new SU_HashMapBucket in this;
//     }

//     return this;
//   }

//   /**
//    *
//    */
//   public function insert(key: int, value: SU_HashMapValue) {
//     var bucket: SU_HashMapBucket;
//     var hash: int;

//     hash = this.getHash(key);
//     bucket = this.buckets[hash];

//     if (bucket.insert(SU_HashMapBucketItem(key, value))) {
//       items_count += 1;
//     }

//     if (this.getLoadFactor() > 0.9) {
//       this.allocateNewBuckets();
//     }
//   }

//   /**
//    *
//    */
//   public function get(key: int): SU_HashMapValue {
//     var item: SU_HashMapBucketItem;
//     var bucket: SU_HashMapBucket;
//     var hash: int;

//     hash = this.getHash(key);
//     bucket = this.buckets[hash];

//     item = bucket.get(key);

//     if (item) {
//       return item.value;
//     }

//     return NULL;
//   }

//   /**
//    *
//    */
//   public function remove(key: int) {
//     var bucket: SU_HashMapBucket;
//     var hash: int;

//     hash = this.getHash(key);
//     bucket = this.buckets[hash];

//     bucket.remove(key);
//   }

//   /**
//    * A hashing function with poor distribution
//    */ 
//   private function getHash(key: int): int {
//     LogChannel('SU_HashMap', "hash of " + key + " = " + ModF((key * 4289), this.buckets_count));


//     // 4289 is a prime number
//     return (int)ModF((key * 4289), this.buckets_count);
//   }

//   private function getLoadFactor(): float {
//     return this.items_count / this.buckets_count;
//   }

//   /**
//    *
//    */
//   private function allocateNewBuckets() {
//     var all_items: array<SU_HashMapBucketItem>;
//     var current_item: SU_HashMapBucketItem;
//     var i: int;
//     var k: int;

//     // 1.
//     // start by allocating the new buckets
//     i = this.buckets_count;

//     this.buckets_count = SU_getNextPrimeNumber(this.buckets_count);
//     this.buckets.Grow(this.buckets_count - i);

//     for (i; i < this.buckets_count; i += 1) {
//       this.buckets[i] = new SU_HashMapBucket in this;
//     }

//     // 2.
//     // re-order the items from all the buckets
//     for (i = 0; i < this.buckets_count; i += 1) {
//       this.buckets[i].extractValues(all_items);
//     }

//     LogChannel('SU_HashMap', "allocateNewBuckets(), all_items.Size() = " + all_items.Size());

//     for (i = 0; i < all_items.Size(); i += 1) {
//       current_item = all_items[i];

//       this.insert(current_item.key, current_item.value);
//     }
//   }
// }

// struct SU_HashMapBucketItem {
//   var key: int;
//   var value: SU_HashMapValue;
// }

// class SU_HashMapBucket {
//   public var items: array<SU_HashMapBucketItem>;

//   /**
//    * return true if the insertion resulted in a new pushed item in the bucket
//    * return false if the insertion resulted in a replaced value
//    */
//   public function insert(value: SU_HashMapBucketItem): bool {
//     var i: int;

//     for (i = 0; i < this.items.Size(); i += 1) {
//       if (this.items[i].key == value.key) {
//         this.items[i] = value;

//         return false;
//       }
//     }

//     this.items.PushBack(value);

//     return true;
//   }

//   public function get(key: int): SU_HashMapBucketItem {
//     var i: int;

//     for (i = 0; i < this.items.Size(); i += 1) {
//       if (this.items[i].key == key) {
//         return this.items[i];
//       }
//     }

//     return NULL;
//   }

//   public function remove(key: int) {
//     var i: int;

//     for (i = 0; i < this.items.Size(); i += 1) {
//       if (this.items[i].key == key) {
//         this.items.Erase(i);
//       }
//     }
//   }

//   public function extractValues(out arr: array<SU_HashMapBucketItem>) {
//     var initial_size: int;
//     var new_size: int;
//     var i: int;

//     if (this.items.Size() <= 0) {
//       return;
//     }

//     initial_size = arr.Size();
//     new_size = arr.Grow(this.items.Size());

//     for (i = initial_size; i < new_size; i += 1) {
//       arr[i] = this.items[i - initial_size];
//     }

//     this.items.Clear();
//   }
// }

// abstract class SU_HashMapValue {
//   public function isSome(): bool {
//     return true;
//   }
// }

// class SU_HashMapValueNone extends SU_HashMapValue {
//   public function isSome(): bool {
//     return false;
//   }
// }

// class SU_HashMapValueString extends SU_HashMapValue {
//   public var value: string;
// }

// function hm_fromString(str: string): SU_HashMapValueString {
//   var value: SU_HashMapValueString;

//   value = new SU_HashMapValueString in thePlayer;
//   value.value = str;

//   return value;
// }

// class SU_HashMapValueInt extends SU_HashMapValue {
//   public var value: int;
// }

// function hm_fromInt(number: int): SU_HashMapValueInt {
//   var value: SU_HashMapValueInt;

//   value = new SU_HashMapValueInt in thePlayer;
//   value.value = number;

//   return value;
// }

// exec function suhashmap() {
//   var i: int;
//   var result: SU_HashMapValueString;
//   var map: SU_HashMap;

//   map = (new SU_HashMap in thePlayer).init();
//   // map.insert(234, hm_fromString("hello"));
//   // map.insert(346, hm_fromString("world!"));
//   // map.insert(23490, hm_fromString("foo"));
//   // map.insert(9045, hm_fromString("bar"));
//   // map.insert(9045, hm_fromString("foobar"));

//   for (i = 0; i < 100; i += 1) {
//     map.insert(i, hm_fromInt(i));
//   }

//   SULOG("map has " + map.buckets_count + " buckets");

//   for (i = 0; i < map.buckets.Size(); i += 1) {
//     SULOG("map bucket[" + i + "] has " + map.buckets[i].items.Size() + " items");
//   }

//   result = (SU_HashMapValueString)map.get(23490);

//   if (result) {
//     SULOG(result.value);
//   }

//   result = (SU_HashMapValueString)map.get(9045);

//   if (result) {
//     SULOG(result.value);
//   }
// }

// /**
//  * A hardcoded list of prime numbers, after a certain point it starts
//  * returning non prime numbers.
//  */
// function SU_getNextPrimeNumber(number: int): int {
//   if (number < 2) {
//     return 2;
//   }
//   else if (number < 73) {
//     return 73;
//   }
//   else if (number < 179) {
//     return 179;
//   }
//   else if (number < 283) {
//     return 283;
//   }
//   else if (number < 419) {
//     return 419;
//   }
//   else if (number < 547) {
//     return 547;
//   }
//   else if (number < 661) {
//     return 661;
//   }
//   else if (number < 811) {
//     return 811;
//   }
//   else if (number < 947) {
//     return 947;
//   }
//   else if (number < 1087) {
//     return 1087;
//   }
//   else if (number < 1229) {
//     return 1229;
//   }
//   else if (number < 1381) {
//     return 1381;
//   }
//   else if (number < 1523) {
//     return 1523;
//   }
//   else if (number < 1663) {
//     return 1663;
//   }
//   else if (number < 1823) {
//     return 1823;
//   }
//   else if (number < 1993) {
//     return 1993;
//   }
//   else if (number < 2131) {
//     return 2131;
//   }
//   else if (number < 2293) {
//     return 2293;
//   }
//   else if (number < 2437) {
//     return 2437;
//   }
//   else if (number < 2621) {
//     return 2621;
//   }
//   else if (number < 2749) {
//     return 2749;
//   }
//   else if (number < 2909) {
//     return 2909;
//   }
//   else if (number < 3083) {
//     return 3083;
//   }
//   else if (number < 3259) {
//     return 3259;
//   }
//   else if (number < 3433) {
//     return 3433;
//   }
//   else if (number < 3581) {
//     return 3581;
//   }
//   else if (number < 3733) {
//     return 3733;
//   }
//   else if (number < 3911) {
//     return 3911;
//   }
//   else if (number < 4073) {
//     return 4073;
//   }
//   else if (number < 4241) {
//     return 4241;
//   }
//   else if (number < 4421) {
//     return 4421;
//   }
//   else if (number < 4591) {
//     return 4591;
//   }
//   else if (number < 4759) {
//     return 4759;
//   }
//   else if (number < 4943) {
//     return 4943;
//   }
//   else if (number < 5099) {
//     return 5099;
//   }
//   else if (number < 5281) {
//     return 5281;
//   }
//   else if (number < 5449) {
//     return 5449;
//   }
//   else if (number < 5641) {
//     return 5641;
//   }
//   else if (number < 5801) {
//     return 5801;
//   }
//   else if (number < 5953) {
//     return 5953;
//   }
//   else if (number < 6143) {
//     return 6143;
//   }
//   else if (number < 6311) {
//     return 6311;
//   }
//   else if (number < 6481) {
//     return 6481;
//   }
//   else if (number < 6679) {
//     return 6679;
//   }
//   else if (number < 6841) {
//     return 6841;
//   }
//   else if (number < 7001) {
//     return 7001;
//   }
//   else if (number < 7211) {
//     return 7211;
//   }
//   else if (number < 7417) {
//     return 7417;
//   }
//   else if (number < 7573) {
//     return 7573;
//   }
//   else if (number < 7727) {
//     return 7727;
//   }

//   return number * 2 + 1;
// }