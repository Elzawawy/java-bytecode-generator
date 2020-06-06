//
// Created by mostafayousry on ٢‏/٦‏/٢٠٢٠.
//

#ifndef SEMANTIC_ACTIONS_UTILS_H
#define SEMANTIC_ACTIONS_UTILS_H

#include <unordered_map>
#include <string>
#include <utility>
#include <vector>
#include <unordered_set>
#include <iostream>
#include <fstream>

using namespace std;

namespace semantic_actions_util {
    enum VarType {
        INT_TYPE, FLOAT_TYPE
    };
    unordered_map <string, pair<int, VarType>> varToVarIndexAndType;
    int currentVariableIndex = 1;
    int nextInstructionIndex = 0;
    vector <string> outputCode;
    int labelsCount = 0;
    unordered_map<string,string> opList = {
	    /* arithmetic operations */
        {"+", "add"},
        {"-", "sub"},
        {"/", "div"},
        {"*", "mul"},
        {"|", "or"},
        {"&", "and"},
        {"%", "rem"},

        /* relational op */
        {"==", "if_icmpeq"},
        {"<=", "if_icmple"},
        {">=", "if_icmpge"},
        {"!=", "if_icmpne"},
        {">",  "if_icmpgt"},
        {"<",  "if_icmplt"}
    };

    void declareVariable(string name, int varType) {
        if (varToVarIndexAndType.count(name) == 1)
            throw std::logic_error("Variable Already Declared");
        varToVarIndexAndType[name] = make_pair(currentVariableIndex++, static_cast<VarType>(varType));
    }

    bool checkIfVariableExists(string varName) {
        return varToVarIndexAndType.count(varName);
    }

    void appendToCode(string code) {
        outputCode.push_back("Label_" + std::to_string(nextInstructionIndex) + ":\n" + code);
        nextInstructionIndex++;
    }

    void backpatch(unordered_set<int> list, int instruction_index) {
        for (auto index : list) {
            outputCode[index] = outputCode[index].substr(0, outputCode[index].size()-1);
            outputCode[index] += "Label_" + to_string(instruction_index);
        }
    }

    void defineVariable(string name, int varType) {
        declareVariable(name, varType);
        if (varType == INT_TYPE) {
            appendToCode("iconst_0");
            appendToCode("istore_" + to_string(currentVariableIndex -1));
        } else if (varType == FLOAT_TYPE) {
            appendToCode("fconst_0");
            appendToCode("fstore_" + to_string(currentVariableIndex -1));
        }

    }

    void generateHeader() {
        //TO-DO get file name
        //appendToCode(".source " + outfileName);
        outputCode.push_back(".class public java_class\n.super java/lang/Object\n");
        outputCode.push_back(".method public <init>()V");
        outputCode.push_back("aload_0");
        outputCode.push_back("invokenonvirtual java/lang/Object/<init>()V");
        outputCode.push_back("return");
        outputCode.push_back(".end method\n");
        outputCode.push_back(".method public static main([Ljava/lang/String;)V");
        outputCode.push_back(".limit locals 100\n.limit stack 100");
        outputCode.push_back(".line 1");
    }

    void generateFooter() {
        outputCode.push_back("return");
        outputCode.push_back(".end method");
    }

    unordered_set<int> makeList(int instruction_index) {
        std::unordered_set<int> list{instruction_index};
        return list;
    }

    unordered_set<int> mergeLists(unordered_set<int> list1, unordered_set<int> list2) {
        //As the call is by reference, list1 won't be changed and a its copy will be returned
        list1.insert(list2.begin(), list2.end());
        return list1;
    }

    string getOperationCode(string lexeme) {
        if(opList.count(lexeme) == 0) return "";
        return opList[lexeme];
    }

    void writeBytecode(){
        ofstream java_bytecode_file;
        java_bytecode_file.open("java_bytecode.j");
        for(auto instruction: outputCode){
            // if(instruction.find("goto _") != string::npos) continue;
            java_bytecode_file<< instruction<< endl;
        }
        java_bytecode_file.close();
    }

}
#endif //SEMANTIC_ACTIONS_UTILS_H
