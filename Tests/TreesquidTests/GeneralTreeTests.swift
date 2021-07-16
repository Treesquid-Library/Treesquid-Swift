import Foundation
import XCTest
@testable import Treesquid

final class GeneralTreeTests: XCTestCase {
    static let treeSixLevels = GeneralTree<String>()
        .insert(node: GeneralNode(value: "root1"))
        .insert(node: GeneralNode(value: "(0)2"))
        .insert(node: GeneralNode(value: "(0)(0)3"))
        .insert(node: GeneralNode(value: "(0)(0)(0)4"))
        .insert(node: GeneralNode(value: "(0)(0)(0)(0)5"))
        .insert(node: GeneralNode(value: "(0)(0)(0)(0)(0)6"))
    static let treeTwoLevels = GeneralTree<Int>()
        .insert(node: try! GeneralNode(value: 0)
                    .append(GeneralNode(value: 1))
                    .append(GeneralNode(value: 2))
                    .append(GeneralNode(value: 3)))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = GeneralTree<Any>()
        XCTAssert(emptyTree.isEmpty(),
                  "Empty generic tree is not empty.")
    }
    
    func testEmptyTreeZeroBreadth() {
        let emptyTree = GeneralTree<Any>()
        XCTAssert(emptyTree.breadth() == 0,
                  "Empty generic tree's breadth is not zero.")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = GeneralTree<Any>()
        XCTAssert(emptyTree.depth() == 0,
                  "Empty generic tree's depth is not zero'.")
    }
    
    func testTreeSixLevelsDepth() {
        XCTAssert(GeneralTreeTests.treeSixLevels.depth() == 6,
                  "Generic tree with six levels has incorrect depth.")
    }
    
    func testTreeSixLevelsBreadth() {
        XCTAssert(GeneralTreeTests.treeSixLevels.breadth() == 1,
                  "Generic tree with six levels has incorrect breadth.")
    }
    
    func testTreeSixLevelsLevels() {
        let depth = GeneralTreeTests.treeSixLevels.depth()
        let levels = GeneralTreeTests.treeSixLevels.levels()
        XCTAssert(levels.count == depth,
                  "Tree of six levels reports wrong number of levels.")
        for level in 0..<levels.count {
            XCTAssert(levels[level].count == 1,
                      "Tree of six levels' level has an incorrect number of nodes.")
        }
    }

    func testTreeTwoLevelsDepth() {
        XCTAssert(GeneralTreeTests.treeTwoLevels.depth() == 2,
                  "Generic tree with six levels has incorrect depth.")
    }
    
    func testTreeTwoLevelsBreadth() {
        XCTAssert(GeneralTreeTests.treeTwoLevels.breadth() == 3,
                  "Generic tree with six levels has incorrect breadth.")
    }
    
    func testTreeTwoLevelsCount() {
        XCTAssert(GeneralTreeTests.treeTwoLevels.count() == 4,
                  "Tree of two levels has more (or less) than four nodes.")
    }
    
    func testTreeTwoLevelsLevels() {
        let levels = GeneralTreeTests.treeTwoLevels.levels()
        XCTAssert(levels.count == 2,
                  "Tree of two levels has more (or less) than two levels.")
        XCTAssert(levels[0].count == 1,
                  "Tree of two levels' level has an incorrect number of nodes.")
        XCTAssert(levels[1].count == 3,
                  "Tree of two levels' level has an incorrect number of nodes.")
    }

}
