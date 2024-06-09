cd C:\Users\yumi\Desktop\Compiler\Example2
flex example2.l
bison -d example2.y
gcc example2.tab.c lex.yy.c -lfl 
a.exe