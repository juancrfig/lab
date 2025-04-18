function mergeSort(list) {

    // If the list has less than two elements, we can say that it's already sorted
    if (list.length < 2) {return list};

    // Logic for cases when the list has more than one element

    // Get the middle index
    const midIndex = Math.floor(list.length / 2);
    // Define the halves
    const leftHalf = list.slice(0, mid);
    const rightHalf = list.slice(mid);
    
    // Call the function over each half
    const sortedLeft = mergeSort(leftHalf);
    const sortedRight = mergeSort(rightHalf);

    return merge(sortedLeft, sortedRight);
}

function merge(left, right) {
    let result = [];
    let i = 0; // Pointer for left array
    let j = 0; // Pointer for right array
    while (i < left.length && j < right.length) {
        if (left[i] < right[j]) {
            result.push(left[i]);
            i++;
        } else {
            result.push(right[j]);
            j++;
        }
    }
    return result.concat(left.slice(i), right.slice(j));
}

const list = mergeSort([2, 1]);
console.log(list);