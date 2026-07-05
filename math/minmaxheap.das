options gen2
module minmaxheap public 

require daslib/typemacro_boost

[template_structure(StoredType)]
struct template public TMinMaxheap {
    heap: array<StoredType>
    size: int = 0
    provider: lambda<(typevalue: StoredType) -> int>

    def private const parent(index: int): int {
        return (index - 1) / 2
    }

    def private const left(index: int): int {
        return 2 * index + 1
    }

    def private const right(index: int): int {
        return 2 * index + 2
    }
    def public define_provider(var provider: lambda<(typevalue: StoredType) -> int> ) {
        self.provider <- provider
    }

    def private const get_level(index: int) {
        return (typeinfo sizeof(index) * 8 - 1) - clz(uint(index + 1))
    }

    def private push_down_min(cur: int) {
        let leftChild = left(cur)

        if(leftChild >= size) {
            return
        }

        let rightChild = leftChild + 1
        let leftGrandL = left(leftChild)
        let rightGrandL = leftGrandL + 1
        let leftGrandR = left(rightChild)
        let rightGrandR = leftGrandR + 1

        var min_index = leftChild
        var min_val = provider(heap[leftChild])

        let candidates = [rightChild, leftGrandL, rightGrandL, leftGrandR, rightGrandR]

        for(idx in candidates) {
            if (idx >= size) break

            let val = provider(heap[idx])
            if (val < min_val) {
                min_val = val
                min_index = idx
            }
        }

        let cur_val = provider(heap[cur])

        let is_grandchild = min_index >= leftGrandL

        if (is_grandchild) {
            if (min_val < cur_val) {
                var tmp = heap[min_index]
                heap[min_index] = heap[cur]
                heap[cur] = tmp

                let p_idx = parent(min_index)
                if (provider(heap[min_index]) > provider(heap[p_idx])) { 
                    tmp = heap[min_index]
                    heap[min_index] = heap[p_idx]
                    heap[p_idx] = tmp
                }
                push_down_min(min_index)
            }
        } else {
            if (min_val < cur_val) {      
                var tmp = heap[min_index]
                heap[min_index] = heap[cur]
                heap[cur] = tmp    
            }
        }
    }

    def private push_down_max(cur: int) {
        let leftChild = left(cur)

        if(leftChild >= size) {
            return
        }

        let rightChild = leftChild + 1
        let leftGrandL = left(leftChild)
        let rightGrandL = leftGrandL + 1
        let leftGrandR = left(rightChild)
        let rightGrandR = leftGrandR + 1

        var max_index = leftChild
        var max_val = provider(heap[leftChild])

        let candidates = [rightChild, leftGrandL, rightGrandL, leftGrandR, rightGrandR]

        for(idx in candidates) {
            if (idx >= size) break

            let val = provider(heap[idx])
            if (val > max_val) {
                max_val = val
                max_index = idx
            }
        }

        let cur_val = provider(heap[cur])

        let is_grandchild = max_index >= leftGrandL

        if (is_grandchild) {
            if (max_val > cur_val) {
                // Swap cur and max_index
                var tmp = heap[max_index]
                heap[max_index] = heap[cur]
                heap[cur] = tmp

                let p_idx = parent(max_index)
                if (provider(heap[max_index]) < provider(heap[p_idx])) { 
                    tmp = heap[max_index]
                    heap[max_index] = heap[p_idx]
                    heap[p_idx] = tmp
                }
                push_down_max(max_index)
            }
        } else {
            if (max_val > cur_val) {      
                var tmp = heap[max_index]
                heap[max_index] = heap[cur]
                heap[cur] = tmp    
            }
        }
    }

    def private push_down(index: int) {
        if(self.get_level(index) % 2 == 0) {
            push_down_min(index)
        } else {
            push_down_max(index)
        }
    }

    def private push_up_min(index: int) {
        var cur = index
        while(cur > 2) {
            let cur_parent = parent(cur)
            let grandparent = parent(cur_parent)

            if(provider(heap[cur]) < provider(heap[grandparent])) {
                var tmp = heap[cur]
                heap[cur] = heap[grandparent]
                heap[grandparent] = tmp
                cur = grandparent

            } else {
                break
            }
        }
    }

