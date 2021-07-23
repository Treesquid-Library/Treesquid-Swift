import Foundation
import XCTest
@testable import Treesquid

final class GeneralTreeTests: XCTestCase {
    static let treeTwoLevelsTreeInsert = GeneralTree<String, Any>()
        .insert(node: GeneralTreeNode(key: "root1"))
        .insert(node: GeneralTreeNode(key: "(0)2"))
        .insert(node: GeneralTreeNode(key: "(0)(0)3"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)4"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)(0)5"))
        .insert(node: GeneralTreeNode(key: "(0)(0)(0)(0)(0)6"))
    static let treeTwoLevelsNodeInsert = GeneralTree<Int, Any>()
        .insert(node: try! GeneralTreeNode(key: 0)
                    .append(GeneralTreeNode(key: 1))
                    .append(GeneralTreeNode(key: 2))
                    .append(GeneralTreeNode(key: 3)))
    static let nodeDegree3Count3 =  try! GeneralTreeNode<String, Any>(key: "root")
        .append(GeneralTreeNode(key: "1"))
        .append(GeneralTreeNode(key: "2"))
        .append(GeneralTreeNode(key: "3"))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = GeneralTree<Any, Any>()
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = GeneralTree<Any, Any>()
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = GeneralTree<Any, Any>()
        let depth = emptyTree.depth()
        XCTAssert(depth == 0, "Depth is \(depth). Expected: 0")
    }
    
    func testTreeTwoLevelsTreeInsertDepth() {
        let depth = GeneralTreeTests.treeTwoLevelsTreeInsert.depth()
        XCTAssert(depth == 2, "Depth is \(depth). Expected: 2")
    }
    
    func testTreeTwoLevelsTreeInsertWidth() {
        let width = GeneralTreeTests.treeTwoLevelsTreeInsert.width()
        XCTAssert(width == 5,
                  "Width is \(width). Expected: 5")
    }
    
    func testTreeTwoLevelsTreeInsertLevels() {
        let depth = GeneralTreeTests.treeTwoLevelsTreeInsert.depth()
        let levels = GeneralTreeTests.treeTwoLevelsTreeInsert.levels()
        XCTAssert(levels.count == depth,
                  "Levels/depth are \(levels.count)\(depth). Expected them to be equal.")
        let expectedNodes = [ 1, 5 ]
        if levels.count != expectedNodes.count {
            XCTFail("There are \(levels.count) levels. Expected: \(expectedNodes.count)")
            return
        }
        for level in 0..<levels.count {
            let numberOfNodes = levels[level].count
            XCTAssert(numberOfNodes == expectedNodes[level],
                      "Level \(level + 1) has \(numberOfNodes) nodes. Expected: \(expectedNodes[level])")
        }
    }

    func testTreeTwoLevelsNodeInsertDepth() {
        let depth = GeneralTreeTests.treeTwoLevelsNodeInsert.depth()
        XCTAssert(depth == 2, "Depth is \(depth). Expected: 2")
    }
    
    func testTreeTwoLevelsNodeInsertWidth() {
        let width = GeneralTreeTests.treeTwoLevelsNodeInsert.width()
        XCTAssert(width == 3, "Width is \(width). Expected: 3")
    }
    
    func testTreeTwoLevelsNodeInsertCount() {
        let numberOfNodes = GeneralTreeTests.treeTwoLevelsNodeInsert.count()
        XCTAssert(numberOfNodes == 4,
                  "Tree has \(numberOfNodes) nodes. Expected: 4")
    }
    
    func testTreeTwoLevelsNodeInsertLevels() {
        let levels = GeneralTreeTests.treeTwoLevelsNodeInsert.levels()
        XCTAssert(levels.count == 2,
                  "Tree has \(levels.count) levels. Expected: 2")
        XCTAssert(levels[0].count == 1,
                  "Level 1 has \(levels[0].count) nodes. Expected: 1")
        XCTAssert(levels[1].count == 3,
                  "Level 2 has \(levels[1].count) nodes. Expected: 3")
    }

    func testNodeDegreeAndCountMatch() {
        let degree = GeneralTreeTests.nodeDegree3Count3.degree()
        let capacity = GeneralTreeTests.nodeDegree3Count3.capacity()
        XCTAssert(degree == 3,
                  "Degree is \(degree). Expected: 3")
        XCTAssert(capacity == 3,
                  "Capacity is \(capacity). Expected: 3")
    }
    
    func testNodeDegree2Remove() {
        let nodeDegree2Remove =  try! GeneralTreeNode<String, Any>(key: "root")
            .append(GeneralTreeNode(key: "1"))
            .append(GeneralTreeNode(key: "2"))
        nodeDegree2Remove[0] = nil
        
        let degree = nodeDegree2Remove.degree()
        let capacity = nodeDegree2Remove.capacity()
        XCTAssert(degree == 1,
                  "Degree is \(degree). Expected: 1")
        XCTAssert(capacity == 1,
                  "Capacity is \(capacity). Expected: 1")
    }
}
