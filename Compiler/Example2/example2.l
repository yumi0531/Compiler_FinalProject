%{
    #include "example2.tab.h"
    #include <stdio.h>
    #include <string.h>
    /*[+-]?[0-9]+ {yylval.intval = atoi(yytext); return NUMBER;}*/
    /*"log"{nonZeroNumber}"("{nonZeroNumber}")"   { yylval.strval = strdup(yytext); return LOG;}*/
    // "log"{nonZeroNumber}"("{nonZeroNumber}"^"{nonZeroNumber}")" { yylval.strval = strdup(yytext); return LOG;}
%}

nonZeroNumber [1-9]+[0-9]*

%%

"+"   	{return ADD;}
"-"   	{return SUB;}

\n  	{return EOL;}
[\t] 	{/*空白忽略*/}
[ ]     {/* dont'care */}




"log"{nonZeroNumber}"("({nonZeroNumber}[*^/])*{nonZeroNumber}")" { yylval.strval = strdup(yytext);return LOG;}



[0-9]*"*""log"{nonZeroNumber}"("{nonZeroNumber}")"  { yylval.strval = strdup(yytext); return LOG;}



. 	{printf("非法字符 %c\n",*yytext);}

%%
