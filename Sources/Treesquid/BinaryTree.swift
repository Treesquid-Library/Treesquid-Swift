import Foundation

class BinaryTreeNode<Key, Value>: TraversableNode, MutableNode, GenericNode {
    typealias Node = BinaryTreeNode<Key, Value>
    typealias Key = Key
    typealias Value = Value
    
    enum Child: Int {
        case left = 0, right
    }
    
    private(set) var parent: Node?
    lazy var children: [Node?] = [ nil, nil ]
    private(set) var key: Key?
    private(set) var value: Value?
    
    convenience init(key: Key?) {
        self.init(key: key, value: nil)
    }
    
    init(key: Key?, value: Value?) {
        self.key = key
        self.value = value
    }
    
    //
    // Node properties
    //
    
    func arity() -> Int {
        Treesquid.arity(of: self)
    }
    
    func count() -> Int {
        Treesquid.count(of: self)
    }
    
    //
    // Child access
    //
    
    // O(1)
    subscript(index: Int) -> Node? {
        get {
            children[index]
        }
        set(newChild) {
            children[index] = newChild
        }
    }
    
    // O(1)
    subscript(child: Child) -> Node? {
        get {
            children[child.rawValue]
        }
        set(newChild) {
            children[child.rawValue] = newChild
        }
    }
    
    // O(1)
    @discardableResult
    func append(_ child: Node) throws -> Node {
        for childIndex in 0..<children.count {
            if children[childIndex] == nil {
                children[childIndex] = child
                return self
            }
        }
        throw NodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    @discardableResult
    func prepend(_ child: Node) throws -> Node {
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
    @discardableResult
    func insert(_ child: Node, at index: Int) throws -> Node {
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
    
    //
    // GenericNode functions
    //
    
    func child(at index: Int) -> Any? {
        return children[index]
    }
    
    func getChildren() -> [GenericNode?] {
        return children
    }
    
    func append(child: GenericNode) throws -> Any {
        return try! append(child as! Node)
    }
    
    func replace(childAt: Int, with node: GenericNode) -> Any {
        return children[childAt] = node as? Node
    }
}

class BinaryTree<Key, Value>: GenericTree {
    typealias Tree = BinaryTree<Key, Value>
    typealias Node = BinaryTreeNode<Key, Value>

    var root: Node?
    
    func isEmpty() -> Bool {
        return root == nil
    }
    
    func breadth() -> Int {
        return Treesquid.breadth(of: self)
    }
    
    func count() -> Int {
        return Treesquid.count(of: self)
    }
    
    func depth() -> Int {
        return Treesquid.depth(of: self)
    }
    
    //
    // Tree access
    //
    
    @discardableResult
    func insert(node: Node) -> Tree {
        return insert(node: node as GenericNode) as! Tree
    }
    
    func levels() -> [[Node]] {
        return Treesquid.levels(of: self) as! [[Node]]
    }
    
    //
    // GenericTree functions
    //
    
    func getRoot() -> GenericNode? {
        return root
    }
    
    func setRoot(_ node: GenericNode) {
        root = node as? Node
    }
    
    func insert(node: GenericNode) -> Any {
        return Treesquid.insert(within: self, newNode: node)
    }
}
