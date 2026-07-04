options gen2
require dastest/testing_boost public
require ../minmaxheap.das public

struct BooleanItem {
    sort_by: int

    value: bool
}
typedef BoolMinMaxHeap = $TMinMaxheap<BooleanItem>


var bool_item_arr = [BooleanItem(sort_by = 5,  value = true),
    BooleanItem(sort_by = 65, value = true),
    BooleanItem(sort_by = 80, value = true),
    BooleanItem(sort_by = 25, value = true),
    BooleanItem(sort_by = 37, value = true),
    BooleanItem(sort_by = 8,  value = true),
    BooleanItem(sort_by = 15, value = true),
    BooleanItem(sort_by = 57, value = true),
    BooleanItem(sort_by = 36, value = true),
    BooleanItem(sort_by = 45, value = true),
    BooleanItem(sort_by = 59, value = true),
    BooleanItem(sort_by = 20, value = true),
    BooleanItem(sort_by = 14, value = true),
    BooleanItem(sort_by = 32, value = true),
    BooleanItem(sort_by = 18, value = true)]


var bool_heap_test = new default<BoolMinMaxHeap>.build_from_arr(bool_item_arr,
    @(typevalue: BooleanItem) {
    return typevalue.sort_by
})

[test]
def test_valid_heap(t : T?) {
    t |> success(bool_heap_test.is_minmax_heap(), "heap is automatically minmax-sorted")
}

[test]
def test_invalid_heap(t : T?) {
    bool_heap_test.heap[2].sort_by = 1
    t |> success(!bool_heap_test.is_minmax_heap(), "fudged heap is detected as invalid")
}