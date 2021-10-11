import Foundation
import XCTest
@testable import Treesquid

final class BTreeTests: XCTestCase {
    // Example from:
    // https://www.programiz.com/dsa/insertion-into-a-b-tree
    // (October 9th, 2021)
    func testProgramizTree() {
        let treeProgramizTree = BTree<Int, Any>(m: 2)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("8", forKey: 8)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("9", forKey: 9)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("10", forKey: 10)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("11", forKey: 11)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("15", forKey: 15)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("20", forKey: 20)
        print(traverse(treeProgramizTree))
        treeProgramizTree.insert("17", forKey: 17)
        print(traverse(treeProgramizTree))
    }
}
