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
    
    func testNodeMerge() {
        let tree = BTree<Int, Any>(m: 3)
            .insert("1", forKey: 1)
        print(traverse_(tree))
        tree.insert("15", forKey: 15)
        print(traverse_(tree))
        tree.insert("3", forKey: 3)
        print(traverse_(tree))
        tree.insert("14", forKey: 14)
        print(traverse_(tree))
        tree.insert("5", forKey: 5)
        print(traverse_(tree))
        tree.insert("13", forKey: 13)
        print(traverse_(tree))
        tree.insert("7", forKey: 7)
        print(traverse_(tree))
        tree.insert("8", forKey: 8)
        print(traverse_(tree))
        tree.insert("9", forKey: 9)
        print(traverse_(tree))
        tree.insert("10", forKey: 10)
        print(traverse_(tree))
        tree.insert("11", forKey: 11)
        print(traverse_(tree))
        tree.insert("12", forKey: 12)
        print(traverse_(tree))
        tree.insert("6", forKey: 6)
        print(traverse_(tree))
        tree.insert("4", forKey: 4)
        print(traverse_(tree))
        tree.insert("2", forKey: 2)
        print(traverse_(tree))
        tree.delete(withKey: 10) // leaf
        print(traverse_(tree))
        tree.delete(withKey: 14) // internal
        print(traverse_(tree))
    }
    
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
}
