import Foundation

public func traverse(_ tree: BTree<Int, Any>) -> String {
    return traverse_(tree)
}

public func traverse(_ tree: RedBlackTree<Int, Any>) -> String {
    return traverse_(tree)
}

internal func traverse_(_ tree: Tree) -> String {
    // Note: requires that the tree is a GenericTree.
    
    if tree.isEmpty() {
        return "" // Empty tree is empty!
    }
    
    // The maximum number of children that a node can has:
    let nodeDegree: Double
    // B-trees need to be handled a little bit differently, so they are
    // marked here. In particular, `details` handles B-tree nodes properly,
    // but `VoidNode`s need to be told that they are spanning multiple keys
    // in a B-tree.
    let isBTree: Bool
    // Number of spaces to indent every line.
    let indentWidth = 4
    // Fixed-width of a node key. Either "ddd", where "d" is a digit, or
    // "dd◻︎"/"dd◼︎" in the case of red/black trees.
    // Note: Does not include separating space.
    let detailsWidth = 3
    // Fixed-width of a node and trailing white-space.
    // Includes all keys and separators.
    let nodeTextWidth: Int
    
    if let tree = tree as? BTree<Int, Any> {
        nodeDegree = Double(tree.m)
        isBTree = true
        nodeTextWidth = detailsWidth * Int(tree.m - 1) + Int(tree.m - 1)
    } else {
        nodeDegree = 2.0
        isBTree = false
        nodeTextWidth = detailsWidth + 1
    }
    
    var treeUnicodeArt = ""
    let depth = tree.depth()
    let maxNodesAtBottom = pow(nodeDegree, Double(depth) - 1.0)
    let levelStack = levels(of: tree as! GenericTree, fillWithVoidNodes: true)
    for levelIndex in 0..<levelStack.count {
        let maxNodesInLevel = pow(nodeDegree, Double(levelIndex))
        treeUnicodeArt += String(repeating: " ", count: indentWidth)
        treeUnicodeArt += String(repeating: " ",
                                 count: Int(Double(nodeTextWidth) / 2.0 * (maxNodesAtBottom - maxNodesInLevel)))
        for nodeIndex in 0..<Int(maxNodesInLevel) {
            let needsSpaceSuffix = nodeIndex + 1 < Int(maxNodesInLevel) ? true : false
            let node = levelStack[levelIndex][nodeIndex]
            if levelIndex > 0 {
                if node is VoidNode {
                    if isBTree {
                        treeUnicodeArt += Array(repeating: String(repeating: "-",
                                                                  count: detailsWidth),
                                                count: Int((tree as! BTree<Int, Any>).m - 1)).joined(separator: "◦")
                            + (needsSpaceSuffix ? " " : "")
                        //treeUnicodeArt += String(repeating: "-", count: detailsWidth)
                        //    + (needsSpaceSuffix ? " " : "")
                    } else {
                        treeUnicodeArt += String(repeating: "-", count: detailsWidth)
                            + (needsSpaceSuffix ? " " : "")
                    }
                } else if let node = node as? BTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix, detailsWidth: detailsWidth)
                } else if let node = node as? RedBlackTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix, detailsWidth: detailsWidth)
                } else {
                    // TODO
                    treeUnicodeArt += "TODO"
                }
            } else {
                if let node = node as? BTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix, detailsWidth: detailsWidth)
                } else if let node = node as? RedBlackTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix, detailsWidth: detailsWidth)
                } else {
                    // TODO
                    treeUnicodeArt += "TODO"
                }
            }
        }
        if levelIndex + 1 < levelStack.count {
            treeUnicodeArt += "\n"
        }
    }
    return treeUnicodeArt
}

func details(node: BTreeNode<Int, Any>, appendSpace: Bool, detailsWidth: Int) -> String {
    let fullNode: [Int] = node.keys + Array(repeating: Int.min, count: Int(node.tree!.m - 1) - node.keys.count)
    let keysInNode = fullNode.map {"\($0 == Int.min ? String(repeating: "-", count: detailsWidth) : String(format: "%03d", $0))" }.joined(separator: "•")
    return keysInNode + (appendSpace ? " " : "")
}

func details(node: RedBlackTreeNode<Int, Any>, appendSpace: Bool, detailsWidth: Int) -> String {
    let color = node.red ? "◻︎" : "◼︎"
    return "\(String(format: "%02d", node.key))\(color)" + (appendSpace ? " " : "")
}

public func checkTreeIntegrity<Key, Value>(_ tree: AnyTree<Key, Value>) -> Bool {
    switch tree {
    case .generalTree(let tree):
        if tree.isEmpty() { return true }
    case .mAryTree(let tree):
        if tree.isEmpty() { return true }
    case .binaryTree(let tree):
        if tree.isEmpty() { return true }
    case .redBlackTree(let tree):
        if tree.isEmpty() { return true }
    }
    return false
}
