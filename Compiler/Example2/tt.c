#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char* str = "12345";
    printf("%c", str + strlen(str));

    return 0;
}