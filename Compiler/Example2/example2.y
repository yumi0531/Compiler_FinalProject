%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h> 
    #include <math.h>
    int addAnsArray[20][20];
    int LOGMAP[20] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
    


    /* 找op的index */
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

    /*  */
    int calculate_num1_num2(const char* str, char op) {
        char num1_str[10];  // 假設數字的最大長度為10
        char num2_str[10];
        int num1, num2;

        sscanf(str, "%[^*+-/^]%c%[^*+-/^]", num1_str, &op, num2_str);
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

    /* 截取括號中的substring */
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



    /* 合併字串 */
    char* combineStrings(const char* str1, const char* str2) {
        size_t len1 = strlen(str1);
        size_t len2 = strlen(str2);
        size_t totalLen = len1 + len2;

        char* result = (char*)malloc((totalLen + 1) * sizeof(char));

        strcpy(result, str1);
        strcat(result, str2);

        return result;
    }

    /* int 轉 string*/
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

        // 數字轉換為字串
        sprintf(result, "%d", num);

        return result;
    }

    
    /* 優先處理指數 */
    char* evaluateExp(char* subStr) {
        char* tmp = "";
        tmp = combineStrings(tmp, subStr);
        // printf("com: %s\n", tmp);

        char* ptr = tmp;
        char* resultStr = "";
        char* preop;
        char* proop;

        char* op = tmp;
        char* expStr = "";
        for (; op < (tmp + strlen(tmp) + 1); ++op) {
            char* num1 = "";
            char* num2 = "";
            // printf("> op:  %c\n", *op);
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
                // printf("exp: %s\n", expStr);
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
                // printf("-RESULTSTR = %s\n", resultStr);
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
                    /* pass */
                    resultStr = combineStrings(resultStr, num1);
                }
                break;
            }
        }
        printf("RESULTSTR = %s\n", resultStr);

        return resultStr;
    }

    char* combineToNewLOG(char* log_str) {
        // printf("> Old log: %s\n", log_str);

        char* subStr;
        char* new_log;
        char* base;
        int result = 0;  // 括號裡的結果
        char* op;
        // printf("%s\n", log_str);
        subStr = extractSubstring(log_str, '(', ')');
        // printf("extractSubstring : %s\n", subStr);

        subStr = evaluateExp(subStr);
        /**/
        char* preop = NULL;
        op = findCharIdx(subStr);

        char* tmp = subStr;
        // if (op == "\0") { printf("op : %c\n", op[0]); }

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
        // printf("> New log: %s\n", new_log);
        return new_log;
    }

    void* findNum(char* logNewStr, int* base, int* number){
        char num_str[10]; 
        char base_str[10]; 
        
        char* left_bracket = strchr(logNewStr, '(');
        char* right_bracket = strchr(logNewStr, ')');
        char* end_bracket = strchr(logNewStr, 'g');

        if (left_bracket != NULL && right_bracket != NULL && right_bracket > left_bracket) {
            strncpy(num_str, left_bracket + 1, right_bracket - left_bracket - 1);
            num_str[right_bracket - left_bracket - 1] = '\0';
            *number = atoi(num_str);
            
            //printf("Number: %d\n", *number);
        } 

        if (end_bracket != NULL && left_bracket != NULL && left_bracket > end_bracket) {
            strncpy(base_str, end_bracket + 1, left_bracket - end_bracket - 1);
            num_str[left_bracket - end_bracket - 1] = '\0';
            *base = atoi(base_str);
            
            //printf("Base: %d\n", base);
        } 
        
    }

    void doubleAddAns(int base, int number1, int number2){
        addAnsArray[base][0] = number1;
        int i;
        for (i = 1; i < 20; i++) {
            if (addAnsArray[base][i] == 0) {
                addAnsArray[base][i] = number2;
                break;
            }
        }
        int ans = addAnsArray[base][i-1]*addAnsArray[base][i];
        addAnsArray[base][i]=ans;
        /*
        for (j = i; j <= 10; j++){
            if(addAnsArray[base][j] != 0){
                ans *= addAnsArray[base][j];
                addAnsArray[base][j+1] = ans;
            }
        }
        */
        printf("add combine: log%d(%d)\n", base, ans);
    }

    void doubleSubAns(int base, int number1, int number2){
        addAnsArray[base][0] = number1;
        int i;
        for (i = 1; i < 20; i++) {
            if (addAnsArray[base][i] == 0) {
                addAnsArray[base][i] = number2;
                break;
            }
        }
        int ans = addAnsArray[base][i-1]/addAnsArray[base][i];
        addAnsArray[base][i]=ans;
        /*
        for (i = 1; i <= 10; i++){
            if(addAnsArray[base][i] != 0){
                //printf("%d", addAnsArray[base][i]);
                ans /= addAnsArray[base][i];
                addAnsArray[base][i+1] = ans;
            }
        }
        */
        printf("sub conmine: log%d(%d)\n", base, ans);
    }

    
    char* compute_log(char* log_str) {
        char str[100000];
        double base = atoi(extractSubstring(log_str, 'g', '('));
        double x = atoi(extractSubstring(log_str, '(', ')'));
        if(base == 0 || x == 0){
            printf("合併結果不可為0!!\n");
            return ;
        }
        // printf("base %lf\n", base);
        // printf("x %lf\n", x);

        sprintf(str, "%lf", log(x) / log(base));
        // printf(">>log str %s\n", str);
        return str;
    }

