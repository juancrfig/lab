class LinkedList {
    constructor() {
        this._head = null; // Avoid naming conflic with head() method
    }

    // Helper method for getting the list's tail node and size
    _traverseList() {
        if (!this._head) return [null, 0];

        let currentNode = this._head;
        let numberOfNodes = 1; // Start with 1 for the head node

        while(currentNode.nextNode) {
            currentNode = currentNode.nextNode;
            numberOfNodes++;
        }
        // Return last node and number of nodes found
        return [currentNode, numberOfNodes];
    }    

    append(value) {
        if (!this._head) {
            this._head = new Node(value);
        } else {
            const lastNode = this._traverseList()[0];
            lastNode.nextNode = new Node(value);
        }
    }

    prepend(value) {
        const newNode = new Node(value);

        if (!this._head) {
            this._head = newNode;
        } else {
            newNode.nextNode = this._head;
            this._head = newNode;
        }
    }

    size() {
        return this._traverseList()[1];
    }

    head() {
        return this.head;
    }    

    tail() {
        return this._traverseList()[0];
    }    

    at(index) {
        if (index < 0 || !this._head) return null;

        let currentNode = this._head;
        let counter = 0;

        while (counter <= index && currentNode) {
            currentNode = currentNode.nextNode;
            counter++;
        }    
        return currentNode;
    }    

    pop() {
        if (!this._head) return null;

        // If there's only one node
        if (!this._head.nextNode) {
            const poppedNode = this._head;
            this._head = null;
            return poppedNode;
        }

        let currentNode = this._head;
        let previousNode = null;

        // Traverse to the last node
        while (currentNode.nextNode) {
            previousNode = currentNode;
            currentNode = currentNode.nextNode;
        }

        // Remove the last node
        previousNode.nextNode = null;
        return currentNode;
    }    

    contains(value) {
        if (!this._head) return false;

        let currentNode = this._head;

        while (currentNode) {
            if (currentNode.value === value) {
                return true;
            }
            currentNode = currentNode.nextNode;
        }    

        return false;
    }    

    find(value) {
        if (!this._head) return null;

        let currentNode = this._head;
        let index = 0;

        if (this.contains(value)) {
            while (currentNode) {
                if (currentNode.value === value) {
                    return index;
                }
                currentNode = currentNode.nextNode;
                index++;
            }
            return null;
    }    

    toString() {
        if (!this._head) return "null";

        let result = "";
        let currentNode = this._head;

        while (currentNode) {
            result += `( ${currentNode.value} ) -> `;
            currentNode = currentNode.nextNode;
        }

        result += "null";
        return result;
    }
}

/* Given that we don't always know the next node's address,
we initialize the nextNode's address to null by default.*/
class Node {
    constructor(value) {
        this.value = value || null;
        this.nextNode = null;
    }
}

