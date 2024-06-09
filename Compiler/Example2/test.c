#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* findCharIdx(char* log_str) {
    char* tmp;
    for (tmp = log_str; *tmp != '\0'; tmp = tmp + 1) {
        if (*tmp == '*' || *tmp == '/' || *tmp == '^') { return tmp; }
    }
    return tmp;
}

int power(int n, int m) {
    int result = 1;
    int i;
    for (i = 0; i < m; ++i) { result *= n; }
    return result;
}

int calculate_num1_num2(const char* str, char op) {
    char num1_str[10];  // 假設數字的最大長度為10
    char num2_str[10];
    int num1, num2;

    sscanf(str, "%[^*+-/^]%c%[^*+-/^]", num1_str, &op, num2_str);
    // printf("num1: %s\n", num1_str);
    // printf("op: %c\n", op);
    // printf("num2: %s\n", num2_str);
    num1 = atoi(num1_str);
    num2 = atoi(num2_str);

    int result;

    switch (op) {
        case '*':
            result = num1 * num2;
            break;
        case '/':
            result = num1 / num2;
            break;
        case '^':
            result = power(num1, num2);
            break;
        default:
            // printf("Invalid operator!\n");
            return num1;
    }

    return result;
}

char* extractSubstring(const char* str, char start, char end) {
    const char* startPtr = strchr(str, start);
    const char* endPtr = strchr(str, end);

    if (startPtr == NULL || endPtr == NULL || endPtr < startPtr) {
        printf("Invalid substring range!\n");
        return NULL;
    }

    size_t startIndex = startPtr - str + 1;
    size_t endIndex = endPtr - str;
    size_t length = endIndex - startIndex;

    char* result = (char*)malloc((length + 1) * sizeof(char));

    strncpy(result, str + startIndex, length);
    result[length] = '\0';

    return result;
}

char* combineStrings(const char* str1, const char* str2) {
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    size_t totalLen = len1 + len2;

    char* result = (char*)malloc((totalLen + 1) * sizeof(char));

    strcpy(result, str1);
    strcat(result, str2);

    return result;
}

char* intTostring(int num) {
    // 計算數字的位數
    int temp = num;
    int digits = 0;
    while (temp != 0) {
        temp /= 10;
        digits++;
    }

    // 分配記憶體儲存結果字串
    char* result = (char*)malloc((digits + 1) * sizeof(char));

    if (result == NULL) {
        printf("Memory allocation failed!\n");
        return NULL;
    }

    // 數字轉換為字串
    sprintf(result, "%d", num);

    return result;
}

int countOP(char* str, char op) {
    char* tmpPtr = str;
    int num = 0;
    for (; tmpPtr != '\0'; ++tmpPtr) {
        if (*tmpPtr == op) { num++; }
    }
    return num;
}

