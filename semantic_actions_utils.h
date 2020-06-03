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

}
#endif //SEMANTIC_ACTIONS_UTILS_H
