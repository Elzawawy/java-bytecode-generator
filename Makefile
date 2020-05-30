build_flex:
	@flex -o lexical_analyzer.yy.c java_lexical_analyzer.l

build_bison:
	@bison -b parser -d java_parser.y

build_exec:
	@g++ parser.tab.c lexical_analyzer.yy.c -lfl -o java_compiler.out

build_all:
	@flex -o lexical_analyzer.yy.c java_lexical_analyzer.l 
	@bison -b parser -d java_parser.y
	@g++ parser.tab.c lexical_analyzer.yy.c -lfl -o java_compiler.out