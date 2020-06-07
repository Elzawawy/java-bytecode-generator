build_flex:
	@flex -o lexical_analyzer.yy.c java_lexical_analyzer.l

build_bison:
	@bison -b parser -d java_parser.y

build_exec:
	@g++ parser.tab.c lexical_analyzer.yy.c -o java_compiler.out

build_all:
	@bison -b parser -d java_parser.y
	@flex -o lexical_analyzer.yy.c java_lexical_analyzer.l 
	@g++ parser.tab.c lexical_analyzer.yy.c -o java_compiler.out

jasmin_run: 
	@java -jar jasmin.jar java_bytecode.j
	@java java_class

clean:
	rm -f *.o *~ lex.c lexical_analyzer.yy.c parser.tab.c parser.tab.h java_bytecode.j java_class.class java_compiler.out
