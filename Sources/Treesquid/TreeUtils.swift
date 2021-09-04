import Foundation

public func traverse(tree: RedBlackTree<Int, Any>) -> String {
    if tree.isEmpty() {
        return "" // Empty tree is empty!
    }
    var treeUnicodeArt = ""
    let detailsWidth = 3 // Note: Does not include separating space.
    let indentWidth = detailsWidth + 1 // Number of spaces to indent every line.
    let depth = tree.depth()
    let maxNodesAtBottom = pow(2.0, Double(depth) - 1.0)
    let levelStack = levels(of: tree, fillWithVoidNodes: true)
    for levelIndex in 0..<levelStack.count {
        let maxNodesInLevel = pow(2.0, Double(levelIndex))
        treeUnicodeArt += String(repeating: " ", count: indentWidth)
        treeUnicodeArt += String(repeating: " ",
                                 count: Int(Double(detailsWidth + 1) / 2.0 * (maxNodesAtBottom - maxNodesInLevel)))
        for nodeIndex in 0..<Int(maxNodesInLevel) {
            let needsSpaceSuffix = nodeIndex + 1 < Int(maxNodesInLevel) ? true : false
            if levelIndex > 0 {
                let node = levelStack[levelIndex][nodeIndex]
                if node is VoidNode {
                    treeUnicodeArt += String(repeating: "-", count: detailsWidth)
                        + (needsSpaceSuffix ? " " : "")
                } else {
                    treeUnicodeArt += details(node: node as! RedBlackTreeNode<Int, Any>, appendSpace: needsSpaceSuffix)
                }
            } else {
                treeUnicodeArt += details(node: levelStack[levelIndex][nodeIndex] as! RedBlackTreeNode<Int, Any>, appendSpace: needsSpaceSuffix)
            }
        }
        if levelIndex + 1 < levelStack.count {
            treeUnicodeArt += "\n"
        }
    }
    return treeUnicodeArt
}

func details(node: RedBlackTreeNode<Int, Any>, appendSpace: Bool) -> String {
    let color = node.red ? "◻︎" : "◼︎"
    return "\(String(format: "%02d", node.key))\(color)" + (appendSpace ? " " : "")
}

public func checkIntegrity<Key, Value>(tree: AnyTree<Key, Value>) -> Bool {
    switch tree {
    case .generalTree(let tree):
        if tree.isEmpty() { return true }
    case .mAryTree(let tree):
        if tree.isEmpty() { return true }
    case .binaryTree(let tree):
        if tree.isEmpty() { return true }
    case .redBlackTree(let tree):
        if tree.isEmpty() { return true }
    default:
        return false
    }
    return false
}
