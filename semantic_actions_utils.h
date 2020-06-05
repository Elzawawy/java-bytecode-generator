//
// Created by mostafayousry on ٢‏/٦‏/٢٠٢٠.
//

#ifndef SEMANTIC_ACTIONS_UTILS_H
#define SEMANTIC_ACTIONS_UTILS_H

#include <unordered_map>
#include <string>
#include <utility>
#include <vector>

using namespace std;

namespace semantic_actions_util {
    enum VarType{ INT_TYPE, FLOAT_TYPE };
    unordered_map<string, pair<int, VarType>> varToVarIndexAndType;
    int currentVariableIndex = 1;
    vector<string> outputCode;

    void declareVariable(string name, int varType) {
        if(varToVarIndexAndType.count(name) == 1) 
            throw std::logic_error("Variable Already Declared");
        varToVarIndexAndType[name] = make_pair(currentVariableIndex++, static_cast<VarType>(varType));
    }
    bool checkIfVariableExists(string varName) {
        return varToVarIndexAndType.count(varName);
    }
    void appendToCode(string code) {
        outputCode.push_back(code);
    }
    void defineVariable(string name, int varType) {
        declareVariable(name,varType);
        if(varType==INT_TYPE){
            appendToCode("iconst_0\nistore_"+to_string(currentVariableIndex));
        }
        else if(varType==FLOAT_TYPE){
            appendToCode("fconst0\nfstore_"+to_string(currentVariableIndex));
        }

    }
    void generateHeader()
    {
    //TO-DO get file name
	//appendToCode(".source " + outfileName);
	appendToCode(".class public test\n.super java/lang/Object\n"); 
	appendToCode(".method public <init>()V");
	appendToCode("aload_0");
	appendToCode("invokenonvirtual java/lang/Object/<init>()V");
	appendToCode("return");
	appendToCode(".end method\n");
	appendToCode(".method public static main([Ljava/lang/String;)V");
	appendToCode(".limit locals 100\n.limit stack 100");

	defineVariable("1syso_int_var",INT_TYPE);
	defineVariable("1syso_float_var",FLOAT_TYPE);

	appendToCode(".line 1");
}

    void generateFooter()
    {
	appendToCode("return");
	appendToCode(".end method");
    }

}
#endif //SEMANTIC_ACTIONS_UTILS_H
