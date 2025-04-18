#include <stdio.h> 

/* Print Fahrenheit-Celsius table
    for fahr = 0, 20, ..., 300 */
int main()
{
    float fahr, celsius, lower, upper, step;

    lower = 0;     // Lower limit of temperature scale
    upper = 300;   // Upper limit
    step = 20;     // Step size

    fahr = lower;
    printf(" C      F \n");
    printf("-------------\n");
    while (fahr <= upper) {
        celsius = 5 * (fahr-32) / 9;
        printf("%3.0f | %6.1f\n", fahr, celsius);
        fahr = fahr + step;
    }
}
