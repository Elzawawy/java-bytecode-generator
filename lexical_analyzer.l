%{
#include "parser.tab.h"
%}
/** Regular Epressions Section **/
whitespace [ \t\n]+
letter  [a-zA-Z_]
digit   [0-9]
digits  {digit}+
id  {letter}({letter}|{digit})*
inum {digits}
fnum   {digits}.{digit}("E"{digits}+)?
relop   "=" |"!=" |"<=" |">=" |"<" |">"
arithop   "+" |"-" |"*" |"/" | "%"

/** Extra Options Section**/
%option noyywrap

/** TOKENS Matching Specififcation, with their Semantic Actions. **/
%%
{whitespace} ;
{id}    { return IDENTIFIER;}
{inum}   { return INT_NUM;}
{fnum} { return FLOAT_NUM;}
{arithop}  { return ARITH_OP;}
{relop} { return REL_OP;}
"if"    { return IF;}
"else"  { return ELSE;}
"while" { return WHILE;}
"int"	{ return INT;}
"float"	{ return FLOAT;}
"=" { return EQUAL;}
"," { return COMMA;}
";" { return SEMICOLON;}
"(" { return LEFT_BRACKET;}
")" { return RIGHT_BRACKET;}
"{" { return LEFT_BRACE;}
"}" { return RIGHT_BRACE;}
%%