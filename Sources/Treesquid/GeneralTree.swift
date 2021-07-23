import Foundation

public class GeneralTreeNode<Key, Value>: DynamicTreeNode<Key, Value>, TraversableNode, MutableNode {
    public typealias Node = GeneralTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    private(set) public var parent: Node?
    private(set) public var key: Key?
    private(set) public var value: Value?
    
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
    public func append(_ child: GeneralTreeNode<Key, Value>) throws -> GeneralTreeNode<Key, Value> {
        child.parent = self;
        return try super.append(child) as! GeneralTreeNode<Key, Value>
    }
    
    @discardableResult
    public func prepend(_ child: GeneralTreeNode<Key, Value>) throws -> GeneralTreeNode<Key, Value> {
        child.parent = self;
        return try super.prepend(child) as! GeneralTreeNode<Key, Value>
    }
    
    @discardableResult
    public func insert(_ child: GeneralTreeNode<Key, Value>, at index: Int) throws -> GeneralTreeNode<Key, Value> {
        child.parent = self;
        return try super.insert(child, at: index) as! GeneralTreeNode<Key, Value>
    }
    
    @discardableResult
    public override func remove(at index: Int) -> GeneralTreeNode<Key, Value> {
        return super.remove(at: index) as! GeneralTreeNode<Key, Value>
    }
    
    @discardableResult
    public func replace(childAt: Int, with node: GeneralTreeNode<Key, Value>) -> GeneralTreeNode<Key, Value> {
        node.parent = self
        return replace(childAt: childAt, with: node)
    }
}

public class GeneralTree<Key, Value>: Tree, GenericTree {
    public typealias Tree = GeneralTree<Key, Value>
    public typealias Node = GeneralTreeNode<Key, Value>
    
    var root: Node?
    
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
        return Treesquid.insert(within: self, newNode: node, maxDegree: UInt.max) as! Tree
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
        return Treesquid.insert(within: self, newNode: node, maxDegree: UInt.max)
    }
}
