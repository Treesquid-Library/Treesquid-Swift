import Foundation

public class MAryTreeNode<Key, Value>: DynamicTreeNode<Key, Value>, KeyNode, MutableNode {
    public typealias Node = MAryTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value

    private(set) public var parent: Node?
    private(set) public var key: Key?
    private(set) public var value: Value?

    internal var tree: MAryTree<Key, Value>?
    
    public convenience init(key: Key?) {
        self.init(key: key, value: nil)
    }
    
    public init(key: Key?, value: Value?) {
        self.key = key
        self.value = value
    }
    
    //
    // Child access
    //
    
    // O(1)
    public subscript(index: Int) -> Node? {
        get {
            child(at: index) as! Node?
        }
        set(newChild) {
            newChild?.parent = self
            set(child: newChild as Node?, at: index)
        }
    }
    
    //
    // MutableNode
    //
    
    @discardableResult
    public func append(_ child: MAryTreeNode<Key, Value>) throws -> MAryTreeNode<Key, Value> {
        let m = try maxDegree()
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.append(child) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public func prepend(_ child: MAryTreeNode<Key, Value>) throws -> MAryTreeNode<Key, Value> {
        let m = try maxDegree()
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.prepend(child) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public func insert(_ child: MAryTreeNode<Key, Value>, at index: Int) throws -> MAryTreeNode<Key, Value> {
        let m = try maxDegree()
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.insert(child, at: index) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public override func remove(at index: Int) -> MAryTreeNode<Key, Value> {
        return super.remove(at: index) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public func replace(childAt: Int, with node: MAryTreeNode<Key, Value>) -> MAryTreeNode<Key, Value> {
        node.parent = self
        return super.replace(childAt: childAt, with: node) as! MAryTreeNode<Key, Value>
    }
    
    internal func maxDegree() throws -> UInt {
        guard let tree = tree else {
            throw NodeOperationError.treeUnassigned
        }
        return tree.m
    }
}

public class MAryTree<Key, Value>: MutableTree, GenericTree {
    public typealias Tree = MAryTree<Key, Value>
    public typealias Node = MAryTreeNode<Key, Value>
    
    private(set) public var root: Node?
    private(set) public var m: UInt

    public init(m: UInt) {
        self.m = m
    }
    
    //
    // Boolean tree-properties
    //
    
    public func isEmpty() -> Bool {
        return root == nil
    }
    
    //
    // Non-boolean tree-properties
    //
    
    public func width() -> Int {
        return Treesquid.width(of: self)
    }
    
    public func count() -> Int {
        return Treesquid.count(of: self)
    }
    
    public func depth() -> Int {
        return Treesquid.depth(of: self)
    }
    
    //
    // Tree access
    //
    
    @discardableResult
    public func insert(node: Node) -> Tree {
        node.tree = self
        return Treesquid.insert(within: self, newNode: node, maxDegree: m) as! Tree
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
        return Treesquid.insert(within: self, newNode: node, maxDegree: 2)
    }
}
