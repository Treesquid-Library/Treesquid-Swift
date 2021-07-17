import Foundation
import XCTest
@testable import Treesquid

final class BinaryTreeTests: XCTestCase {
    static let treeFullThreeLevels = BinaryTree<String, Any>()
        .insert(node: BinaryTreeNode(key: "root1"))
        .insert(node: BinaryTreeNode(key: "l2"))
        .insert(node: BinaryTreeNode(key: "r2"))
        .insert(node: BinaryTreeNode(key: "ll3"))
        .insert(node: BinaryTreeNode(key: "lr3"))
        .insert(node: BinaryTreeNode(key: "rl4"))
        .insert(node: BinaryTreeNode(key: "rr4"))
    static let treeTwoLevels = BinaryTree<Int, Any>()
        .insert(node: try! BinaryTreeNode(key: 0)
                    .append(BinaryTreeNode(key: 1))
                    .append(BinaryTreeNode(key: 2)))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = BinaryTree<Any, Any>()
        XCTAssert(emptyTree.isEmpty(),
                  "Empty binary tree is not empty.")
    }
    
    func testEmptyTreeZeroBreadth() {
        let emptyTree = BinaryTree<Any, Any>()
        XCTAssert(emptyTree.breadth() == 0,
                  "Empty binary tree's breadth is not zero.")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = BinaryTree<Any, Any>()
        XCTAssert(emptyTree.depth() == 0,
                  "Empty binary tree's depth is not zero'.")
    }
    
    func testFullTreeTwoLevelsDepth() {
        XCTAssert(BinaryTreeTests.treeFullThreeLevels.depth() == 3,
                  "Full tree of three levels has incorrect depth.")
    }
    
    func testFullTreeTwoLevelsBreadth() {
        XCTAssert(BinaryTreeTests.treeFullThreeLevels.breadth() == 4,
                  "Full tree of three levels has incorrect breadth.")
    }
    
    func testFullTreeTwoLevelsLevels() {
        let levels = BinaryTreeTests.treeFullThreeLevels.levels()
        XCTAssert(levels.count == 3,
                  "Full tree of three levels reports wrong number of levels.")
        for level in 0..<levels.count {
            XCTAssert(levels[level].count == Int(pow(2.0, Double(level))),
                      "Full tree of three levels' level has an incorrect number of nodes.")
        }
    }
    
    func testTreeTwoLevelsDepth() {
        XCTAssert(BinaryTreeTests.treeTwoLevels.depth() == 2,
                  "Tree of two levels has incorrect depth.")
    }
    
    func testTreeTwoLevelsBreadth() {
        XCTAssert(BinaryTreeTests.treeTwoLevels.breadth() == 2,
                  "Tree of two levels has incorrect breadth.")
    }
    
    func testTreeTwoLevelsContents() {
        guard let rootNode = BinaryTreeTests.treeTwoLevels.root else {
            XCTFail("Root node is nil.")
            return
        }
        XCTAssert(rootNode.key == 0,
                  "Root node's value is incorrect. Expected: 0")
        for index in 0...1 {
            XCTAssert(rootNode[index] != nil,
                      "Root node's child at \(index) is nil.")
            let expectedKey = index + 1
            XCTAssert(rootNode[index]!.key == expectedKey,
                      "Root node's child at \(index) has an incorrect key. Expected: \(expectedKey)")
        }
    }
    
    func testTreeTwoLevelsIndexEquivalency() {
        guard let rootNode = BinaryTreeTests.treeTwoLevels.root else {
            XCTFail("Root node is nil.")
            return
        }
        XCTAssert(rootNode[0] === rootNode[BinaryTreeNode<Int, Any>.Child.left.rawValue],
                  "Subscript: index 0 is not equivalent to Child.left.rawValue.")
        XCTAssert(rootNode[1] === rootNode[BinaryTreeNode<Int, Any>.Child.right.rawValue],
                  "Subscript: index 0 is not equivalent to Child.right.rawValue.")
        XCTAssert(rootNode[BinaryTreeNode.Child.left] === rootNode[BinaryTreeNode<Int, Any>.Child.left.rawValue],
                  "Subscript: index 0 is not equivalent to Child.left.rawValue.")
        XCTAssert(rootNode[BinaryTreeNode.Child.right] === rootNode[BinaryTreeNode<Int, Any>.Child.right.rawValue],
                  "Subscript: index 0 is not equivalent to Child.right.rawValue.")
    }
}
