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
}
