<h1 align='center'>Yet Another Java ByteCode Generator</h1>

Built using Flex & Bison to take in any java source code and emits its equivalent bytecode. This is a project developed for the PLT (**P**rogramming **L**anguage **T**ranslation) course at Faculty of Engineering, Alexandria University in Spring 2020 Offering.

<p align='center'><img src='./images/cover.png'/></p>

## Translation of Productions
Each production is associated with a **semantic actions**. This semantic actions will be generated when the production is matched by the parser.


## Backpatching
When generating code for boolean expressions and flow-of-control statements is that of matching a jump instruction with the target of the jump. For example, the translation of the boolean expression B in **if ( B ) S**, the target of the jump when **B** is false will not be declared until **S** is examined. In a
one-pass translation, the problem is solved by passing labels as inherited attributes to where the relevant jump instructions were generated. But a separate pass is then needed to bind labels to addresses.

***Backpatching*** counters the problem of two-passes translation by having lists of jumps are passed as synthesized attributes. Specifically, when a jump
is generated, the target of the jump is temporarily left unspecified. Each such jump is put on a list of jumps whose labels are to be filled in when the proper
label can be determined.


## Assumptions
### Java Used Grammar
The input programs we are dealing with follow the below rules. These aren't a full java grammar but a subset of it.

```
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
            INT_NUM
            |FLOAT_NUM
            |IDENTIFIER
            |expression ARITH_OP expression
            |'(' expression ')'
            ;

boolean_expression: 
                    TRUE 
                    |FALSE
                    |expression BOOL_OP expression
                    |expression REL_OP expression
```

## Running & Testing

To run the program, use the script `run.sh` as follows:

    ./run.sh file_name
where filename, can be any file that contains java source code.

For testing purposes while development use this,

    ./run.sh --debug file_name
or

    ./run.sh -d file_name

where file_name is a file that exists in the `test-cases` folder. The extra argument will ensure we keep all our test files from the `test-cases` folder and picking the suitable unit test case for the part you're developing.

## Resources

### Understanding Flex & Bison

- [Flex & Bison by John Levine. The definitive textbok for using these tools.](http://web.iitd.ac.in/~sumeet/flex__bison.pdf)
- [Bison Official Doumentation.](https://www.gnu.org/software/bison/manual/html_node/index.html)
- [Tutorial: Simple Bison Tutorial to start with](http://alumni.cs.ucr.edu/~lgao/teaching/bison.html)
- [Tutorial: For complete novices needing to use Flex and Bison for some real project,](https://aquamentus.com/flex_bison.html) then watching this complemntery [video](https://www.youtube.com/watch?v=xFN9txVKhUs).
- [Tutorial: Writing Your Own Toy Compiler Using Flex, Bison and LLVM.](https://gnuu.org/2009/09/18/writing-your-own-toy-compiler/)

### Understanding Java Bytecode

 - [Wiki's Java bytecode](https://en.wikipedia.org/wiki/Java_bytecode) and the [list of the instructions that make up the Java bytecode.](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings)

### Understanding Jasmin

- [Jasmin Official Documentation.](http://jasmin.sourceforge.net/)
