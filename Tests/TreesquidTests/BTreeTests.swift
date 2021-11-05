import Foundation
import XCTest
@testable import Treesquid

final class BTreeTests: XCTestCase {
    //
    // Helper functions for testing:
    //
        
    func validate(tree: BTree<Int, Any>, is reference: String) {
        XCTAssert(traverse(tree) == reference, "Trees differ. Expected:\n\(reference)")
    }

    //
    // Unit tests:
    //
    
    // Example from:
    // https://www.programiz.com/dsa/insertion-into-a-b-tree
    // (October 9th, 2021)
    func testProgramizTree() {
        let treeProgramizTree = BTree<Int, Any>(m: 3)
        validate(tree: treeProgramizTree.insert("8", forKey: 8), is: """
    008•---
""")
        validate(tree: treeProgramizTree.insert("9", forKey: 9), is: """
    008•009
""")
        validate(tree: treeProgramizTree.insert("10", forKey: 10), is: """
            009•---
    008•--- 010•--- ---•---
""")
        validate(tree: treeProgramizTree.insert("11", forKey: 11), is: """
            009•---
    008•--- 010•011 ---•---
""")
        validate(tree: treeProgramizTree.insert("15", forKey: 15), is: """
            009•011
    008•--- 010•--- 015•---
""")
        validate(tree: treeProgramizTree.insert("20", forKey: 20), is: """
            009•011
    008•--- 010•--- 015•020
""")
        validate(tree: treeProgramizTree.insert("17", forKey: 17), is: """
                                    011•---
                            009•--- 017•--- ---•---
    008•--- 010•--- ---•--- 015•--- 020•--- ---•--- ---•--- ---•--- ---•---
""")
    }
    
    // Example from:
    // https://www.programiz.com/dsa/insertion-into-a-b-tree
    // Includes a correction for the third depicted tree, which has two duplicate 45 nodes on the web-site.
    // This is a typo on their end. The leftmost 45 is supposed to be a 35.
    // (November 4th, 2021)
    func testNodeMerge() {
        let tree = BTree<Int, Any>(m: 3)
        let node5 = BTreeNode<Int, Any>(keys: [5],
                                        values: ["5"],
                                        children: [nil, nil],
                                        tree: tree)
        let node15 = BTreeNode<Int, Any>(keys: [15],
                                         values: ["15"],
                                         children: [nil, nil],
                                         tree: tree)
        let node25_28 = BTreeNode<Int, Any>(keys: [25, 28],
                                            values: ["25", "28"],
                                            children: [nil, nil, nil],
                                            tree: tree)
        let node31_32 = BTreeNode<Int, Any>(keys: [31, 32],
                                            values: ["31", "32"],
                                            children: [nil, nil, nil],
                                            tree: tree)
        let node35 = BTreeNode<Int, Any>(keys: [35],
                                         values: ["35"],
                                         children: [nil, nil],
                                         tree: tree)
        let node45 = BTreeNode<Int, Any>(keys: [45],
                                         values: ["45"],
                                         children: [nil, nil],
                                         tree: tree)
        let node55 = BTreeNode<Int, Any>(keys: [55],
                                         values: ["55"],
                                         children: [nil, nil],
                                         tree: tree)
        let node65 = BTreeNode<Int, Any>(keys: [65],
                                         values: ["65"],
                                         children: [nil, nil],
                                         tree: tree)
        let node10 = BTreeNode<Int, Any>(keys: [10],
                                         values: ["10"],
                                         children: [node5, node15],
                                         tree: tree)
        let node30_33 = BTreeNode<Int, Any>(keys: [30, 33],
                                            values: ["30", "33"],
                                            children: [node25_28, node31_32, node35],
                                            tree: tree)
        let node50_60 = BTreeNode<Int, Any>(keys: [50, 66],
                                            values: ["50", "66"],
                                            children: [node45, node55, node65],
                                            tree: tree)
        let node20_40 = BTreeNode<Int, Any>(keys: [20, 40],
                                            values: ["20", "40"],
                                            children: [node10, node30_33, node50_60],
                                            tree: tree)
        tree.root = node20_40
        validate(tree: tree, is: """
                                    020•040
                            010•--- 030•033 050•066
    005•--- 015•--- ---•--- 025•028 031•032 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 32)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 030•033 050•066
    005•--- 015•--- ---•--- 025•028 031•--- 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 31)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 028•033 050•066
    005•--- 015•--- ---•--- 025•--- 030•--- 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 30)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 033•--- 050•066
    005•--- 015•--- ---•--- 025•028 035•--- ---•--- 045•--- 055•--- 065•---
""")
    }
}
