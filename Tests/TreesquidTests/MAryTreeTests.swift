import Foundation
import XCTest
@testable import Treesquid

final class MAryTreeTests: XCTestCase {
    static let treeBinaryTree = MAryTree<String, Any>(m: 2)
        .insert(node: MAryTreeNode(key: "root1"))
        .insert(node: MAryTreeNode(key: "l2"))
        .insert(node: MAryTreeNode(key: "r2"))
        .insert(node: MAryTreeNode(key: "ll3"))
        .insert(node: MAryTreeNode(key: "lr3"))
        .insert(node: MAryTreeNode(key: "rl3"))
        .insert(node: MAryTreeNode(key: "rr3"))
    static let treeTernaryTreeM: UInt = 3
    static let treeTernaryTree = MAryTree<Int, Any>(m: treeTernaryTreeM)
        .insert(node: MAryTreeNode(key: 100))
        .insert(node: MAryTreeNode(key: 200))
        .insert(node: MAryTreeNode(key: 201))
        .insert(node: MAryTreeNode(key: 202))
        .insert(node: MAryTreeNode(key: 300))
        .insert(node: MAryTreeNode(key: 301))
        .insert(node: MAryTreeNode(key: 302))
        .insert(node: MAryTreeNode(key: 310))
        .insert(node: MAryTreeNode(key: 311))
        .insert(node: MAryTreeNode(key: 312))
        .insert(node: MAryTreeNode(key: 320))
        .insert(node: MAryTreeNode(key: 321))
        .insert(node: MAryTreeNode(key: 322))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = MAryTree<Any, Any>(m: 1)
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = MAryTree<Any, Any>(m: 1)
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = MAryTree<Any, Any>(m: 1)
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
}
