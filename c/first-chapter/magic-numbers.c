#include <stdio.h>

const int LOWER = 0;
const int UPPER = 300;
const int STEP = 20;

int main()
{
    int fahr;

    for (fahr = LOWER; fahr <= UPPER; fahr = fahr + STEP)
        printf("%3d %6.1f\n", fahr, (5.0/9.0) * (fahr-32));
}