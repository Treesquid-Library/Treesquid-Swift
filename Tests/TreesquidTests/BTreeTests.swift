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

    func traverseBTreeNode(_ node: BTreeNode<Int, Any>, _ minExpectedKeys: Int, _ level: Int, _ leafLevels: inout [Int]) {
        XCTAssertGreaterThanOrEqual(node.keys.count,
                                    minExpectedKeys,
                                    "Node has \(node.keys.count) keys. Expected at least: \(minExpectedKeys).")
        XCTAssertEqual(node.keys.count,
                       node.values.count,
                       "Node has \(node.values.count) values, but \(node.keys.count) keys. Expected then to be equal.")
        XCTAssertEqual(node.keys,
                       node.keys.sorted(),
                       "Node keys are not sorted: \(node.keys).")
        if node.children.count > 0 {
            // Not a leaf:
            XCTAssertEqual(node.keys.count + 1,
                           node.children.count,
                           "Keys: \(node.keys.count). Children: \(node.children.count). Expected children to be keys + 1.")
            if type(of: node.keys.first!) == String.self {
                for (key, index) in node.keys.enumerated() {
                    XCTAssertEqual("\(key)",
                                   node.values[index] as! String,
                                   "Node key and string-value mismatch at index \(index).")
                }
            }
            for (index, child) in node.children.enumerated() {
                if index < node.keys.count {
                    XCTAssertLessThan(node.children[index]!.keys.last!,
                                      node.keys[index],
                                      "B-tree property violated. Child key too large.")
                } else {
                    XCTAssertGreaterThan(node.children[index]!.keys.first!,
                                         node.keys.last!,
                                         "B-tree property violated. Child key too small.")
                }
                XCTAssertTrue(child?.parent === node, "Child's `parent` is pointing to a different node.")
                traverseBTreeNode(child!, Int(ceil(Float(node.tree!.m) / 2)) - 1, level + 1, &leafLevels)
            }
            return
        }

        // A leaf:
        XCTAssertEqual(node.children.count,
                       0,
                       "Children: \(node.children.count). Expected them to be zero (leaf node).")
        leafLevels.append(level)
        return
    }
    
    // Assumes that the value is "\(key)". Needed to make sure that values
    // are rotated properly alongside their keys.
    func checkBTreeProperties(_ tree: BTree<Int, Any>) {
        guard let root = tree.root else { return }
        var leafLevels: [Int] = []
        traverseBTreeNode(root, 0, 0, &leafLevels)
        let leafLevelsConcur =  Set(leafLevels).count == 1
        XCTAssertTrue(leafLevelsConcur, "Leaves on different levels: \(leafLevels).")
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
    008•--- 010•--- ---◦---
""")
        validate(tree: treeProgramizTree.insert("11", forKey: 11), is: """
            009•---
    008•--- 010•011 ---◦---
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
                            009•--- 017•--- ---◦---
    008•--- 010•--- ---◦--- 015•--- 020•--- ---◦--- ---◦--- ---◦--- ---◦---
""")
    }
    
    // Example from:
    // https://www.programiz.com/dsa/insertion-into-a-b-tree
    // Includes a correction for the third depicted tree, which has two duplicate 45 nodes on the web-site.
    // This is a typo on their end. The leftmost 45 is supposed to be a 35.
    // (November 4th, 2021)
    func testProgramizTreeDeletion() {
        let tree = BTree<Int, Any>(m: 3)
        let node5 = BTreeNode<Int, Any>(keys: [5],
                                        values: ["5"],
                                        children: [],
                                        tree: tree)
        let node15 = BTreeNode<Int, Any>(keys: [15],
                                         values: ["15"],
                                         children: [],
                                         tree: tree)
        let node25_28 = BTreeNode<Int, Any>(keys: [25, 28],
                                            values: ["25", "28"],
                                            children: [],
                                            tree: tree)
        let node31_32 = BTreeNode<Int, Any>(keys: [31, 32],
                                            values: ["31", "32"],
                                            children: [],
                                            tree: tree)
        let node35 = BTreeNode<Int, Any>(keys: [35],
                                         values: ["35"],
                                         children: [],
                                         tree: tree)
        let node45 = BTreeNode<Int, Any>(keys: [45],
                                         values: ["45"],
                                         children: [],
                                         tree: tree)
        let node55 = BTreeNode<Int, Any>(keys: [55],
                                         values: ["55"],
                                         children: [],
                                         tree: tree)
        let node65 = BTreeNode<Int, Any>(keys: [65],
                                         values: ["65"],
                                         children: [],
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
    005•--- 015•--- ---◦--- 025•028 031•032 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 32)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 030•033 050•066
    005•--- 015•--- ---◦--- 025•028 031•--- 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 31)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 028•033 050•066
    005•--- 015•--- ---◦--- 025•--- 030•--- 035•--- 045•--- 055•--- 065•---
""")
        tree.delete(withKey: 30)
        validate(tree: tree, is: """
                                    020•040
                            010•--- 033•--- 050•066
    005•--- 015•--- ---◦--- 025•028 035•--- ---◦--- 045•--- 055•--- 065•---
""")
    }

    // Example from:
    // https://www.cpp.edu/~ftang/courses/CS241/notes/b-tree.htm
    // (December 5th, 2021)
    func testCPPTree() {
        let treeCPPTree = BTree<Int, Any>(m: 3)
        validate(tree: treeCPPTree.insert("4", forKey: 4), is: """
    004•---
""")
        validate(tree: treeCPPTree.insert("6", forKey: 6), is: """
    004•006
""")
        validate(tree: treeCPPTree.insert("12", forKey: 12), is: """
            006•---
    004•--- 012•--- ---◦---
""")
        validate(tree: treeCPPTree.insert("17", forKey: 17), is: """
            006•---
    004•--- 012•017 ---◦---
""")
        validate(tree:         treeCPPTree.insert("19", forKey: 19), is: """
            006•017
    004•--- 012•--- 019•---
""")
        validate(tree: treeCPPTree.insert("22", forKey: 22), is: """
            006•017
    004•--- 012•--- 019•022
""")
        validate(tree: treeCPPTree.insert("18", forKey: 18), is: """
                                    017•---
                            006•--- 019•--- ---◦---
    004•--- 012•--- ---◦--- 018•--- 022•--- ---◦--- ---◦--- ---◦--- ---◦---
""")
    }
    
    func testRandomTesting() {
        for m in [3, 4, 5, 11, 12] {
            for seed in [8271, 99001873, 3, 12349] {
                srand48(seed)
                for nodes in [1, 2, 3, 4, 5, 6, 7, 100, 2000] {
                    var availableKeys = Array(0..<nodes)
                    var insert_keys: [Int] = []
                    var delete_keys: [Int] = []
                    while !availableKeys.isEmpty {
                        let key = availableKeys.remove(at: Int(drand48() * Double(availableKeys.count - 1)))
                        insert_keys.append(key)
                        delete_keys.insert(key, at: Int(drand48() * Double(delete_keys.count)))
                    }
                    let tree = BTree<Int, Any>(m: m)
                    for key in insert_keys {
                        tree.insert("\(key)", forKey: key)
                        checkBTreeProperties(tree)
                    }
                    for key in delete_keys {
                        tree.delete(withKey: key)
                        checkBTreeProperties(tree)
                    }
                }
            }
        }
    }
}
