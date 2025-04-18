#include <stdio.h>

int main()
{   
    // int c;
    // int nl = 0, tb = 0, bs = 0;
    // while ((c = getchar()) != EOF) {
    //     if (c == '\n')
    //         ++nl;
    //     if (c == '\t')
    //         ++tb;
    //     if (c == ' ')
    //         ++bs;
    // }

    // printf("Newlines: %d\n", nl);
    // printf("Tabs: %d\n", tb);
    // printf("Spaces: %d\n", bs);


    // int c;
    // int blanks = 0, characters = 0;
    // while ((c = getchar()) != EOF) 
    // {
    //     if (c == ' ')
    //         ++blanks;
    //     if (c != ' ')
    //         ++characters; 

    //     if (blanks > 0 && characters < 1)
    //     {
    //         printf(" \n");
    //     }
    //     else
    //     {
    //         printf("%c\n", c);
    //     }
    // }

    int c;
    while ((c = getchar()) != EOF) 
    {
        if (c == '\t')
            printf("\\t\n");
        if (c == '\b')
            printf("\\b\n");
        else
            printf("%c", c);
    }

    return 0;
}