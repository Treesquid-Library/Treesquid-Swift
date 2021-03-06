import Foundation
import XCTest
@testable import Treesquid

final class RedBlackTreeTests: XCTestCase {
    // Example from:
    // http://www.btechsmartclass.com/data_structures/red-black-trees.html
    // (July 30th, 2021)
    static let treeBtechsmartclass = RedBlackTree<Int, Any>()
        .insert(node: RedBlackTreeNode(key: 8))
        .insert(node: RedBlackTreeNode(key: 18))
        .insert(node: RedBlackTreeNode(key: 5))
        .insert(node: RedBlackTreeNode(key: 15))
        .insert(node: RedBlackTreeNode(key: 17))
        .insert(node: RedBlackTreeNode(key: 25))
        .insert(node: RedBlackTreeNode(key: 40))
        .insert(node: RedBlackTreeNode(key: 80))

    //
    // Helper functions for testing:
    //
        
    func validate(tree: RedBlackTree<Int, Any>, is reference: String) {
        XCTAssert(traverse(tree) == reference, "Trees differ. Expected:\n\(reference)")
    }

    private func traverseAndCountBlackNodes(node: RedBlackTreeNode<Int, Any>?, seenBlackNodes: Int, blackNodesOnPaths: inout [Int]) {
        var seenBlackNodes = seenBlackNodes
        if node == nil || !node!.red {
            seenBlackNodes += 1
            if node == nil {
                blackNodesOnPaths.append(seenBlackNodes)
                return
            }
        }
        traverseAndCountBlackNodes(node: node!.children[0], seenBlackNodes: seenBlackNodes, blackNodesOnPaths: &blackNodesOnPaths)
        traverseAndCountBlackNodes(node: node!.children[1], seenBlackNodes: seenBlackNodes, blackNodesOnPaths: &blackNodesOnPaths)
    }
    
    func hasRedBlackTreeProperties(tree: RedBlackTree<Int, Any>) {
        guard let root = tree.root else { return }
        var blackNodesRootToNilNodes: [Int] = []
        traverseAndCountBlackNodes(node: root, seenBlackNodes: 0, blackNodesOnPaths: &blackNodesRootToNilNodes)
        if blackNodesRootToNilNodes.count == 0 { return }
        let sample = blackNodesRootToNilNodes.first
        XCTAssertEqual(blackNodesRootToNilNodes.filter { $0 != sample }.count,
                       0,
                       "The number of black nodes from root to nil-nodes varies.")
    }
    
    //
    // Unit tests:
    //
    
    // Example from:
    // https://60devs.com/a/data-structures/red-black-tree/
    // (August 4th, 2021)
    func test60devsTree() {
        let tree60devs = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 8))
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 8)), is: """
    08??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 17)), is: """
      08??????
    --- 17??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 1)), is: """
      08??????
    01?????? 17??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 11)), is: """
          08??????
        01?????? 17??????
    --- --- 11?????? ---
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 15)), is: """
          08??????
        01?????? 15??????
    --- --- 11?????? 17??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 25)), is: """
                  08??????
                01?????? 15??????
            --- --- 11?????? 17??????
    --- --- --- --- --- --- --- 25??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 6)), is: """
                  08??????
                01?????? 15??????
            --- 06?????? 11?????? 17??????
    --- --- --- --- --- --- --- 25??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 22)), is: """
                  08??????
                01?????? 15??????
            --- 06?????? 11?????? 22??????
    --- --- --- --- --- --- 17?????? 25??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 27)), is: """
                  15??????
                08?????? 22??????
            01?????? 11?????? 17?????? 25??????
    --- 06?????? --- --- --- --- --- 27??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 5)), is: """
                  15??????
                08?????? 22??????
            05?????? 11?????? 17?????? 25??????
    01?????? 06?????? --- --- --- --- --- 27??????
""")
        validate(tree: tree60devs.insert(node: RedBlackTreeNode(key: 13)), is: """
                  15??????
                08?????? 22??????
            05?????? 11?????? 17?????? 25??????
    01?????? 06?????? --- 13?????? --- --- --- 27??????
""")
    }
    
    // Example from:
    // http://software.ucv.ro/~mburicea/lab8ASD.pdf
    // (July 31st, 2021)
    func testUCVmburiceaTree() {
        // From "1.2.4 Sample operations in a Red-Black Tree" with the
        // exception that Treesquid trees have a red root.
        let treeUCVmburicea = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 15))
            .insert(node: RedBlackTreeNode(key: 0))
            .insert(node: RedBlackTreeNode(key: 20))
        validate(tree: treeUCVmburicea.insert(node: RedBlackTreeNode(key: 3)), is: """
          15??????
        00?????? 20??????
    --- 03?????? --- ---