    def private push_up_max(index: int) {
        var cur = index
        while(cur > 2) {
            let cur_parent = parent(cur)
            let grandparent = parent(cur_parent)

            if(provider(heap[cur]) > provider(heap[grandparent])) {
                var tmp = heap[cur]
                heap[cur] = heap[grandparent]
                heap[grandparent] = tmp
                cur = grandparent
            } else {
                break
            }
        }
    }

    def private push_up(index: int) {
        let cur_parent = parent(index)
        let level = get_level(index)
        if(level % 2 == 0) {
            if(index > 0 && provider(heap[index]) > provider(heap[cur_parent])) {
                var tmp = heap[index]
                heap[index] = heap[parent(index)]
                heap[parent(index)] = tmp
                push_up_max(cur_parent)
            } else {
                push_up_min(index)
            }
        } else {
            if(index > 0 && provider(heap[index]) < provider(heap[cur_parent])) {

                var tmp = heap[index]
                heap[index] = heap[parent(index)]
                heap[parent(index)] = tmp
                push_up_min(cur_parent)
            } else {
                push_up_max(index)
            }
        }
    }

    def public find_min(): StoredType {
        return heap[0]
    }
    def public find_max(): StoredType {
        if (size == 1) {
            return heap[0]
        } elif (size == 2) {
            return heap[1]
        } else {
            if (provider(heap[left(0)]) > provider(heap[right(0)])) {
                return heap[left(0)]
            } else {
                return heap[right(0)]
            }
        }
    }

    def private remove_index(index: int) {
        heap[0] = heap[index]
        size--
        resize(heap, size)
        if (size > 0) {
            self.push_down(0)
        }
    }

    def public remove_min() {
        if (size > 0) {
            self.remove_index(size - 1)
        }
    }

    def public remove_max() {
        var index: int
        if (size == 1) {
            index = 0
        } elif (size == 2) {
            index = 1
        } else {
            if (provider(heap[left(0)]) > provider(heap[right(0)])) {
                index = left(0)
            } else {
                index = right(0)
            }
        }
        heap[index] = heap[size-1]
        size--
        resize(heap, size)
        if(size > 0) {
            push_down(index)
        }
    }

    def public insert(item: StoredType) {
        assert(provider != null)
        resize(heap, size+1)
        heap[size] = item
        push_up(size)
        size++
    }


    def public display(index: int = 0, indent: int = 0) {
        if(index < size) {
            let leftChild = left(index)
            if(leftChild + 1 < size) {
                display(leftChild + 1, indent + 6)
            }
            
            for(i in range(indent)) {
                print(" ")
            }
            
            print("{provider(heap[index])}")
            print("\n")
            
            if(leftChild < size) {
                display(leftChild, indent + 6)
            }
        }
    }


    def public is_minmax_heap(): bool {
        var index = size - 1
        
        while(index > 0) {
            let index_parent = parent(index)
            
            if(get_level(index) % 2 == 0) {
                if(provider(heap[index]) <= provider(heap[index_parent])) {
                    pass
                } else {
                    return false
                }
                
                if(index > 2) {
                    let grandparent = parent(index_parent)
                    if(provider(heap[index]) >= provider(heap[grandparent])) {
                        pass
                    } else {
                        return false
                    }
                }
            } else {
                if(provider(heap[index]) >= provider(heap[index_parent])) {
                    pass
                } else {
                    return false
                }
                
                if(index > 2) {
                    let grandparent = parent(index_parent)
                    if(provider(heap[index]) <= provider(heap[grandparent])) {
                        pass
                    } else {
                        return false
                    }
                }
            }
            index--
        }
        return true
    }

    def build_from_arr(a: array<StoredType>, var provider: lambda<(typevalue: StoredType) -> int> ): TMinMaxheap {
        size = length(a)
        heap := a
        self.provider <- provider
        var i = size / 2 - 1
        while(i >= 0) {
            self.push_down(i)
            i--
        }
        return <- self
    }
}
