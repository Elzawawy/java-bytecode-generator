%{
#include "parser.tab.h"
int line_num = 1;
%}
/** Regular Epressions Section **/
whitespace [ \t]+
letter  [a-zA-Z_]
digit   [0-9]
digits  {digit}+
id  {letter}({letter}|{digit})*
inum {digits}
fnum   {digits}.{digit}("E"{digits}+)?
arithop "+"|"-"|"*"|"/"|"%"
boolop  "&&"|"||"
relop   "=="|"!="|"<="|">="|"<"|">"

/** Extra Options Section**/
%option noyywrap

/** TOKENS Matching Specififcation, with their Semantic Actions. **/
%%
{whitespace} ;
"if"    { return IF;}
"else"  { return ELSE;}
"while" { return WHILE;}
"int"	{ return INT;}
"float"	{ return FLOAT;}
"true"  { return TRUE;}
"false" { return FALSE;}
{id}    { return IDENTIFIER;}
{inum}   { return INT_NUM;}
{fnum} { return FLOAT_NUM;}
{arithop}  { return ARITH_OP;}
{boolop}   { return BOOL_OP;}
{relop} { return REL_OP;}
"=" { return EQUAL;}
"," { return COMMA;}
";" { return SEMICOLON;}
"(" { return LEFT_BRACKET;}
")" { return RIGHT_BRACKET;}
"{" { return LEFT_BRACE;}
"}" { return RIGHT_BRACE;}
\n  { ++line_num;}
%%