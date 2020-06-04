%{
  #include <cstdio>
  #include <iostream>
  #include "semantic_actions_utils.h"

  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int line_num;
  void yyerror(const char *s);
%}

%start method_body
%error-verbose

%token IDENTIFIER
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

%%
method_body: 
            %empty
            |statement_list
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

declaration: primitive_type IDENTIFIER ';';

primitive_type: 
                INT 
                |FLOAT
                ;

if: 
    IF '(' boolean_expression ')'
    '{' statement_list '}' 
    ELSE '{' statement_list '}'
    ;

while: 
        WHILE '(' boolean_expression ')'
        '{' statement_list '}'
        ;

assignment: IDENTIFIER '=' expression ';';

expression:
            INT_NUM {$$.sType = INT_TYPE;  } 
            |FLOAT_NUM {$$.sType = FLOAT_TYPE ; }
            |IDENTIFIER {

            // check if the identifier already exist to load or not
            	if(checkIfVariableExists($1))
            	{
            		$$.sType = varToVarIndexAndType[$1].second;
            		if($$.sType == INT_TYPE )
            		{
            		//write iload + identifier
					appendToCode("iload " + to_string(symbTab[str].first));
            		}
            		else
            		//float
            		{
						//write fload + identifier
					appendToCode("fload " + to_string(symbTab[str].first));
            		}



            	}
            	else //it's not declared at all

            	{
			string err = "identifier: "+str+" isn't declared in this scope";
                        yyerror(err.c_str());
                        $$.sType = ERROR_T;
            	}



            }
            |expression ARITH_OP expression { 
			
			if ($1.sType == $3.sType )
			{
				if ($1.sType == INT_TYPE)
					//write 'i' + instruction *get op fx*
				
				appendToCode("i" + // get)
				else //it's float
					//write 'f' + instruction *get op fx*
				
			}
			
			
			
			
			}
            |'(' expression ')' {$$.sType = $2.sType;}
            ;

boolean_expression: 
                    TRUE
                    {
                    $$.trueList = new vector<int> ();
                    $$.trueList->push_back(codeList.size());
                    $$.falseList = new vector<int>();
                    // write code goto line #
					appendToCode("goto " + //line #)


                    }
                    |FALSE
                    {
                    $$.trueList = new vector<int> ();
                    $$.falseList= new vector<int>();
                    $$.falseList->push_back(codeList.size());
                    // write code goto line #
					appendToCode("goto " + //line #)

                    }
                    |expression BOOL_OP expression
                    {



                    }
                    |expression REL_OP expression
                    {



                    }


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
