%{
  #include <cstdio>
  #include <iostream>
  #include <string.h>
  #include <fstream>

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
%token<integer> INT_NUM
%token<floatType> FLOAT_NUM
%token<smallString> ARITH_OP
%token <smallString>BOOL_OP
%token <smallString>REL_OP
%token IF
%token ELSE
%token WHILE
%token TRUE
%token FALSE
%token INT
%token FLOAT

%type<varType> primitive_type
%type<expressionType> expression
%type<markerMType> marker_m
%type<markerNType> marker_n
%type<statementType> statement statement_list while if
%type<booleanExpressionType> boolean_expression

%code requires{
    #include <unordered_set>
}

%union{
    char id[30];
    char smallString[20];
    int varType;
    int integer;
    float floatType;

    struct ExpressionType{
      int varType;
    }expressionType;

    struct MarkerMType{
	int nextInstructionIndex;
    }markerMType;

    struct MarkerNType{
    	std::unordered_set<int> *nextList;
    }markerNType;

    struct StatementType{
    	std::unordered_set<int> *nextList;
    }statementType;

    struct BooleanExpressionType{
    	std::unordered_set<int> *trueList;
      std::unordered_set<int> *falseList;
    }booleanExpressionType;
}

%%
method_body: 
            %empty
            |{generateHeader();}statement_list{generateFooter();}
            ;

statement_list: 
                statement {*($$.nextList) = *($1.nextList);}
                |statement_list marker_m statement
                {
                  backpatch(*($1.nextList) ,$2.nextInstructionIndex);
                  *($$.nextList) = *($3.nextList);
                }
                ;

statement:  
        declaration {$$.nextList = new unordered_set<int>();}
        |if {*($$.nextList)=*($1.nextList);}
        |while {
          *($$.nextList)=*($1.nextList);
          } 
        |assignment {$$.nextList = new unordered_set<int>();}
        ;

marker_m:
	%empty{
	  // Save the index of the next instruction index in the marker
	  $$.nextInstructionIndex = nextInstructionIndex;
	}
	;

marker_n:
	%empty{
	  // Save the index of the next instruction index in the marker
    	  $$.nextList = new unordered_set<int>();
	  *($$.nextList) = makeList(nextInstructionIndex);
	  appendToCode("goto _");
	}
	;

declaration: primitive_type IDENTIFIER ';' {
  if(checkIfVariableExists($2)) {
    yyerror(string{"variable "+string{$2}+" is already declared"}.data());
  } else {
    defineVariable($2, $1);
  }
};

primitive_type: 
                INT { $$ = VarType::INT_TYPE; }
                |FLOAT {$$ = VarType::FLOAT_TYPE; }
                ;

if:
    	IF '(' boolean_expression ')'
    	marker_m
    	'{' statement_list '}'
    	marker_n
    	ELSE '{' marker_m statement_list '}' {
      backpatch(*($3.trueList), $5.nextInstructionIndex);
      backpatch(*($3.falseList), $12.nextInstructionIndex);
      std::unordered_set<int> temp = mergeLists( *($7.nextList), *($9.nextList));
      $$.nextList = new unordered_set<int>();
      *($$.nextList) = mergeLists(temp, *($13.nextList));
    	}
    	;

while: 
        WHILE marker_m '(' boolean_expression ')'
        '{' marker_m statement_list '}' {
          backpatch(*($8.nextList), $2.nextInstructionIndex);
          backpatch(*($4.trueList), $7.nextInstructionIndex);
          $$.nextList = new unordered_set<int>();
          *($$.nextList) = *($4.falseList);
          appendToCode("goto _" + $2.nextInstructionIndex);
        }
        ;

assignment: IDENTIFIER '=' expression ';'{
  cout<<"asg: "<<$1<<" "<<" "<<$3.varType<<endl;
  if(checkIfVariableExists($1)) {
    //Check if the two sides have the same type
    if(varToVarIndexAndType[$1].second == $3.varType) {
      if(varToVarIndexAndType[$1].second == VarType::INT_TYPE) {
        appendToCode("istore_"+to_string(varToVarIndexAndType[$1].first));
      } else {//Only int and float are supported
        appendToCode("fstore_"+to_string(varToVarIndexAndType[$1].first));
      }
    } else { // case when the two types aren't the same
      //TODO Cast the two variables
    }
  } else {
    yyerror(string{"variable "+string{$1}+" not declared"}.data());
  }
};

expression:
            INT_NUM {
                  $$.varType = VarType::INT_TYPE;
                  appendToCode("ldc "+ to_string($1));
                    } 
            |FLOAT_NUM {
                  $$.varType = VarType::FLOAT_TYPE ;
                  appendToCode("ldc "+ to_string($1)); }
            |IDENTIFIER {
              // check if the identifier already exist to load or not
            	if(checkIfVariableExists($1)) {
            		$$.varType = varToVarIndexAndType[$1].second;
            		if($$.varType == VarType::INT_TYPE ) {
            		  //write iload + identifier
					        appendToCode("iload_" + to_string(varToVarIndexAndType[$1].first));
            		}
            		else {
            		  //float 
						      //write fload + identifier
					        appendToCode("fload_" + to_string(varToVarIndexAndType[$1].first));
            		}
            	}
            	else {//it's not declared at all
			                string err = "identifier: "+string{$1}+" isn't declared in this scope";
                      yyerror(err.c_str());
            	}
            }
            |expression ARITH_OP expression { 
                  if ($1.varType == $3.varType ) {
                    cout<<"Arith "<<$2<<endl;
                    if ($1.varType == VarType::INT_TYPE) {
                      appendToCode("i" + getOperationCode($2));
                    }
                  else{ //it's float          
                    appendToCode("f" + getOperationCode($2));
                  }
                }
			        }
            |'(' expression ')' {$$.varType = $2.varType;}
            ;

boolean_expression: 
                    TRUE {
                    $$.trueList = new unordered_set<int> ();
                    $$.trueList->insert(static_cast<int>(outputCode.size()));
                    $$.falseList = new unordered_set<int>();
                    // write code goto line #
		    appendToCode("goto _");
                    }
                    |FALSE {
                    $$.trueList = new unordered_set<int> ();
                    $$.falseList= new unordered_set<int>();
                    $$.falseList->insert(static_cast<int>(outputCode.size()));
                    // write code goto line #
		    appendToCode("goto _");
                    }
                    |boolean_expression BOOL_OP marker_m boolean_expression {
                    if(!strcmp($2, "&&")) {
                        backpatch(*($1.trueList), $3.nextInstructionIndex);
                        *($$.trueList) = *($4.trueList);
                        *($$.falseList) = mergeLists(*($1.falseList), *($4.falseList));
                      }
                    else if (!strcmp($2,"||")) {
                        backpatch(*($1.falseList), $3.nextInstructionIndex);
                        *($$.trueList) = mergeLists(*($1.trueList), *($4.trueList));
                        *($$.falseList) = *($4.falseList);
                      }
                    }
                    |expression REL_OP expression {
                    $$.trueList = new unordered_set<int>();
                    ($$.trueList)->insert(static_cast<int>(outputCode.size()));
                    $$.falseList = new unordered_set<int>();
                    ($$.falseList)->insert(static_cast<int>(outputCode.size()+1));
                    appendToCode(getOperationCode($2)+ " ");
                    appendToCode("goto _");
                    }
                    ;
%%

string genLabel()
{
	return "L_"+to_string(labelsCount++);
}


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

  writeBytecode();
}

void yyerror(const char *s) {
  std::cout << "Ouch, I found a parse error on line "<< line_num <<" ! Error Message: " << s << std::endl;
  std::exit(-1);
}
