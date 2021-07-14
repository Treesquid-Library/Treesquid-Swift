import Foundation
import XCTest
@testable import Treesquid

final class BinaryTreeTests: XCTestCase {
    static let treeFullThreeLevels = BinaryTree()
        .append(node: BinaryTreeNode(value: "root1"))
        .append(node: BinaryTreeNode(value: "l2"))
        .append(node: BinaryTreeNode(value: "r2"))
        .append(node: BinaryTreeNode(value: "ll3"))
        .append(node: BinaryTreeNode(value: "lr3"))
        .append(node: BinaryTreeNode(value: "rl4"))
        .append(node: BinaryTreeNode(value: "rr4"))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = BinaryTree<Any>()
        XCTAssert(emptyTree.isEmpty(),
                  "Empty binary tree is not empty.")
    }
    
    func testEmptyTreeZeroBreadth() {
        let emptyTree = BinaryTree<Any>()
        XCTAssert(emptyTree.breadth() == 0,
                  "Empty binary tree's breadth is not zero.")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = BinaryTree<Any>()
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
}
