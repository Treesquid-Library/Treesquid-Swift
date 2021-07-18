import Foundation

public class BinaryTreeNode<Key, Value>: TraversableNode, MutableNode, GenericNode {
    public typealias Node = BinaryTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    enum Child: Int {
        case left = 0, right
    }
    
    private(set) public var parent: Node?
    private lazy var children: [Node?] = [ nil, nil ]
    private(set) public var key: Key?
    private(set) public var value: Value?
    
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
    
    public func arity() -> Int {
        Treesquid.arity(of: self)
    }
    
    public func count() -> Int {
        Treesquid.count(of: self)
    }
    
    //
    // Child access
    //
    
    // O(1)
    public subscript(index: Int) -> Node? {
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
            newChild?.parent = self
            children[child.rawValue] = newChild
        }
    }
    
    // O(1)
    @discardableResult
    public func append(_ child: Node) throws -> Node {
        for childIndex in 0..<children.count {
            if children[childIndex] == nil {
                child.parent = self;
                children[childIndex] = child
                return self
            }
        }
        throw NodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    @discardableResult
    public func prepend(_ child: Node) throws -> Node {
        child.parent = self;
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
    public func insert(_ child: Node, at index: Int) throws -> Node {
        if index < 0 || index >= 2 {
            throw NodeOperationError.indexOutOfBounds
        }
        if index == 0 {
            return try! prepend(child)
        }
        if children[Child.right.rawValue] == nil {
            child.parent = self;
            children[Child.right.rawValue] = child
            return self
        }
        throw NodeOperationError.childCapacityExceeded
    }
    
    // O(1)
    @discardableResult
    public func remove(at index: Int) -> Node {
        children[index] = nil
        return self
    }
    
    // O(1)
    @discardableResult
    public func replace(childAt: Int, with node: Node) -> Node {
        children[childAt] = node
        return self
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
    
    @discardableResult
    func append(child: GenericNode) throws -> Any {
        return try! append(child as! Node)
    }
    
    @discardableResult
    func replace(childAt: Int, with node: GenericNode) -> Any {
        children[childAt] = node as? BinaryTreeNode<Key, Value>
        return self
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
