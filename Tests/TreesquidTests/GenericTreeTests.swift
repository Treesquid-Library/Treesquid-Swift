import Foundation
import XCTest
@testable import Treesquid

final class GenericTreeTests: XCTestCase {
    static let treeSixLevels = GenericTree()
        .insert(node: TreeNode(value: "root1"))
        .insert(node: TreeNode(value: "(0)2"))
        .insert(node: TreeNode(value: "(0)(0)3"))
        .insert(node: TreeNode(value: "(0)(0)(0)4"))
        .insert(node: TreeNode(value: "(0)(0)(0)(0)5"))
        .insert(node: TreeNode(value: "(0)(0)(0)(0)(0)6"))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = GenericTree<Any>()
        XCTAssert(emptyTree.isEmpty(),
                  "Empty generic tree is not empty.")
    }
    
    func testEmptyTreeZeroBreadth() {
        let emptyTree = GenericTree<Any>()
        XCTAssert(emptyTree.breadth() == 0,
                  "Empty generic tree's breadth is not zero.")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = GenericTree<Any>()
        XCTAssert(emptyTree.depth() == 0,
                  "Empty generic tree's depth is not zero'.")
    }
    
    func testTreeSixLevelsDepth() {
        XCTAssert(GenericTreeTests.treeSixLevels.depth() == 6,
                  "Generic tree with six levels has incorrect depth.")
    }
    
    func testTreeSixLevelsBreadth() {
        XCTAssert(GenericTreeTests.treeSixLevels.breadth() == 1,
                  "Generic tree with six levels has incorrect breadth.")
    }
    
    func testTreeSixLevelsLevels() {
        let depth = GenericTreeTests.treeSixLevels.depth()
        let levels = GenericTreeTests.treeSixLevels.levels()
        XCTAssert(levels.count == depth,
                  "Tree of six levels reports wrong number of levels.")
        for level in 0..<levels.count {
            XCTAssert(levels[level].count == 1,
                      "Tree of six levels' level has an incorrect number of nodes.")
        }
    }
}
