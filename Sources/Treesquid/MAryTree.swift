import Foundation

public class MAryTreeNode<Key, Value>: DynamicTreeNode<Key, Value>, TraversableNode, MutableNode {
    public typealias Node = MAryTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    private(set) public var m: UInt32
    private(set) public var parent: Node?
    private(set) public var key: Key?
    private(set) public var value: Value?
    
    public convenience init(m: UInt32, key: Key?) {
        self.init(m: m, key: key, value: nil)
    }
    
    public init(m: UInt32, key: Key?, value: Value?) {
        self.m = m
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
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
        child.parent = self;
        return try super.append(child) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public func prepend(_ child: MAryTreeNode<Key, Value>) throws -> MAryTreeNode<Key, Value> {
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
        child.parent = self;
        return try super.prepend(child) as! MAryTreeNode<Key, Value>
    }
    
    @discardableResult
    public func insert(_ child: MAryTreeNode<Key, Value>, at index: Int) throws -> MAryTreeNode<Key, Value> {
        if degree() >= m {
            throw NodeOperationError.childCapacityExceeded
        }
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
        return replace(childAt: childAt, with: node)
    }
}

