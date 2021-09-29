import Foundation
import XCTest
@testable import Treesquid

final class BinaryTreeTests: XCTestCase {
    static let treeFullThreeLevels = BinaryTree<Int>()
        .insert(node: BinaryTreeNode(value: 100))
        .insert(node: BinaryTreeNode(value: 200))
        .insert(node: BinaryTreeNode(value: 201))
        .insert(node: BinaryTreeNode(value: 300))
        .insert(node: BinaryTreeNode(value: 301))
        .insert(node: BinaryTreeNode(value: 310))
        .insert(node: BinaryTreeNode(value: 311))
    static let treeTwoLevels = BinaryTree<String>()
        .insert(node: try! BinaryTreeNode(value: "n0")
                    .append(BinaryTreeNode(value: "n1"))
                    .append(BinaryTreeNode(value: "n2")))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = BinaryTree<Any>()
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = BinaryTree<Any>()
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = BinaryTree<Any>()
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
                let expectedValue = (level + 1) * 100 + inLevelAddress
                if node.value == nil {
                    XCTFail("Node value is nil. Expected: \(expectedValue)")
                    continue
                }
                XCTAssert(node.value! == expectedValue,
                          "Node value is \(node.value!). Expected: \(expectedValue)")
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
        XCTAssert(rootNode.value! == "n0",
                  "Root node's value is \(rootNode.value!). Expected: n0")
        for index in 0...1 {
            XCTAssert(rootNode[index] != nil,
                      "Child node at index \(index) is nil.")
            let observedValue = rootNode[index]!.value!
            let expectedValue = "n\(index + 1)"
            XCTAssert(observedValue == expectedValue,
                      "Child node at \(index) has a value of \(observedValue). Expected: \(expectedValue)")
        }
    }
    
    func testTreeTwoLevelsIndexEquivalency() {
        guard let rootNode = BinaryTreeTests.treeTwoLevels.root else {
            XCTFail("Root node is nil.")
            return
        }
        BinaryTreeTests.compareSubscriptIndex(index: 0,
                                              alternativeIndex: BinaryTreeNode<Int>.Child.left.rawValue)
        BinaryTreeTests.compareSubscriptIndex(index: 1,
                                              alternativeIndex: BinaryTreeNode<Int>.Child.right.rawValue)
        BinaryTreeTests.compareSubscriptSymbolic(node: rootNode,
                                                 index: 0,
                                                 symbolicIndex: BinaryTreeNode<String>.Child.left)
        BinaryTreeTests.compareSubscriptSymbolic(node: rootNode,
                                                 index: 1,
                                                 symbolicIndex: BinaryTreeNode<String>.Child.right)
    }
    
    private static func compareSubscriptIndex(index: Int, alternativeIndex: Int) {
        XCTAssert(index == alternativeIndex,
                  "Subscript index \(index) differs from Child.'left or right'.rawValue.")
    }
    
    private static func compareSubscriptSymbolic(node: BinaryTreeNode<String>, index: Int, symbolicIndex: BinaryTreeNode<String>.Child) {
        XCTAssert(node[index] === node[symbolicIndex],
                  "Subscript index \(index) return a different node than Child.'left or right'.")
    }
}
