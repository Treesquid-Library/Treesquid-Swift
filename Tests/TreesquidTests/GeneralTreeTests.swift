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
    
    func testTreeSixLevelsDepth() {
        let depth = GeneralTreeTests.treeSixLevels.depth()
        XCTAssert(depth == 6, "Depth is \(depth). Expected: 6")
    }
    
    func testTreeSixLevelsWidth() {
        let width = GeneralTreeTests.treeSixLevels.width()
        XCTAssert(width == 1,
                  "Width is \(width). Expected: 1")
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
    
    func testTreeTwoLevelsWidth() {
        let width = GeneralTreeTests.treeTwoLevels.width()
        XCTAssert(width == 3, "Width is \(width). Expected: 3")
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
