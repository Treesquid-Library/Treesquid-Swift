//
//  Tree.swift
//  
//
//  Created by Joachim Baran on 2021-07-10.
//

protocol Tree {
    // O(1)
    func isEmpty() -> Bool
    
    // O(n), where n is the number of nodes in the tree.
    func depth() -> Int
    
    // O(n), where n is the number of nodes in the tree.
    func breadth() -> Int
}