%}

%union{
    int intval;
    char *strval;
}

%token NUMBER
%token ADD SUB
%token LOG
%token EOL

%type<strval> LOG
%type<intval> NUMBER


%type<strval> commandlist
%type<strval> term
%type<strval> exp

%%


commandlist:
|commandlist exp EOL{
    // $$ = compute_log($2);
    double ANS = 0;
    char* new_log;
    int i;
    for(i = 2;i<20;i++){
        if (LOGMAP[i] == 0){break;}
        // if (LOGMAP[i] == 1){continue;}
        new_log = combineStrings("log", intTostring(i));
        new_log = combineStrings(new_log, "(");
        new_log = combineStrings(new_log, intTostring(LOGMAP[i]));
        new_log = combineStrings(new_log, ")");
        // printf("new log  %s\n", new_log);

        char *ptr;
        double tmp;
        tmp = strtod(compute_log(new_log), &ptr);
        if(tmp>1e-5){
            printf("Log%d(%d): %lf\n", i, LOGMAP[i], tmp);
        }
        

        ANS += tmp;
        // printf(">>>>>>%lf\n",ANS);
    }

    if (i < 20 && LOGMAP[i] == 0){
        printf("LOG 內不能為0\n");
    }else{
        printf("--------------------\n");
        printf(">>LOG ans %lf\n", ANS);
    }

    for (i = 0; i < 20; i++){
        LOGMAP[i] = 1;
    }
    
    // printf("%s =  %s\n", $$, $2);
    // printf("------------------\n");
}

exp: term{
    // $$ = compute_log($1);
    // $$ = compute_log($1);
    // printf("%s\n", $$);
    // printf("--------\n");
    int base = atoi(extractSubstring($1, 'g', '('));
    int x = atoi(extractSubstring($1, '(', ')'));
    LOGMAP[base] *= x;
}

| exp ADD term{
    int base = atoi(extractSubstring($3, 'g', '('));
    int x = atoi(extractSubstring($3, '(', ')'));
    LOGMAP[base] *= x;
    // int base, number1, number2;
    // int ans;

    // findNum($1, &base, &number1);
    // printf("ADD\n");
    // printf("exp %s\n", $1);
    // printf("term %s\n", $3);
    // findNum($3, &base, &number2);
    // doubleAddAns(base, number1, number2);
    
}

| exp SUB term{
    int base = atoi(extractSubstring($3, 'g', '('));
    int x = atoi(extractSubstring($3, '(', ')'));
    if(LOGMAP[base] == 1){
        LOGMAP[base] = x;
    }else{
        LOGMAP[base]/= x;
    }
   
    // int base, number1, number2;
    // printf("SUB\n");
    // printf("exp %s\n", $1);
    // printf("term %s\n", $3);
    // findNum($1, &base, &number1);
    // findNum($3, &base, &number2);
    // doubleSubAns(base, number1, number2);
}

term:LOG{
    $$ = combineToNewLOG($1);
}


%%

main(int argc,char **argv){
	yyparse();
}

yyerror(char *s)
{
    fprintf(stderr,"error:%s\n",s);
}
