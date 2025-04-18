#include <stdio.h>

int main()
{
    /* Initializes a variable 'double'. 
    In other words, it will be able to receive very big numbers*/
    double nc;

    /* nc starts at 0. 
    Previous to run the body of the for loop, the program will ask the user for input. 
    If the input is different to EOF, the nc variable will be added 1 */
    for (nc = 0; getchar() != EOF; ++nc)
        ;
    /* When the foor loop ends, the program will print on screen 
    the number of char were typed*/
    printf("%.0f\n", nc);

    return 0;
}