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
    var treeUnicodeArt = ""
    let detailsWidth = 3 // Note: Does not include separating space.
    let indentWidth = detailsWidth + 1 // Number of spaces to indent every line.
    let depth = tree.depth()
    let maxNodesAtBottom = pow(2.0, Double(depth) - 1.0)
    let levelStack = levels(of: tree as! GenericTree, fillWithVoidNodes: true)
    for levelIndex in 0..<levelStack.count {
        let maxNodesInLevel = pow(2.0, Double(levelIndex))
        treeUnicodeArt += String(repeating: " ", count: indentWidth)
        treeUnicodeArt += String(repeating: " ",
                                 count: Int(Double(detailsWidth + 1) / 2.0 * (maxNodesAtBottom - maxNodesInLevel)))
        for nodeIndex in 0..<Int(maxNodesInLevel) {
            let needsSpaceSuffix = nodeIndex + 1 < Int(maxNodesInLevel) ? true : false
            let node = levelStack[levelIndex][nodeIndex]
            if levelIndex > 0 {
                if node is VoidNode {
                    treeUnicodeArt += String(repeating: "-", count: detailsWidth)
                        + (needsSpaceSuffix ? " " : "")
                } else if let node = node as? BTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix)
                } else if let node = node as? RedBlackTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix)
                } else {
                    // TODO
                    treeUnicodeArt += "TODO"
                }
            } else {
                if let node = node as? BTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix)
                } else if let node = node as? RedBlackTreeNode<Int, Any> {
                    treeUnicodeArt += details(node: node, appendSpace: needsSpaceSuffix)
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

func details(node: BTreeNode<Int, Any>, appendSpace: Bool) -> String {
    let keysInNode = node.keys.map { "\(String(format: "%03d", $0))" }.joined(separator: "•")
    return keysInNode + (appendSpace ? " " : "")
}

func details(node: RedBlackTreeNode<Int, Any>, appendSpace: Bool) -> String {
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