""")
        validate(tree: treeUCVmburicea.insert(node: RedBlackTreeNode(key: 13)), is: """
          15??????
        03?????? 20??????
    00?????? 13?????? --- ---
""")
        validate(tree: treeUCVmburicea.insert(node: RedBlackTreeNode(key: 14)), is: """
                  15??????
                03?????? 20??????
            00?????? 13?????? --- ---
    --- --- --- 14?????? --- --- --- ---
""")
        validate(tree: treeUCVmburicea.insert(node: RedBlackTreeNode(key: 45)), is: """
                  15??????
                03?????? 20??????
            00?????? 13?????? --- 45??????
    --- --- --- 14?????? --- --- --- ---
""")
        validate(tree: treeUCVmburicea.insert(node: RedBlackTreeNode(key: 34)), is: """
                  15??????
                03?????? 34??????
            00?????? 13?????? 20?????? 45??????
    --- --- --- 14?????? --- --- --- ---
""")
    }
    
    // Example from:
    // http://homepages.math.uic.edu/~jan/mcs360/red_black_trees.pdf
    // (July 31st, 2021)
    func testA() {
        let treeUICjan = RedBlackTree<Int, Any>()
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 48)), is: """
    48??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 84)), is: """
      48??????
    --- 84??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 43)), is: """
      48??????
    43?????? 84??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 91)), is: """
          48??????
        43?????? 84??????
    --- --- --- 91??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 38)), is: """
          48??????
        43?????? 84??????
    38?????? --- --- 91??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 79)), is: """
          48??????
        43?????? 84??????
    38?????? --- 79?????? 91??????
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 63)), is: """
                  48??????
                43?????? 84??????
            38?????? --- 79?????? 91??????
    --- --- --- --- 63?????? --- --- ---
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 59)), is: """
                  48??????
                43?????? 84??????
            38?????? --- 63?????? 91??????
    --- --- --- --- 59?????? 79?????? --- ---
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 49)), is: """
                  63??????
                48?????? 84??????
            43?????? 59?????? 79?????? 91??????
    38?????? --- 49?????? --- --- --- --- ---
""")
        validate(tree: treeUICjan.insert(node: RedBlackTreeNode(key: 98)), is: """
                  63??????
                48?????? 84??????
            43?????? 59?????? 79?????? 91??????
    38?????? --- 49?????? --- --- --- --- 98??????
""")
    }

    func testBtechsmartclassTree() {
        validate(tree: RedBlackTreeTests.treeBtechsmartclass, is: """
                  17??????
                08?????? 25??????
            05?????? 15?????? 18?????? 40??????
    --- --- --- --- --- --- --- 80??????
""")
    }
    
    // Example from:
    // https://www.csee.umbc.edu/courses/undergraduate/341/spring04/hood/notes/red_black/
    // (August 2nd, 2021)
    func testUMBCTree() {
        let treeUMBCTree = RedBlackTree<Int, Any>()
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 2)), is: """
    02??????
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 1)), is: """
      02??????
    01?????? ---
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 4)), is: """
      02??????
    01?????? 04??????
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 5)), is: """
          02??????
        01?????? 04??????
    --- --- --- 05??????
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 9)), is: """
          02??????
        01?????? 05??????
    --- --- 04?????? 09??????
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 3)), is: """
                  02??????
                01?????? 05??????
            --- --- 04?????? 09??????
    --- --- --- --- 03?????? --- --- ---
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 6)), is: """
                  02??????
                01?????? 05??????
            --- --- 04?????? 09??????
    --- --- --- --- 03?????? --- 06?????? ---
""")
        validate(tree: treeUMBCTree.insert(node: RedBlackTreeNode(key: 7)), is: """
                  02??????
                01?????? 05??????
            --- --- 04?????? 07??????
    --- --- --- --- 03?????? --- 06?????? 09??????
""")
    }
    
    func testSingleRootNodeDeletion() {
        let treeSingleRootNode = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 5))
        treeSingleRootNode.delete(key: 5)
        XCTAssert(treeSingleRootNode.isEmpty() == true, "Tree is not empty.")
    }
    
    // Example from:
    // https://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/
    // (August 24th, 2021)
    func testRedLeafDeletion() {
        let treeRedLeaf = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 30))
            .insert(node: RedBlackTreeNode(key: 20))
            .insert(node: RedBlackTreeNode(key: 40))
            .insert(node: RedBlackTreeNode(key: 10))
        validate(tree: treeRedLeaf, is: """
          30??????
        20?????? 40??????
    10?????? --- --- ---
""")
        treeRedLeaf.delete(key: 10)
        validate(tree: treeRedLeaf, is: """
      30??????
    20?????? 40??????
