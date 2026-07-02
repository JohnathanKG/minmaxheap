module maxheap public 

require daslib/typemacro_boost

[template_structure(StoredType)]
struct template public TMaxheap {
    heap: array<StoredType>
    size: int = 0
    provider: lambda<(typevalue: StoredType) -> int>
    def private parent(index: int): int {
        return (index - 1) / 2
    }

    def private left(index: int): int {
        return 2 * index + 1
    }

    def private right(index: int): int {
        return 2 * index + 2
    }

    def private swap(fpos, spos: int) {
        var tmp = heap[fpos]
        heap[fpos] = heap[spos]
        heap[spos] = tmp
    }

    def public extract_max(): StoredType {
        var max = heap[0]
        heap[0] = heap[size-1]
        size--
        max_heapify(0)
        return <- max
    }

    def remove_index(index: int) {
        var idx = heap[index]
        heap[index] = heap[size-1]
        size--
        max_heapify(index)
    }

    def remove(predicate: lambda<(item: StoredType) -> bool>) {
        for(i in range(size)) {
            if(predicate(heap[i])) {
                remove_index(i)
            }
        }
    }

    def insert(var item: StoredType) {
        assert(provider != null)
        resize(heap, size+1)
        heap[size] <- item
        var current = size
        while(provider(heap[current]) > provider(heap[parent(current)])) {
            swap(current, parent(current))
            current = parent(current)
        }
        size++
    }

    def public define_provider(var provider: lambda<(typevalue: StoredType) -> int> ) {
        self.provider <- provider
    }

    def private max_heapify(index: int) {
        if (size <= 0) {
            panic("Cannot extract from an empty heap") 
        }

        let l = left(index)
        let r = right(index)
        var largest: int = index
        
        if(l < size && provider(heap[l]) > provider(heap[largest])) {
            largest = l
        }
    
        if(r < size && provider(heap[r]) > provider(heap[largest])) {
            largest = r
        }
        if(largest != index) {
            self.swap(index, largest)
            max_heapify(largest)
        }
    }

    def build_from_arr(a: array<StoredType>, var provider: lambda<(typevalue: StoredType) -> int> ): TMaxheap {
        size = length(a)
        heap := a
        self.provider <- provider
        var i = size / 2 - 1
        while(i >= 0) {
            self.max_heapify(i)
            i--
        }
        return <- self
    }


    def public print() {
        for(i in range(0, size / 2)) {
            print("Parent node: {heap[i]}  ")
            if(left(i) < size) {
                print("Left child node: {heap[left(i)]} ")
            }
            if(right(i) < size) {
                print("Right child node: {heap[right(i)]}")
            }
            print("\n")
        }
    }
}
