%{
  #include <cstdio>
  #include <iostream>

  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  void yyerror(const char *s);
%}

%start method_body

%token IDENTIFIER
%token INT_NUM
%token FLOAT_NUM
%token ARITH_OP
%token REL_OP
%token IF
%token ELSE
%token WHILE
%token INT
%token FLOAT
%token EQUAL
%token COMMA
%token SEMICOLON
%token LEFT_BRACKET
%token RIGHT_BRACKET
%token LEFT_BRACE
%token RIGHT_BRACE


%%
method_body: 
            statement_list
            ;

statement_list: 
                statement
                |statement_list statement
                ;

statement:  
        declaration 
        |if 
        |while 
        |assignment
        ;

declaration: primitive_type IDENTIFIER SEMICOLON;

primitive_type: 
                INT 
                |FLOAT
                ;

if: 
    IF LEFT_BRACKET 
    expression RIGHT_BRACKET
    LEFT_BRACE statement_list 
    RIGHT_BRACE ELSE LEFT_BRACE 
    statement_list RIGHT_BRACE
    ;

while: 
        WHILE LEFT_BRACKET
        expression RIGHT_BRACKET
        LEFT_BRACE statement_list RIGHT_BRACE
        ;

assignment: IDENTIFIER EQUAL expression SEMICOLON;

expression:
            INT_NUM
            |FLOAT_NUM
            |expression ARITH_OP expression
            |IDENTIFIER
            |LEFT_BRACKET expression RIGHT_BRACKET
            ;
%%

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("java_source_code.in", "r");
  // Make sure it is valid:
  if (!myfile) {
    std::cout << "I can't open file!" << std::endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  
  // Parse through the input:
  yyparse();
  
}

void yyerror(const char *s) {
  std::cout << "EEK, parse error!  Message: " << s << std::endl;
  std::exit(-1);
}