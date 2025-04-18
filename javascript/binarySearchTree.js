class Node {
    constructor(data) {
        this.data = data;
        this.left = null;
        this.right = null;
    }
}
class Tree {
    constructor(array) {
        this.root = this.buildTree(array);
    }
    buildTree(array) {
        // Sort the array and remove duplicates
        const data = [...new Set(array)].sort((a, b) => a - b);
        // Helper function to build tree recursively
        function buildTreeRecursively(arr, start, end) {
            // Base case: If start > end, return null
            if (start > end) {
                return null;
            }
            // Find the middle element
            const middleElement = Math.floor((start + end) / 2);
            // Create a new node with the middle element
            const node = new Node(arr[middleElement]);
            // Recursively build left subtree
            node.left = buildTreeRecursively(arr, start, middleElement - 1);
            // Recursively build right subtree
            node.right = buildTreeRecursively(arr, middleElement + 1, end);
            // Return the node
            return node;
        }
        return buildTreeRecursively(data, 0, data.length - 1);
    }
    insert(value) {
        // Check if value already exists
        if (this.find(value)) {
            console.log("This element already exists");
            return;
        }

        const newNode = new Node(value);

        // If tree is empty, set the new node as the root
        if (!this.root) {
            this.root = newNode;
            return;
        }

        let currentNode = this.root;

        while (true) {
            if (value > currentNode.data) {
                if (!currentNode.right) {
                    currentNode.right = newNode;
                    return;
                }
                currentNode = currentNode.right;
            } else if (value < currentNode.data) {
                if (!currentNode.left) {
                    currentNode.left = newNode;
                    return;
                }
                currentNode = currentNode.left;
            } else {
                console.log("This element already exists");
                return;
            }
        }
    }
    deleteItem(value) {
        // If tree is empty, exit process
        if (!this.root) {
            return;
        }
        
        let currentNode = this.root;
        let prevNode, rightNode, leftNode;

        while (currentNode) {
            if (value > currentNode.data) {
                prevNode = currentNode;
                currentNode = currentNode.right;
            } else if (value < currentNode.right) {
                prevNode = currentNode;
                currentNode = currentNode.left;
            } else if (value === currentNode.data) {
                // Has it no children?
                if (!currentNode.left && !currentNode.right) {
                    if (prevNode.left.data === value) {
                        prevNode.left = null;
                    } else if (prevNode.right.data === value) {
                        prevNode.right = null;
                    }
                }
                // Has it a single child?
                if ( (!currentNode.left && currentNode.right) || (!currentNode.right && currentNode.left) ) {
                    if (currentNode.right) {
                        currentNode = currentNode.right;
                    } else if (currentNode.left) {
                        currentNode = currentNode.left;
                    }
                }
                // Has it two children?
                if (currentNode.left && currentNode.right) {
                // Go to the right node
                rightNode = currentNode.right;
                // Take its left value
                leftNode = rightNode.left;
                // Replace the target value to remove with this last value
                currentNode.data = leftNode.data;
                }
            }
        }
    }
    find(value) {
        // Check if tree is empty
        if (!this.root) {
            return;
        }
        let currentNode = this.root;
        while (currentNode) {
            if (value < currentNode.data) {
                currentNode = currentNode.left;
            } else if (value > currentNode.data) {
                currentNode = currentNode.right;
            } else if (value === currentNode.data) {
                return currentNode;
            }
        }
    }
    levelOrder(callBack) {
        if (!callBack) {
            throw new Error("Callback is required");
        }
        if (!this.root) {
            throw new Error("Tree is empty");
        }
        let currentNode;
        const nodesInLevel = [this.root];
        while (nodesInLevel.length > 0 ) {
            currentNode = nodesInLevel.shift();
            callBack(currentNode);
            if (currentNode.left) { 
                nodesInLevel.push(currentNode.left);  
            }
            if (currentNode.right) {
                nodesInLevel.push(currentNode.right);
            }
        }
    }
    // I have to understand next functions
    inOrder(callBack) {
        if (typeof callBack !== 'function') {
            throw new Error("A callback is required");
        }
        // Helper function
        function traverse(node) {
            // Base case
            if (node === null) return;
            traverse(node.left);
            callBack(node);
            traverse(node.right); 
        }
        traverse(this.root);
    }
    preOrder(callBack) {
        if (typeof callBack !== 'function') {
            throw new Error("A callback is required");
        }
        // Helper function
        function traverse(node) {
            // Base case
            if (node === null) return;
            callBack(node);
            traverse(node.left);
            traverse(node.right);
        }
        traverse(this.root);
    }
    postOrder(callBack) {
        if (typeof callBack !== 'function') {
            throw new Error("A callback is required");
        }
        function traverse(node) {
            if (node === null) return;
            traverse(node.left);
            traverse(node.right);
            callBack(node);
        }
        traverse(this.root);
    }
    height(value) {
        const node = this.find(value);
        if (!node) return null;

        const computeHeight = (current) => {
            if (current === null) return -1
            const leftHeight = computeHeight(current.left);
            const rightHeight = computeHeight(current.right);
            return 1 + Math.max(leftHeight, rightHeight);
        };
        return computeHeight(node);
    }
    depth(value) {
        let current = this.root;
        let depth = 0;
        while (current !== null) {
            if (value === current.data) return depth;
            if (value < current.data) current = current.left;
            else current = current.right;
                depth++;
        }
        return null;
    }

    isBalanced() {
        const check = (node) => {
            if (node === null) return true;
            
            const leftHeight = this.#computeHeight(node.left);
            const rightHeight = this.#computeHeight(node.right);
            const balanced = Math.abs(leftHeight - rightHeight) <= 1;

            return balanced && check(node.left) && check(node.right);
        };
        return check(this.root);
    }
    #computeHeight(node) {
        if (node === null) return -1;
        const left = this.#computeHeight(node.left);
        const right = this.#computeHeight(node.right);
        return 1 + Math.max(left, right);
    }
    rebalance() {
        const values = [];

        const inOrderTraverse = (node) => {
            if (node === null) return;
            inOrderTraverse(node.left);
            values.push(node.data);
            inOrderTraverse(node.right);
        };
        
        inOrderTraverse(this.root);
        this.root = this.buildTree(values);
    }
}
