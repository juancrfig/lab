#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// The & is the address operator
// The * is the dereference operator
// %p represents a pointer

int n = 50;
int *p = &n;  // Creates a pointer with the address of n

// malloc allows you to take beforehand space in memory
// free does the opposite


int main (void) 
{
    char *s = get_string("s: ");

    char *t = malloc(strlen(s) + 1);

    for (int i = 0, n = strlen(s); i <= n, i++)
    {
        t[i] = s[i];
    }

    t[0] = toupper(t[0]);

    free(t);
}