""")
    }
    
    // Example from:
    // https://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/
    // (August 24th, 2021)
    func testBlackLeafDeletion() {
        let treeRedLeaf = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 30))
            .insert(node: RedBlackTreeNode(key: 20))
            .insert(node: RedBlackTreeNode(key: 40))
            .insert(node: RedBlackTreeNode(key: 50))
        validate(tree: treeRedLeaf, is: """
          30??????
        20?????? 40??????
    --- --- --- 50??????
""")
        treeRedLeaf.delete(key: 20)
        validate(tree: treeRedLeaf, is: """
      40??????
    30?????? 50??????
""")
    }
    
    // Example from:
    // https://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/
    // (August 24th, 2021)
    func testBlackSiblingWithRedChildDeletion() {
        let treeSibling = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 30))
            .insert(node: RedBlackTreeNode(key: 20))
            .insert(node: RedBlackTreeNode(key: 40))
            .insert(node: RedBlackTreeNode(key: 35))
            .insert(node: RedBlackTreeNode(key: 50))
        validate(tree: treeSibling, is: """
          30??????
        20?????? 40??????
    --- --- 35?????? 50??????
""")
        treeSibling.delete(key: 20)
        validate(tree: treeSibling, is: """
          40??????
        30?????? 50??????
    --- 35?????? --- ---
""")
    }
    
    // Example from:
    // https://www.csee.umbc.edu/courses/undergraduate/341/spring04/Lectures/RedBlack/redblack.pdf
    // (August 24th, 2021)
    func testUMBCTreeBottomUpDeletionExample1() {
        let treeUMBCTreeExample1 = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 65))
            .insert(node: RedBlackTreeNode(key: 50))
            .insert(node: RedBlackTreeNode(key: 80))
            .insert(node: RedBlackTreeNode(key: 10))
            .insert(node: RedBlackTreeNode(key: 60))
            .insert(node: RedBlackTreeNode(key: 70))
            .insert(node: RedBlackTreeNode(key: 90))
            .insert(node: RedBlackTreeNode(key: 62))
        validate(tree: treeUMBCTreeExample1, is: """
                  65??????
                50?????? 80??????
            10?????? 60?????? 70?????? 90??????
    --- --- --- 62?????? --- --- --- ---
""")
        treeUMBCTreeExample1.delete(key: 90)
        validate(tree: treeUMBCTreeExample1, is: """
                  65??????
                50?????? 80??????
            10?????? 60?????? 70?????? ---
    --- --- --- 62?????? --- --- --- ---
""")
    }
    
    // Example from:
    // https://www.csee.umbc.edu/courses/undergraduate/341/spring04/Lectures/RedBlack/redblack.pdf
    // (August 24th, 2021)
    func testUMBCTreeBottomUpDeletionExample2() {
        let treeUMBCTreeExample2 = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 65))
            .insert(node: RedBlackTreeNode(key: 50))
            .insert(node: RedBlackTreeNode(key: 80))
            .insert(node: RedBlackTreeNode(key: 10))
            .insert(node: RedBlackTreeNode(key: 60))
            .insert(node: RedBlackTreeNode(key: 70))
            .insert(node: RedBlackTreeNode(key: 62))
        validate(tree: treeUMBCTreeExample2, is: """
                  65??????
                50?????? 80??????
            10?????? 60?????? 70?????? ---
    --- --- --- 62?????? --- --- --- ---
""")
        treeUMBCTreeExample2.delete(key: 80)
        validate(tree: treeUMBCTreeExample2, is: """
                  65??????
                50?????? 70??????
            10?????? 60?????? --- ---
    --- --- --- 62?????? --- --- --- ---
""")
    }
    
    // Example from:
    // https://www.csee.umbc.edu/courses/undergraduate/341/spring04/Lectures/RedBlack/redblack.pdf
    // (August 24th, 2021)
    func testUMBCTreeBottomUpDeletionExample3() {
        let treeUMBCTreeExample3 = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 65))
            .insert(node: RedBlackTreeNode(key: 50))
            .insert(node: RedBlackTreeNode(key: 70))
            .insert(node: RedBlackTreeNode(key: 10))
            .insert(node: RedBlackTreeNode(key: 60))
            .insert(node: RedBlackTreeNode(key: 62))
        validate(tree: treeUMBCTreeExample3, is: """
                  65??????
                50?????? 70??????
            10?????? 60?????? --- ---
    --- --- --- 62?????? --- --- --- ---
""")
        treeUMBCTreeExample3.delete(key: 70)
        validate(tree: treeUMBCTreeExample3, is: """
          50??????
        10?????? 62??????
    --- --- 60?????? 65??????
