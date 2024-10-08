#include <stdio.h>

int main()
{
    for (char c = 'a'; c <= 'z'; c++)
    {
        printf("%c", c);
        if ((c - 'a' + 1) % 13 == 0)
        {
            printf("\n");
        }
    }
    return 0;
}
