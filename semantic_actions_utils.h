//
// Created by mostafayousry on ٢‏/٦‏/٢٠٢٠.
//

#ifndef SEMANTIC_ACTIONS_UTILS_H
#define SEMANTIC_ACTIONS_UTILS_H

#include <vector>
#include <unordered_set>

namespace semantic_actions_util {
    void backpatch(std::unordered_set<int> &list, int instruction_index) {

    }

    std::unordered_set<int> makeList(int instruction_index) {
        std::unordered_set<int> list{instruction_index};
        return list;
    }

    std::unordered_set<int> mergeLists(std::unordered_set<int> list1, std::unordered_set<int> list2) {
        //As the call is by reference, list1 won't be changed and a its copy will be returned
        list1.insert(list2.begin(), list2.end());
        return list1;
    }

}
#endif //SEMANTIC_ACTIONS_UTILS_H
