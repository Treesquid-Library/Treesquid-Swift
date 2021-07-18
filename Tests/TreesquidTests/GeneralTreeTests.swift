import Foundation
import XCTest
@testable import Treesquid

final class GeneralTreeTests: XCTestCase {
    static let treeSixLevels = GeneralTree<String, Any>()
        .insert(node: GeneralTreeNode(key: "root1"))
        .insert(node: GeneralTreeNode(key: "(0)2"))
        .insert(node: GeneralTreeNode(key: "(0)(0)3"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)4"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)(0)5"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)(0)(0)6"))
    static let treeTwoLevels = GeneralTree<Int, Any>()
        .insert(node: try! GeneralTreeNode(key: 0)
                    .append(GeneralTreeNode(key: 1))
                    .append(GeneralTreeNode(key: 2))
                    .append(GeneralTreeNode(key: 3)))
    static let nodeArity3Count3 =  try! GeneralTreeNode<String, Any>(key: "root")
        .append(GeneralTreeNode(key: "1"))
        .append(GeneralTreeNode(key: "2"))
        .append(GeneralTreeNode(key: "3"))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = GeneralTree<Any, Any>()
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroBreadth() {
        let emptyTree = GeneralTree<Any, Any>()
        let breadth = emptyTree.breadth()
        XCTAssert(breadth == 0, "Breadth is \(breadth). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = GeneralTree<Any, Any>()
        let depth = emptyTree.depth()
        XCTAssert(depth == 0, "Depth is \(depth). Expected: 0")
    }
    
    func testTreeSixLevelsDepth() {
        let depth = GeneralTreeTests.treeSixLevels.depth()
        XCTAssert(depth == 6, "Depth is \(depth). Expected: 6")
    }
    
    func testTreeSixLevelsBreadth() {
        let breadth = GeneralTreeTests.treeSixLevels.breadth()
        XCTAssert(breadth == 1,
                  "Breadth is \(breadth). Expected: 1")
    }
    
    func testTreeSixLevelsLevels() {
        let depth = GeneralTreeTests.treeSixLevels.depth()
        let levels = GeneralTreeTests.treeSixLevels.levels()
        XCTAssert(levels.count == depth,
                  "Levels/depth are \(levels.count)\(depth). Expected them to be equal.")
        for level in 0..<levels.count {
            let numberOfNodes = levels[level].count
            XCTAssert(numberOfNodes == 1,
                      "Level \(level + 1) has \(numberOfNodes) nodes. Expected: 1")
        }
    }

    func testTreeTwoLevelsDepth() {
        let depth = GeneralTreeTests.treeTwoLevels.depth()
        XCTAssert(depth == 2, "Depth is \(depth). Expected: 2")
    }
    
    func testTreeTwoLevelsBreadth() {
        let breadth = GeneralTreeTests.treeTwoLevels.breadth()
        XCTAssert(breadth == 3, "Breadth is \(breadth). Expected: 3")
    }
    
    func testTreeTwoLevelsCount() {
        let numberOfNodes = GeneralTreeTests.treeTwoLevels.count()
        XCTAssert(numberOfNodes == 4,
                  "Tree has \(numberOfNodes) nodes. Expected: 4")
    }
    
    func testTreeTwoLevelsLevels() {
        let levels = GeneralTreeTests.treeTwoLevels.levels()
        XCTAssert(levels.count == 2,
                  "Tree has \(levels.count) levels. Expected: 2")
        XCTAssert(levels[0].count == 1,
                  "Level 1 has \(levels[0].count) nodes. Expected: 1")
        XCTAssert(levels[1].count == 3,
                  "Level 2 has \(levels[1].count) nodes. Expected: 3")
    }

    func testNodeArityAndCountMatch() {
        let arity = GeneralTreeTests.nodeArity3Count3.arity()
        let numberOfNodes = GeneralTreeTests.nodeArity3Count3.count()
        XCTAssert(GeneralTreeTests.nodeArity3Count3.arity() == 3,
                  "Arity is \(arity). Expected: 3")
        XCTAssert(GeneralTreeTests.nodeArity3Count3.count() == 3,
                  "Number of child nodes is \(numberOfNodes). Expected: 3")
    }
    
    func testNodeArity2Remove() {
        let nodeArity2Remove =  try! GeneralTreeNode<String, Any>(key: "root")
            .append(GeneralTreeNode(key: "1"))
            .append(GeneralTreeNode(key: "2"))
        nodeArity2Remove[0] = nil
        
        let arity = nodeArity2Remove.arity()
        let count = nodeArity2Remove.count()
        XCTAssert(arity == 1,
                  "Arity is \(arity). Expected: 1")
        XCTAssert(count == 1,
                  "Number of child nodes is \(count). Expected: 1")
    }
}
