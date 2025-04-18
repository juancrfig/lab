#include <stdio.h>

int main() {
    int c;
    int space = 0;  

    while ((c = getchar()) != EOF) {
        if (c == ' ' || c == '\t' || c == '\n')
        {
            if (space == 0) 
            {
                printf("\n");
                space = 1;
            }
        } 
        else 
        {
            space = 0;
            printf("%c", c);
        }
    }
    
    if (space == 0)
        printf("\n");
        
    return 0;
}