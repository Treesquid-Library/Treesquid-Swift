import Foundation
import XCTest
@testable import Treesquid

final class GeneralTreeTests: XCTestCase {
    static let treeTwoLevelsTreeInsert = GeneralTree<Int>()
        .insert(node: GeneralTreeNode(value: 100))
        .insert(node: GeneralTreeNode(value: 200))
        .insert(node: GeneralTreeNode(value: 201))
        .insert(node: GeneralTreeNode(value: 202))
        .insert(node: GeneralTreeNode(value: 203))
        .insert(node: GeneralTreeNode(value: 204))
    static let treeTwoLevelsNodeInsert = GeneralTree<String>()
        .insert(node: try! GeneralTreeNode(value: "n0")
                    .append(GeneralTreeNode(value: "n1"))
                    .append(GeneralTreeNode(value: "n2"))
                    .append(GeneralTreeNode(value: "n3")))
    static let nodeDegree3Count3 =  try! GeneralTreeNode<String>(value: "root")
        .append(GeneralTreeNode(value: "1"))
        .append(GeneralTreeNode(value: "2"))
        .append(GeneralTreeNode(value: "3"))
    
    func testEmptyTreeIsEmpty() {
        let emptyTree = GeneralTree<Any>()
        XCTAssert(emptyTree.isEmpty(), "Tree is not empty.")
    }
    
    func testEmptyTreeZeroWidth() {
        let emptyTree = GeneralTree<Any>()
        let width = emptyTree.width()
        XCTAssert(width == 0, "Width is \(width). Expected: 0")
    }
    
    func testEmptyTreeZeroDepth() {
        let emptyTree = GeneralTree<Any>()
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
            // Note: For general trees, this only works in this specific
            //       case -- a general tree only having level 2 nodes. This
            //       is fundamentally different from the binary and m-are
            //       test cases.
            for nodeIndex in 0..<numberOfNodes {
                let node = levels[level][nodeIndex]
                let inLevelAddress = 10 * (nodeIndex / numberOfNodes) + nodeIndex % numberOfNodes
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
    
    func testTreeTwoLevelsNodeKeys() {
        guard let rootNode = GeneralTreeTests.treeTwoLevelsNodeInsert.root else {
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
        let nodeDegree2Remove =  try! GeneralTreeNode<String>(value: "root")
            .append(GeneralTreeNode(value: "1"))
            .append(GeneralTreeNode(value: "2"))
        nodeDegree2Remove[0] = nil
        
        let degree = nodeDegree2Remove.degree()
        let capacity = nodeDegree2Remove.capacity()
        XCTAssert(degree == 1,
                  "Degree is \(degree). Expected: 1")
        XCTAssert(capacity == 1,
                  "Capacity is \(capacity). Expected: 1")
    }
}
