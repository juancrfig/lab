def binary_search(sorted_array, item):
    
    # This first two variables keep track of which part of the list we'll search in
    low = 0                             
    high = len(sorted_array) - 1
    
    while low <= high:
        mid = (low + high) // 2
        guess = sorted_array[mid]
        if guess == item:
            return mid
        if guess > item:
            high = mid - 1
        else:
            low = mid + 1
    return None
    
list_of_elements = [x for x in range(1, 101)]

print(binary_search(list_of_elements, 2))