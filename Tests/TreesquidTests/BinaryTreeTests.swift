import Foundation
import XCTest
@testable import Treesquid

final class BinaryTreeTests: XCTestCase {
    static let treeFullThreeLevels = BinaryTree<Int, Any>()
        .insert(node: BinaryTreeNode(key: 100))
        .insert(node: BinaryTreeNode(key: 200))
        .insert(node: BinaryTreeNode(key: 201))
        .insert(node: BinaryTreeNode(key: 300))
        .insert(node: BinaryTreeNode(key: 301))
        .insert(node: BinaryTreeNode(key: 310))
        .insert(node: BinaryTreeNode(key: 311))
    static let treeTwoLevels = BinaryTree<String, Any>()
        .insert(node: try! BinaryTreeNode(key: "n0")
                    .append(BinaryTreeNode(key: "n1"))
                    .append(BinaryTreeNode(key: "n2")))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = BinaryTree<Any, Any>()
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = BinaryTree<Any, Any>()
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = BinaryTree<Any, Any>()
        let depth = emptyTree.depth()
        XCTAssert(depth == 0, "Depth is \(depth). Expected: 0")
    }
    
    func testFullTreeThreeLevelsDepth() {
        let depth = BinaryTreeTests.treeFullThreeLevels.depth()
        XCTAssert(depth == 3, "Depth is \(depth). Expected: 3")
    }
    
    func testFullTreeThreeLevelsWidth() {
        let width = BinaryTreeTests.treeFullThreeLevels.width()
        XCTAssert(width == 4, "Width is \(width). Expected: 4")
    }
    
    func testFullTreeThreeLevelsLevels() {
        let levels = BinaryTreeTests.treeFullThreeLevels.levels()
        XCTAssert(levels.count == 3,
                  "Number of levels is \(levels.count). Expected: 3")
        let degree = 2
        for level in 0..<levels.count {
            let nodesInLevel = levels[level].count
            let expectedNumberOfNodes = Int(pow(2.0, Double(level)))
            XCTAssert(nodesInLevel == expectedNumberOfNodes,
                      "Level \(level + 1) has \(nodesInLevel) nodes. Expected: \(expectedNumberOfNodes)")
            for nodeIndex in 0..<nodesInLevel {
                let node = levels[level][nodeIndex]
                let inLevelAddress = 10 * (nodeIndex / degree) + nodeIndex % degree
                let expectedKey = (level + 1) * 100 + inLevelAddress
                if node.key == nil {
                    XCTFail("Node key is nil. Expected: \(expectedKey)")
                    continue
                }
                XCTAssert(node.key! == expectedKey,
                          "Node key is \(node.key!). Expected: \(expectedKey)")
            }
        }
    }
    
    func testTreeTwoLevelsDepth() {
        let depth = BinaryTreeTests.treeTwoLevels.depth()
        XCTAssert(depth == 2, "Depth is \(depth). Expected: 2")
    }
    
    func testTreeTwoLevelsWidth() {
        let width = BinaryTreeTests.treeTwoLevels.width()
        XCTAssert(width == 2, "Width is \(width). Expected: 2")
    }
    
    func testTreeTwoLevelsContents() {
        guard let rootNode = BinaryTreeTests.treeTwoLevels.root else {
            XCTFail("Root node is nil.")
            return
        }
        XCTAssert(rootNode.key! == "n0",
                  "Root node's key is \(rootNode.key!). Expected: n0")
        for index in 0...1 {
            XCTAssert(rootNode[index] != nil,
                      "Child node at index \(index) is nil.")
            let observedKey = rootNode[index]!.key!
            let expectedKey = "n\(index + 1)"
            XCTAssert(observedKey == expectedKey,
                      "Child node at \(index) has a key of \(observedKey). Expected: \(expectedKey)")
        }
    }
    
    func testTreeTwoLevelsIndexEquivalency() {
        guard let rootNode = BinaryTreeTests.treeTwoLevels.root else {
            XCTFail("Root node is nil.")
            return
        }
        BinaryTreeTests.compareSubscriptIndex(index: 0,
                                              alternativeIndex: BinaryTreeNode<Int, Any>.Child.left.rawValue)
        BinaryTreeTests.compareSubscriptIndex(index: 1,
                                              alternativeIndex: BinaryTreeNode<Int, Any>.Child.right.rawValue)
        BinaryTreeTests.compareSubscriptSymbolic(node: rootNode,
                                                 index: 0,
                                                 symbolicIndex: BinaryTreeNode<String, Any>.Child.left)
        BinaryTreeTests.compareSubscriptSymbolic(node: rootNode,
                                                 index: 1,
                                                 symbolicIndex: BinaryTreeNode<String, Any>.Child.right)
    }
    
    private static func compareSubscriptIndex(index: Int, alternativeIndex: Int) {
        XCTAssert(index == alternativeIndex,
                  "Subscript index \(index) differs from Child.'left or right'.rawValue.")
    }
    
    private static func compareSubscriptSymbolic(node: BinaryTreeNode<String, Any>, index: Int, symbolicIndex: BinaryTreeNode<String, Any>.Child) {
        XCTAssert(node[index] === node[symbolicIndex],
                  "Subscript index \(index) return a different node than Child.'left or right'.")
    }
}
