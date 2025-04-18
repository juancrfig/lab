class HashMap {
    constructor(capacity = 16, loadFactor = 0.75) {
        this.capacity = capacity;
        this.loadFactor = loadFactor;
        // Create an array with 16 buckets filled with 'null'
        this.buckets = new Array(capacity).fill().map(() => []);
        this.size = 0;      // Track number of stored items
    }
    hash(key) {
        let hashCode = 0;
        const primeNumber = 31;
        for (let i = 0; i < key.length; i++) {
            // Apply modulo in each iteration to avoid integer overflow
            hashCode = (primeNumber * hashCode + key.charCodeAt(i)) % this.capacity;
        }
        return hashCode;
    }
    set(key, value) {
        const index = this.hash(key);
        // Access check
        if (index < 0 || index >= this.buckets.length) {
            throw new Error("Trying to access index out of bounds");
        }
        // Get the bucket at this index
        const bucket = this.buckets[index];
        // Check if key already exists in this bucket
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket[i][1] = value;
            }
        }
        // If key doesn't exist, add a new entry
        bucket.push([key, value]);
        this.size++;
        // Check if we need to resize
        if (this.size / this.capacity > this.loadFactor) {
            this.rehash();
        }
    }
    rehash() {
        this.capacity = this.capacity * 2;
        const newBuckets = new Array(this.capacity).fill().map(() => []);
        const oldBuckets = this.buckets;
        this.buckets = newBuckets;
        for (let i = 0; i < oldBuckets.length; i++) {
            const bucket = oldBuckets[i];
            for (let j = 0; j < bucket.length; j++) {
                this.set(bucket[j][0], bucket[j][1]);
            }
        } 
        delete oldBuckets;
    }
    get(key) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) return bucket[i][1];
        }
        return null;
    }
    has(key) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) return true;
        }
        return false;
    }
    remove(key) {
        const index = this.hash(key);
        const bucket = this.buckets[index];
        for (let i = 0; i < bucket.length; i++) {
            if (bucket[i][0] === key) {
                bucket.splice(i, 1);
                this.size--;
                return true;
            }
        }
        return false;
    }
    length() {
        return this.size;
    }
    clear() {
        this.buckets = new Array(this.capacity).fill().map(() => []);
        this.size = 0;
    }
    keys() {
        const allKeys = [];
        for (let i = 0; i < this.buckets.length; i++) {
            const bucket = this.buckets[i];
            for (let j = 0; j < bucket.length; j++) {
                allKeys.push(bucket[j][0]);
            }
        }
        return allKeys;
    }
    values() {
        const valueList = [];
        for (let i = 0; i < this.buckets.length; i++) {
            const bucket = this.buckets[i];
            for (let j = 0; j < bucket.length; j++) {
                valueList.push(bucket[j][1]);
            }
        }
        return valueList;
    }
    entries() {
        const allEntries = [];
        for (let i = 0; i < this.buckets.length; i++) {
            const bucket = this.buckets[i];
            for (let j = 0; j < bucket.length; j++) {
                // Push a copy of each key-pair value
                allEntries.push([bucket[j][0], bucket[j][1]]);
            }
        }
        return allEntries;
    }
}
