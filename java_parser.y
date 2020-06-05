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
					appendToCode("iload " + to_string(varToVarIndexAndType[$1].first));
            		}
            		else
            		//float
            		{
						//write fload + identifier
					appendToCode("fload " + to_string(varToVarIndexAndType[$1].first));
            		}



            	}
            	else //it's not declared at all

            	{
			string err = "identifier: "+$1+" isn't declared in this scope";
                        yyerror(err.c_str());
                        $$.sType = ERROR_T;
            	}



            }
            |expression ARITH_OP expression { 
			
			if ($1.sType == $3.sType )
			{
				if ($1.sType == INT_TYPE)
					
				
				appendToCode("i" + getOperationCode($2) );
				else //it's float
					
				appendToCode("f" + getOperationCode($2) );
			}
			
			
			
			
			}
            |'(' expression ')' {$$.sType = $2.sType;}
            ;

boolean_expression: 
                    TRUE
                    {
                    $$.trueList = new vector<int> ();
                    $$.trueList->push_back(//code size );
                    $$.falseList = new vector<int>();
                    // write code goto line #
					appendToCode("goto ")


                    }
                    |FALSE
                    {
                    $$.trueList = new vector<int> ();
                    $$.falseList= new vector<int>();
                    $$.falseList->push_back(//code size);
                    // write code goto line #
					appendToCode("goto ")

                    }
                    |expression BOOL_OP expression
                    {
					if(!strcmp($2, "&&"))
						{
							
							$$.trueList = $3.trueList;
							$$.falseList = merge($1.falseList,$3.falseList);
						}
					else if (!strcmp($2,"||"))
						{
							
							$$.trueList = merge($1.trueList, $3.trueList);
							$$.falseList = $3.falseList;
						}


                    }
                    |expression REL_OP expression
                    {
					$$.trueList = new vector<int>();
					$$.trueList ->push_back (//code size);
					
					$$.falseList = new vector<int>();
					$$.falseList->push_back(//code size+1);
					
					
					appendToCode(getOperationCode($2)+ " ");
					appendToCode("goto ");


                    }


%%


string getOperationCode(string operational)
{
	    map<string, string>::iterator it ; 
	    it = mp.find(operational); 

	if(it == opList.end()) 
        return ""; 
    else
       return it->second;

}
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
}

void yyerror(const char *s) {
  std::cout << "Ouch, I found a parse error on line "<< line_num <<" ! Error Message: " << s << std::endl;
  std::exit(-1);
}
