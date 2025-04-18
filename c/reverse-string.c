#include <stdio.h>

#define MAX_SIZE 9  // Set a limit for array size

int c, i, j;
char array[MAX_SIZE];

int main() {

    i = 0;
    while (((c = getchar()) != EOF) && i < MAX_SIZE + 1)
    {
        if (c == '\n')
        {
            array[i] = '\0';
            for (j = MAX_SIZE - 1; j >= 0; --j)
                printf("%c", array[j]);
            printf("\n");
            return 0;
        }
        array[i] = c;
        ++i;
    }
}
