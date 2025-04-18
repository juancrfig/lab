function fibo(n) {

    if (n === 0) {
        return [];
    }
    if (n === 1) {
        return [0];
    }
    if (n == 2) {
        return [0, 1];
    }

    const prev = fibo(n - 1);
    const lastNumber = prev[prev.length - 1] + prev[prev.length - 2];
    return [...prev, lastNumber];
}

const result = fibo(8);
console.log(result)