""")
    }
    
    // Example from:
    // https://www.programiz.com/dsa/deletion-from-a-red-black-tree
    // (August 25th, 2021)
    func testProgramizTreeDeletion() {
        let treeProgramizTree = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 55))
            .insert(node: RedBlackTreeNode(key: 40))
            .insert(node: RedBlackTreeNode(key: 65))
            .insert(node: RedBlackTreeNode(key: 60))
            .insert(node: RedBlackTreeNode(key: 75))
            .insert(node: RedBlackTreeNode(key: 57))
        validate(tree: treeProgramizTree, is: """
                  55??????
                40?????? 65??????
            --- --- 60?????? 75??????
    --- --- --- --- 57?????? --- --- ---
""")
        treeProgramizTree.delete(key: 40)
        validate(tree: treeProgramizTree, is: """
          65??????
        57?????? 75??????
    55?????? 60?????? --- ---
""")
    }
    
    // Example from:
    // http://ion.uwinnipeg.ca/~ychen2/advancedAD/Red-black%20Tree.pdf
    // (August 25th, 2021)
    func testUWinnipegYChen2TreeDeletion() {
        let treeUWinnipeg = RedBlackTree<Int, Any>()
            .insert(node: RedBlackTreeNode(key: 1))
            .insert(node: RedBlackTreeNode(key: 11))
            .insert(node: RedBlackTreeNode(key: 12))
            .insert(node: RedBlackTreeNode(key: 69))
            .insert(node: RedBlackTreeNode(key: 4))
            .insert(node: RedBlackTreeNode(key: 14))
            .insert(node: RedBlackTreeNode(key: 82))
            .insert(node: RedBlackTreeNode(key: 50))
            .insert(node: RedBlackTreeNode(key: 77))
            .insert(node: RedBlackTreeNode(key: 3))
        validate(tree: treeUWinnipeg, is: """
                  14??????
                11?????? 69??????
            03?????? 12?????? 50?????? 82??????
    01?????? 04?????? --- --- --- --- 77?????? ---
""")
        treeUWinnipeg.delete(key: 1)
        validate(tree: treeUWinnipeg, is: """
                  14??????
                11?????? 69??????
            03?????? 12?????? 50?????? 82??????
    --- 04?????? --- --- --- --- 77?????? ---
""")
        treeUWinnipeg.delete(key: 11)
        validate(tree: treeUWinnipeg, is: """
                  14??????
                04?????? 69??????
            03?????? 12?????? 50?????? 82??????
    --- --- --- --- --- --- 77?????? ---
""")
        treeUWinnipeg.delete(key: 12)
        validate(tree: treeUWinnipeg, is: """
                  14??????
                04?????? 69??????
            03?????? --- 50?????? 82??????
    --- --- --- --- --- --- 77?????? ---
""")
        treeUWinnipeg.delete(key: 69)
        validate(tree: treeUWinnipeg, is: """
          14??????
        04?????? 77??????
    03?????? --- 50?????? 82??????
""")
        treeUWinnipeg.delete(key: 4)
        validate(tree: treeUWinnipeg, is: """
          14??????
        03?????? 77??????
    --- --- 50?????? 82??????
""")
        treeUWinnipeg.delete(key: 14)
        validate(tree: treeUWinnipeg, is: """
          50??????
        03?????? 77??????
    --- --- --- 82??????
""")
        treeUWinnipeg.delete(key: 82)
        validate(tree: treeUWinnipeg, is: """
      50??????
    03?????? 77??????
""")
        treeUWinnipeg.delete(key: 50)
        validate(tree: treeUWinnipeg, is: """
      77??????
    03?????? ---
""")
        treeUWinnipeg.delete(key: 77)
        validate(tree: treeUWinnipeg, is: """
    03??????
""")
    }
    
    func testRandomTesting() {
        for seed in [ 8271, 99001873, 3, 12349, 4237423, 69279 ] {
            srand48(seed)
            for nodes in [ 1, 2, 3, 4, 5, 6, 7, 10, 100, 200, 500, 1000 ] {
                var availableKeys = Array(0..<nodes)
                var insert_keys: [Int] = []
                var delete_keys: [Int] = []
                while !availableKeys.isEmpty {
                    let key = availableKeys.remove(at: Int(drand48() * Double(availableKeys.count - 1)))
                    insert_keys.append(key)
                    delete_keys.insert(key, at: Int(drand48() * Double(delete_keys.count)))
                }
                let tree = RedBlackTree<Int, Any>()
                for key in insert_keys {
                    tree.insert(node: RedBlackTreeNode(key: key))
                    hasRedBlackTreeProperties(tree: tree)
                }
                for key in delete_keys {
                    tree.delete(key: key)
                    hasRedBlackTreeProperties(tree: tree)
                }
            }
        }
    }
}
