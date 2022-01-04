import Foundation

public class MAryTreeNode<Value>: UnboundedTreeNode<Value>, MutableNode {
    public typealias Node = MAryTreeNode<Value>
    public typealias Value = Value

    private(set) public var parent: Node?
    private(set) public var value: Value?

    internal var tree: MAryTree<Value>?
    
    public init(value: Value?) {
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
    public func append(_ child: MAryTreeNode<Value>) throws -> MAryTreeNode<Value> {
        if degree() >= maxDegree() {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.append(child) as! MAryTreeNode<Value>
    }
    
    @discardableResult
    public func prepend(_ child: MAryTreeNode<Value>) throws -> MAryTreeNode<Value> {
        if degree() >= maxDegree() {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.prepend(child) as! MAryTreeNode<Value>
    }
    
    @discardableResult
    public func insert(_ child: MAryTreeNode<Value>, at index: Int) throws -> MAryTreeNode<Value> {
        if degree() >= maxDegree() {
            throw NodeOperationError.childCapacityExceeded
        }
        child.tree = tree;
        child.parent = self;
        return try super.insert(child, at: index) as! MAryTreeNode<Value>
    }
    
    @discardableResult
    public override func remove(at index: Int) -> MAryTreeNode<Value> {
        return super.remove(at: index) as! MAryTreeNode<Value>
    }
    
    @discardableResult
    public func replace(childAt: Int, with node: MAryTreeNode<Value>) -> MAryTreeNode<Value> {
        node.parent = self
        return super.replace(childAt: childAt, with: node) as! MAryTreeNode<Value>
    }
    
    override public func maxDegree() -> Int {
        guard let tree = tree else { return 0 }
        return Int(tree.m)
    }
}

// An m-ary tree representation where nodes have an optional value associated with them.
public class MAryTree<Value>: Tree, GenericTree {
    public typealias Tree = MAryTree<Value>
    public typealias Node = MAryTreeNode<Value>
    
    private(set) public var root: Node?
    private(set) public var m: Int

    public init(m: Int) {
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
