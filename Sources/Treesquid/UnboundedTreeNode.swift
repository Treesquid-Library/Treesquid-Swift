import Foundation

public class UnboundedTreeNode<Value>: GenericNode {
    public typealias Node = UnboundedTreeNode<Value>
    public typealias Value = Value

    private lazy var children: [Node] = []

    //
    // GenericNode function that needs to be overridden by sub-classes.
    //

    public func maxDegree() -> Int {
        return Int.max
    }

    //
    // Child access
    //
    
    // O(1)
    internal func set(child: Node?, at index: Int) {
        guard let child = child else {
            children.remove(at: index)
            return
        }
        children[index] = child
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    @discardableResult
    internal func append(_ child: Node) throws -> Node {
        children.append(child)
        return self
    }
    
    // O(n)
    @discardableResult
    internal func prepend(_ child: Node) throws -> Node {
        children.insert(child, at: 0)
        return self
    }
    
    // O(n)
    @discardableResult
    internal func insert(_ child: Node, at index: Int) throws -> Node {
        children.insert(child, at: index)
        return self
    }
    
    // O(n)
    @discardableResult
    internal func remove(at index: Int) -> Node {
        children.remove(at: index)
        return self
    }
    
    // O(1)
    @discardableResult
    internal func replace(childAt: Int, with node: Node) -> Node {
        children[childAt] = node
        return self
    }

    //
    // GenericNode functions
    //

    public func degree() -> Int {
        Treesquid.degree(of: self)
    }

    public func capacity() -> Int {
        Treesquid.capacity(of: self)
    }

    internal func child(at index: Int) -> GenericNode? {
        return children[index]
    }
    
    internal func getChildren() -> [GenericNode?] {
        return children
    }
    
    @discardableResult
    internal func append(child: GenericNode) throws -> Any {
        return try! append(child as! Node)
    }
    
    @discardableResult
    internal func replace(childAt: Int, with node: GenericNode) -> Any {
        return replace(childAt: childAt, with: node as! Node)
    }
}
