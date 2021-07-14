import Foundation
import XCTest
@testable import Treesquid

final class GenericTreeTests: XCTestCase {
    static let treeSixLevels = GenericTree()
        .append(node: TreeNode(value: "root1"))
        .append(node: TreeNode(value: "(0)2"))
        .append(node: TreeNode(value: "(0)(0)3"))
        .append(node: TreeNode(value: "(0)(0)(0)4"))
        .append(node: TreeNode(value: "(0)(0)(0)(0)5"))
        .append(node: TreeNode(value: "(0)(0)(0)(0)(0)6"))
    
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
    
    func testTreeTwoLevelsDepth() {
        XCTAssert(GenericTreeTests.treeSixLevels.depth() == 6,
                  "Generic tree with six levels has incorrect depth.")
    }
    
    func testTreeTwoLevelsBreadth() {
        XCTAssert(GenericTreeTests.treeSixLevels.breadth() == 1,
                  "Generic tree with six levels has incorrect breadth.")
    }
    
    /*
    func testFullTreeTwoLevelsLevels() {
        let levels = GenericTreeTests.treeTwoLevels.levels()
        XCTAssert(levels.count == 3,
                  "Full tree of three levels reports wrong number of levels.")
        for level in 0..<levels.count {
            XCTAssert(levels[level].count == Int(pow(2.0, Double(level))),
                      "Full tree of three levels' level has an incorrect number of nodes.")
        }
    }
     */
}
