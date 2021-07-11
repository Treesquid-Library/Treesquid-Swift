import Foundation

class BinaryTreeNode<T>: TreeNode<T> {
    enum Child: Int {
        case left = 0, right
    }
    
    override init(value: T) {
        super.init(value: value)
        children = [ nil, nil ]
    }
}

class BinaryTree<T>: GenericTree<T> {
    override func append(node: TreeNode<T>) -> BinaryTree<T> {
        if node is BinaryTreeNode {
            return super.append(node: node) as! BinaryTree<T>
        } else {
            return super.append(node: BinaryTreeNode(value: node.value)) as! BinaryTree<T>
        }
    }
}