/* 優先處理指數 */
char* evaluateExp(char* subStr) {
    char* tmp = "";
    tmp = combineStrings(tmp, subStr);
    printf("com: %s\n", tmp);

    char* ptr = tmp;
    char* resultStr = "";
    char* preop;
    char* proop;

    char* op = tmp;
    char* expStr = "";
    for (; op < (tmp + strlen(tmp) + 1); ++op) {
        char* num1 = "";
        char* num2 = "";
        printf("> op:  %c\n", *op);
        if (*op == '^') {
            for (preop = op - 1; preop != tmp - 1 && *preop != '*' && *preop != '/'; --preop) {
                char opTmp[2] = {*preop, '\0'};
                num1 = combineStrings(opTmp, num1);
            }
            for (proop = op + 1; proop != (tmp + strlen(tmp)) && *proop != '*' && *proop != '/';
                 ++proop) {
                char opTmp[2] = {*proop, '\0'};
                num2 = combineStrings(num2, opTmp);
            }

            if (preop == tmp - 1) {
                /* pass */
            } else {
                char opTmp[2] = {*preop, '\0'};
                resultStr = combineStrings(resultStr, opTmp);
            }
            /*  combine exp into result */
            // printf("%s %s", num1, num2);
            expStr = intTostring(power(atoi(num1), atoi(num2)));
            printf("exp: %s\n", expStr);
            resultStr = combineStrings(resultStr, expStr);
            op = proop;

            // printf("Num2  %s\n", num2);

        } else if (*op == '*' || *op == '/') {
            for (preop = op - 1; preop != tmp - 1 && *preop != '*' && *preop != '/'; --preop) {
                char opTmp[2] = {*preop, '\0'};
                num1 = combineStrings(opTmp, num1);
            }

            // for (proop = op + 1; *op != '\0' && *proop != '*' && *proop != '/'; ++proop) {
            //     char opTmp[2] = {*proop, '\0'};
            //     num2 = combineStrings(num2, opTmp);
            // }

            if (preop == tmp - 1) {
                /* pass */
            } else {
                char opTmp[2] = {*preop, '\0'};
                resultStr = combineStrings(resultStr, opTmp);
            }
            resultStr = combineStrings(resultStr, num1);
            // resultStr = combineStrings(resultStr, num2);
            printf("-RESULTSTR = %s\n", resultStr);
        } else if (*op == '\0') {
            for (preop = op - 1;
                 preop != tmp - 1 && *preop != '*' && *preop != '/' && *preop != '^'; --preop) {
                char opTmp[2] = {*preop, '\0'};
                num1 = combineStrings(opTmp, num1);
            }

            if (*preop == '*' || *preop == '/') {
                if (preop == tmp - 1) {
                    /* pass */
                } else {
                    char opTmp[2] = {*preop, '\0'};
                    num1 = combineStrings(opTmp, num1);
                }

                resultStr = combineStrings(resultStr, num1);
            } else {
                resultStr = combineStrings(resultStr, num1);
                /* pass */
            }
            break;
        }
    }
    printf("RESULTSTR = %s\n", resultStr);

    return resultStr;
}

char* combineToNewLOG(char* log_str) {
    char* subStr;
    char* new_log;
    char* base;
    int result = 0;  // 括號裡的結果
    char* op;
    printf("%s\n", log_str);
    subStr = extractSubstring(log_str, '(', ')');
    printf("extractSubstring : %s\n", subStr);

    subStr = evaluateExp(subStr);
    /**/
    char* preop = NULL;
    op = findCharIdx(subStr);

    char* tmp = subStr;
    // if (*op == "\0") { printf("op : %c\n", op[0]); }

    do {
        // pick first num
        char num[10];
        char* num_ptr = num;
        for (; tmp != op; ++tmp) {
            *num_ptr = *tmp;
            num_ptr++;
        }
        *num_ptr = '\0';

        tmp += 1;
        int num2 = atoi(num);

        if (preop == NULL) {
            result += num2;
        } else {
            switch (*preop) {
                case '*':
                    result *= num2;
                    break;
                case '/':
                    result /= num2;
                    break;
                case '^':
                    result = pow(result, num2);
                    break;
                default:
                    printf("inValid");
                    break;
            }
        }
        preop = op;
        if (*op == '\0') break;
        op = findCharIdx(tmp);
    } while (1);

    /**/

    // result = calculate_num1_num2(subStr, op);
    // printf("result : %d\n", result);

    base = extractSubstring(log_str, 'g', '(');
    // printf("base : %s\n", base);

    new_log = combineStrings("log", base);
    new_log = combineStrings(new_log, "(");
    new_log = combineStrings(new_log, intTostring(result));
    new_log = combineStrings(new_log, ")");
    return new_log;
}

char* compute_log(char* log_str) {
    char str[100000];
    double base = atoi(extractSubstring(log_str, 'g', '('));
    double x = atoi(extractSubstring(log_str, '(', ')'));
    printf("base %lf\n", base);
    printf("x %lf\n", x);

    sprintf(str, "%lf", log(x) / log(base));
    return str;
}

int main() {
    // char* log_str = "log3(3^2)";
    // char* new_log = combineToNewLOG(log_str);

    // printf("ANS : %s\n", new_log);

    // printf("%s\n", compute_log(new_log));

    char* ptr;
    double tmp;
    tmp = strtod("12.00000", &ptr);
    printf("%lf", tmp);
    return 0;
}
