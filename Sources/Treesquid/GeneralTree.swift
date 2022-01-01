import Foundation

public class GeneralTreeNode<Value>: UnboundedTreeNode<Value>, MutableNode {
    public typealias Node = GeneralTreeNode<Value>
    public typealias Value = Value
    
    private(set) public var parent: Node?
    private(set) public var value: Value?
    
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
    public func append(_ child: GeneralTreeNode<Value>) throws -> GeneralTreeNode<Value> {
        child.parent = self;
        return try super.append(child) as! GeneralTreeNode<Value>
    }
    
    @discardableResult
    public func prepend(_ child: GeneralTreeNode<Value>) throws -> GeneralTreeNode<Value> {
        child.parent = self;
        return try super.prepend(child) as! GeneralTreeNode<Value>
    }
    
    @discardableResult
    public func insert(_ child: GeneralTreeNode<Value>, at index: Int) throws -> GeneralTreeNode<Value> {
        child.parent = self;
        return try super.insert(child, at: index) as! GeneralTreeNode<Value>
    }
    
    @discardableResult
    public override func remove(at index: Int) -> GeneralTreeNode<Value> {
        return super.remove(at: index) as! GeneralTreeNode<Value>
    }
    
    @discardableResult
    public func replace(childAt: Int, with node: GeneralTreeNode<Value>) -> GeneralTreeNode<Value> {
        node.parent = self
        return super.replace(childAt: childAt, with: node) as! GeneralTreeNode<Value>
    }
}

public class GeneralTree<Value>: MutableTree, GenericTree {
    public typealias Tree = GeneralTree<Value>
    public typealias Node = GeneralTreeNode<Value>
    
    private(set) public var root: Node?
    
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
        return Treesquid.insert(within: self, newNode: node, maxDegree: Int.max) as! Tree
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
        return Treesquid.insert(within: self, newNode: node, maxDegree: Int.max)
    }
}
