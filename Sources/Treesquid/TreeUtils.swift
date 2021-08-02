import Foundation

public func traverse(tree: RedBlackTree<Int, Any>) {
    if tree.isEmpty() {
        print("empty tree")
        return
    }
    let detailsWidth = 3 // Note: Does not include separating space.
    let indentWidth = detailsWidth + 1 // Number of spaces to indent every line.
    let depth = tree.depth()
    let maxNodesAtBottom = pow(2.0, Double(depth) - 1.0)
    let levelStack = levels(of: tree, fillWithVoidNodes: true)
    for levelIndex in 0..<levelStack.count {
        let maxNodesInLevel = pow(2.0, Double(levelIndex))
        print(String(repeating: " ", count: indentWidth), terminator: "")
        print(String(repeating: " ",
                     count: Int(Double(detailsWidth + 1) / 2.0 * (maxNodesAtBottom - maxNodesInLevel))), terminator: "")
        for nodeIndex in 0..<Int(maxNodesInLevel) {
            if levelIndex > 0 {
                let node = levelStack[levelIndex][nodeIndex]
                if node is VoidNode {
                    print(String(repeating: "-", count: detailsWidth) + " ", terminator: "")
                } else {
                    details(node: node as! RedBlackTreeNode<Int, Any>)
                }
            } else {
                details(node: levelStack[levelIndex][nodeIndex] as! RedBlackTreeNode<Int, Any>)
            }
        }
        print("")
    }
}

func details(node: RedBlackTreeNode<Int, Any>) {
    let color = node.red ? "◻︎" : "◼︎"
    print("\(String(format: "%02d", node.key))\(color)", terminator: " ")
}
