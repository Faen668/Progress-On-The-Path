

/**
 * The class can be extended and the methods overridden for
 * custom comparison logic in the `isGreaterThan method.
 */
class SU_ArraySorterData {
  var value: float;

  /**
   * returns whether "this" is greater than "other"
   */
  public function isGreaterThan(other: SU_ArraySorterData): bool {
    return this.value > other.value;
  }
}

function SU_sortArray(arr: array<SU_ArraySorterData>): array<SU_ArraySorterData> {
  var output: array<SU_ArraySorterData>;
  var current: SU_ArraySorterData;
  var other: SU_ArraySorterData;
  var last: SU_ArraySorterData;
  var was_inserted: bool;
  var i: int;
  var k: int;

  if (arr.Size() <= 1) {
    return arr;
  }

  current = arr[0];
  output.PushBack(current);
  last = current;

  for (i = 1; i < arr.Size(); i += 1) {
    current = arr[i];
    was_inserted = false;

    // directly compare the last in the output
    // as it could potentially save us from iterating
    // over the whole array.
    if (!last.isGreaterThan(current)) {
      output.PushBack(current);
      last = current;

      continue;
    }

    for (k = 0; k < output.Size(); k += 1) {
      other = output[k];

      if (other.isGreaterThan(current)) {
        output.Insert(k, current);
        was_inserted = true;

        break;
      }
    }

    if (!was_inserted) {
      output.PushBack(current);

      last = current;
    }
  }

  return output;
}
