import Foundation

class BinaryTreeNode<T>: GeneralNode<T> {
    enum Child: Int {
        case left = 0, right
    }
    
    override init(value: T?) {
        super.init(value: value)
        children = [ nil, nil ]
    }
    
    // O(1)
    @discardableResult override func append(_ child: GeneralNode<T>) throws -> GeneralNode<T> {
        for childIndex in 0..<children.count {
            if children[childIndex] == nil {
                children[childIndex] = child
                return self
            }
        }
        throw NodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    @discardableResult override func prepend(_ child: GeneralNode<T>) throws -> GeneralNode<T> {
        if children[Child.left.rawValue] == nil {
            children[Child.left.rawValue] = child
            return self
        } else if children[Child.right.rawValue] == nil {
            children[Child.right.rawValue] = children[Child.left.rawValue]
            children[Child.left.rawValue] = child
            return self
        }
        throw NodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    @discardableResult override func insert(_ child: GeneralNode<T>, at index: Int) throws -> GeneralNode<T> {
        if index < 0 || index >= 2 {
            throw NodeOperationError.indexOutOfBounds
        }
        if index == 0 {
            return try! prepend(child)
        }
        if children[Child.right.rawValue] == nil {
            children[Child.right.rawValue] = child
            return self
        }
        throw NodeOperationError.childCapacityExceeded
    }
}

class BinaryTree<T>: GeneralTree<T> {
    @discardableResult override func insert(node: GeneralNode<T>) -> BinaryTree<T> {
        if node is BinaryTreeNode {
            return super.insert(node: node) as! BinaryTree<T>
        } else {
            return super.insert(node: BinaryTreeNode(value: node.value)) as! BinaryTree<T>
        }
    }
}
