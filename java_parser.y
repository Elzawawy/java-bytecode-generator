%{
  #include <cstdio>
  #include <iostream>
  #include "semantic_actions_utils.h"

  using namespace semantic_actions_util;

  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int line_num;
  void yyerror(const char *s);
%}

%start method_body
%error-verbose

%token<id> IDENTIFIER
%token INT_NUM
%token FLOAT_NUM
%token ARITH_OP
%token BOOL_OP
%token REL_OP
%token IF
%token ELSE
%token WHILE
%token TRUE
%token FALSE
%token INT
%token FLOAT

%type<varType> primitive_type 
%type<expressionType> expression;

%union{
	  char id[30];
    int varType;
    struct ExpressionType{
      int varType;
    }expressionType;
}

%%
method_body: 
            %empty
            |{generateHeader();}statement_list{generateFooter();}
            ;

statement_list: 
                statement
                |statement_list marker statement
                {
                  //backpatch(nextlist for statment)
                  //nextlist=goto or marker nextlist
                }
                ;

statement:  
        declaration 
        |if 
        |while 
        |assignment
        ;

declaration: primitive_type IDENTIFIER ';' {
  if(checkIfVariableExists($2)) {
    yyerror(string{"variable "+string{$2}+" is already declared"}.data());
  } else {
    declareVariable($2, $1);
  }
};

primitive_type: 
                INT { $$ = VarType::INT_TYPE; }
                |FLOAT {$$ = VarType::FLOAT_TYPE; }
                ;

if: 
    IF '(' boolean_expression ')'
    marker
    '{' statement_list '}' 
    ELSE '{' marker statement_list '}'
    ;
    {
//
S ! if ( B ) M 1 S 1 N else M 2 S 2
{ backpatch ( B: truelist ; M 1 : instr );
backpatch ( B: falselist ; M 2 : instr );
temp = merge ( S 1 : nextlist ; N: nextlist );
S: nextlist = merge ( temp ; S 2 : nextlist ); }
    }

while: 
        WHILE '(' boolean_expression ')'
        '{' statement_list '}'
        ;

assignment: IDENTIFIER '=' expression ';'{
  cout<<"asg: "<<$1<<" "<<" "<<$3.varType<<endl;
  if(checkIfVariableExists($1)) {
    //Check if the two sides have the same type
    if(varToVarIndexAndType[$1].second == $3.varType) {
      if(varToVarIndexAndType[$1].second == VarType::INT_TYPE) {
        appendToCode("istore_"+varToVarIndexAndType[$1].first);
      } else {//Only int and float are supported
        appendToCode("fstore_"+varToVarIndexAndType[$1].first);
      }writeCode
    } else { // case when the two types aren't the same
      //TODO Cast the two variables
    }
  } else {
    yyerror(string{"variable "+string{$1}+" not declared"}.data());
  }
};

expression:
            INT_NUM {$$.varType = VarType::INT_TYPE;}
            |FLOAT_NUM {$$.varType = VarType::FLOAT_TYPE;}
            |IDENTIFIER {
              if(checkIfVariableExists($1)) {
                $$.varType = varToVarIndexAndType[$1].second;
              } else {
                //TODO handle the error of variable used but not declared
              }
              }
            |expression ARITH_OP expression
            |'(' expression ')'{}
            ;

boolean_expression: 
                    TRUE 
                    |FALSE
                    |expression BOOL_OP expression
                    |expression REL_OP expression


%%

int main(int argc, char** argv) {
  // Open a file handle to a particular file:
  if (argc == 1){
    std::cout << "No file's specified to open ! Please provide a valid file name" << std::endl;
    return -1;
  }
  FILE *myfile = fopen(argv[1], "r");
  // Make sure it is valid:
  if (!myfile) {
    std::cout << "I can't open file!" << std::endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  
  // Parse through the input:
  yyparse();
  std::cout<<"Yay ! Parser completed working successfully."<<std::endl;
}


void yyerror(const char *s) {
  std::cout << "Ouch, I found a parse error on line "<< line_num <<" ! Error Message: " << s << std::endl;
  std::exit(-1);
}
