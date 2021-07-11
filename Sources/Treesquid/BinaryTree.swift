//
//  BinaryTree.swift
//  
//
//  Created by Joachim Baran on 2021-07-10.
//

import Foundation

class BinaryTreeNode<T> {
    var parent: BinaryTreeNode?
    var left: BinaryTreeNode?
    var right: BinaryTreeNode?
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

class BinaryTree<T>: Tree {
    var root: BinaryTreeNode<T>?

    //
    // Boolean tree-properties
    //
    
    func isEmpty() -> Bool {
        return root == nil
    }
    
    //
    // Non-boolean tree-properties
    //
    
    func breadth() -> Int {
        guard let root = root else { return 0 }
        var levelStack = [[root]]
        levels(levelStack: &levelStack)
        return levelStack.map { $0.count }.max()!
    }
    
    func depth() -> Int {
        return depth(root)
    }
    
    //
    // Tree access
    //
    
    func append(node: BinaryTreeNode<T>) -> BinaryTree {
        if root == nil {
            root = node
            return self
        }
        return append(node, depth: 1, level: [root!])
    }
    
    func levels() -> [[BinaryTreeNode<T>]] {
        guard let root = root else { return [] }
        var levelStack: [[BinaryTreeNode<T>]] = [[root]]
        levels(levelStack: &levelStack)
        return levelStack
    }
    
    //
    // Private functions
    //
    
    private func append(_ newNode: BinaryTreeNode<T>, depth: Int, level: [BinaryTreeNode<T>]) -> BinaryTree<T> {
        var nextLevel: [BinaryTreeNode<T>] = []
        for node in level {
            if node.left == nil {
                node.left = newNode
                return self
            }
            if node.right == nil {
                node.right = newNode
                return self
            }
            nextLevel.append(node.left!)
            nextLevel.append(node.right!)
        }
        return append(newNode, depth: depth + 1, level: nextLevel)
    }
    
    private func depth(_ node: BinaryTreeNode<T>?) -> Int {
        guard let node = node else { return 0 }
        return max(depth(node.left), depth(node.right)) + 1
    }
    
    private func levels(levelStack: inout [[BinaryTreeNode<T>]]) {
        guard let deepestLevel = levelStack.last else { return }
        var nextLevel: [BinaryTreeNode<T>] = []
        for node in deepestLevel {
            if node.left != nil { nextLevel.append(node.left!) }
            if node.right != nil { nextLevel.append(node.right!) }
        }
        if nextLevel.isEmpty { return }
        levelStack.append(nextLevel)
        return levels(levelStack: &levelStack)
    }
}
