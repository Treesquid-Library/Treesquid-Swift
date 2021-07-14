import Foundation

class BinaryTreeNode<T>: TreeNode<T> {
    enum Child: Int {
        case left = 0, right
    }
    
    override init(value: T?) {
        super.init(value: value)
        children = [ nil, nil ]
    }
    
    // O(1)
    override func append(_ child: TreeNode<T>) throws -> TreeNode<T> {
        for childIndex in 0..<children.count {
            if children[childIndex] == nil {
                children[childIndex] = child
                return self
            }
        }
        throw TreeNodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    override func prepend(_ child: TreeNode<T>) throws -> TreeNode<T> {
        if children[Child.left.rawValue] == nil {
            children[Child.left.rawValue] = child
            return self
        } else if children[Child.right.rawValue] == nil {
            children[Child.right.rawValue] = children[Child.left.rawValue]
            children[Child.left.rawValue] = child
            return self
        }
        throw TreeNodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    override func insert(_ child: TreeNode<T>, at index: Int) throws -> TreeNode<T> {
        if index < 0 || index >= 2 {
            throw TreeNodeOperationError.indexOutOfBounds
        }
        if index == 0 {
            return try! prepend(child)
        }
        if children[Child.right.rawValue] == nil {
            children[Child.right.rawValue] = child
            return self
        }
        throw TreeNodeOperationError.childCapacityExceeded
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
