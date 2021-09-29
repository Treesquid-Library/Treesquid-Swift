import Foundation
import XCTest
@testable import Treesquid

final class MAryTreeTests: XCTestCase {
    static let treeBinaryTree = MAryTree<String>(m: 2)
        .insert(node: MAryTreeNode(value: "root1"))
        .insert(node: MAryTreeNode(value: "l2"))
        .insert(node: MAryTreeNode(value: "r2"))
        .insert(node: MAryTreeNode(value: "ll3"))
        .insert(node: MAryTreeNode(value: "lr3"))
        .insert(node: MAryTreeNode(value: "rl3"))
        .insert(node: MAryTreeNode(value: "rr3"))
    static let treeTernaryTreeM: UInt = 3
    static let treeTernaryTree = MAryTree<Int>(m: treeTernaryTreeM)
        .insert(node: MAryTreeNode(value: 100))
        .insert(node: MAryTreeNode(value: 200))
        .insert(node: MAryTreeNode(value: 201))
        .insert(node: MAryTreeNode(value: 202))
        .insert(node: MAryTreeNode(value: 300))
        .insert(node: MAryTreeNode(value: 301))
        .insert(node: MAryTreeNode(value: 302))
        .insert(node: MAryTreeNode(value: 310))
        .insert(node: MAryTreeNode(value: 311))
        .insert(node: MAryTreeNode(value: 312))
        .insert(node: MAryTreeNode(value: 320))
        .insert(node: MAryTreeNode(value: 321))
        .insert(node: MAryTreeNode(value: 322))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = MAryTree<Any>(m: 1)
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = MAryTree<Any>(m: 1)
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = MAryTree<Any>(m: 1)
        let depth = emptyTree.depth()
        XCTAssert(depth == 0, "Depth is \(depth). Expected: 0")
    }
    
    func testBinaryTreeDepth() {
        let depth = MAryTreeTests.treeBinaryTree.depth()
        XCTAssert(depth == 3, "Depth is \(depth). Expected: 3")
    }
    
    func testBinaryTreeWidth() {
        let width = MAryTreeTests.treeBinaryTree.width()
        XCTAssert(width == 4, "Width is \(width). Expected: 4")
    }
    
    func testBinaryTreeLevels() {
        let levels = MAryTreeTests.treeBinaryTree.levels()
        XCTAssert(levels.count == 3,
                  "Number of levels is \(levels.count). Expected: 3")
        for level in 0..<levels.count {
            let nodesInLevel = levels[level].count
            let expectedNumberOfNodes = Int(pow(2.0, Double(level)))
            XCTAssert(nodesInLevel == expectedNumberOfNodes,
                      "Level \(level + 1) has \(nodesInLevel) nodes. Expected: \(expectedNumberOfNodes)")
        }
    }
    
    func testTernaryTreeLevels() {
        let levels = MAryTreeTests.treeTernaryTree.levels()
        XCTAssert(levels.count == 3,
                  "Number of levels is \(levels.count). Expected: 3")
        for level in 0..<levels.count {
            let nodesInLevel = levels[level].count
            let expectedNumberOfNodes = Int(pow(Double(MAryTreeTests.treeTernaryTreeM), Double(level)))
            XCTAssert(nodesInLevel == expectedNumberOfNodes,
                      "Level \(level + 1) has \(nodesInLevel) nodes. Expected: \(expectedNumberOfNodes)")
            for nodeIndex in 0..<nodesInLevel {
                let node = levels[level][nodeIndex]
                let inLevelAddress = 10 * (nodeIndex / Int(MAryTreeTests.treeTernaryTreeM))
                    + nodeIndex % Int(MAryTreeTests.treeTernaryTreeM)
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
}
