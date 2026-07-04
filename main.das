require minmaxheap public



struct BooleanItem {
    sort_by: int

    value: bool
}

typedef BoolMinMaxHeap = $TMinMaxheap<BooleanItem>

[export]
def main() {
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
    
    // Initialization is as such, provided you have an array and a key to sort by (as long as your lambda returns an integer.) Preferable to the second option
    var bool_heap_test_1 = new default<BoolMinMaxHeap>.build_from_arr(bool_item_arr,
        @(typevalue: BooleanItem) {
        return typevalue.sort_by
    })
    
    bool_heap_test_1.display()
    print("AFter removing min and max:\n")
    bool_heap_test_1.remove_min()
    bool_heap_test_1.remove_max()
    bool_heap_test_1.display()


    // Is the same as above (with inferior performance)
    var bool_heap_test_2 = new default<BoolMinMaxHeap>
    bool_heap_test_2.define_provider(@(typevalue: BooleanItem) {
        return typevalue.sort_by
    })
    bool_heap_test_2.insert(BooleanItem(sort_by = 5,  value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 65, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 80, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 25, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 37, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 8,  value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 15, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 57, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 36, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 45, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 59, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 20, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 14, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 32, value = true))
    bool_heap_test_2.insert(BooleanItem(sort_by = 18, value = true))
}