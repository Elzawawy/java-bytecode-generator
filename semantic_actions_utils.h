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

    unordered_set<int> makeList(int instruction_index) {
        std::unordered_set<int> list{instruction_index};
        return list;
    }

    unordered_set<int> mergeLists(unordered_set<int> list1, unordered_set<int> list2) {
        //As the call is by reference, list1 won't be changed and a its copy will be returned
        list1.insert(list2.begin(), list2.end());
        return list1;
    }
}
#endif //SEMANTIC_ACTIONS_UTILS_H
