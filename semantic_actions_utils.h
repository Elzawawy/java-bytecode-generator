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
        outputCode.push_back(code);
        nextInstructionIndex++;
    }

    void backpatch(unordered_set<int> list, int instruction_index) {
        for (auto index : list) {
            outputCode[index] += to_string(instruction_index);
        }
    }

    void defineVariable(string name, int varType) {
        declareVariable(name, varType);
        if (varType == INT_TYPE) {
            appendToCode("iconst_0\nistore_" + to_string(currentVariableIndex));
        } else if (varType == FLOAT_TYPE) {
            appendToCode("fconst0\nfstore_" + to_string(currentVariableIndex));
        }

    }

    void generateHeader() {
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

        defineVariable("1syso_int_var", INT_TYPE);
        defineVariable("1syso_float_var", FLOAT_TYPE);

        appendToCode(".line 1");
    }

    void generateFooter() {
        appendToCode("return");
        appendToCode(".end method");
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

}
#endif //SEMANTIC_ACTIONS_UTILS_H
