import Foundation

public protocol ArityM { var m: Int { get } }
public class Arity1: ArityM { public let m = 1 }
public class Arity2: ArityM { public let m = 2 }
public class Arity3: ArityM { public let m = 3 }
public class Arity4: ArityM { public let m = 4 }
public class Arity5: ArityM { public let m = 5 }
public class Arity6: ArityM { public let m = 6 }
public class Arity7: ArityM { public let m = 7 }
public class Arity8: ArityM { public let m = 8 }
public class Arity9: ArityM { public let m = 9 }
public class Arity10: ArityM { public let m = 10 }
public class Arity11: ArityM { public let m = 11 }
public class Arity12: ArityM { public let m = 12 }

public class MAryTreeNode<M: ArityM, Key, Value>: DynamicTreeNode<Key, Value>, TraversableNode, MutableNode {
    public typealias Node = MAryTreeNode<M, Key, Value>
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
    public func append(_ child: MAryTreeNode<M, Key, Value>) throws -> MAryTreeNode<M, Key, Value> {
        child.parent = self;
        return try super.append(child) as! MAryTreeNode<M, Key, Value>
    }
    
    @discardableResult
    public func prepend(_ child: MAryTreeNode<M, Key, Value>) throws -> MAryTreeNode<M, Key, Value> {
        child.parent = self;
        return try super.prepend(child) as! MAryTreeNode<M, Key, Value>
    }
    
    @discardableResult
    public func insert(_ child: MAryTreeNode<M, Key, Value>, at index: Int) throws -> MAryTreeNode<M, Key, Value> {
        child.parent = self;
        return try super.insert(child, at: index) as! MAryTreeNode<M, Key, Value>
    }
    
    @discardableResult
    public override func remove(at index: Int) -> MAryTreeNode<M, Key, Value> {
        return super.remove(at: index) as! MAryTreeNode<M, Key, Value>
    }
    
    @discardableResult
    public func replace(childAt: Int, with node: MAryTreeNode<M, Key, Value>) -> MAryTreeNode<M, Key, Value> {
        node.parent = self
        return replace(childAt: childAt, with: node)
    }
}
