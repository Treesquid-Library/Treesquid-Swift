import Foundation

public class BinaryTreeNode<Value> {
    public typealias Node = BinaryTreeNode<Value>
    public typealias Value = Value
    
    enum Child: Int {
        case left = 0, right
    }
    
    private(set) public var parent: Node?
    private lazy var children: [Node?] = [ nil, nil ]
    private(set) public var value: Value?
    
    init(value: Value?) {
        self.value = value
    }
}

extension BinaryTreeNode: MutableNode {
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
}

extension BinaryTreeNode: GenericNode {
    //
    // Node properties
    //

    public func degree() -> Int {
        Treesquid.degree(of: self)
    }

    public func capacity() -> Int {
        Treesquid.capacity(of: self)
    }

    public func maxDegree() -> Int {
        return 2
    }

    //
    // GenericNode functions
    //

    func child(at index: Int) -> GenericNode? {
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
        children[childAt] = node as? BinaryTreeNode<Value>
        return self
    }
}

public struct BinaryTreeIterator<Value>: IteratorProtocol {
    var nodeStack = Array<BinaryTreeNode<Value>>()

    // O(m), where m is the height of the tree.
    init(_ tree: BinaryTree<Value>) {
        guard let root = tree.root else { return }
        findLeftmostNode(node: root)
    }

    // O(m), where m is the height of the tree.
    mutating public func next() -> BinaryTreeNode<Value>? {
        guard let node = nodeStack.popLast() else {
            return nil
        }

        guard let rightChild = node.child(at: 1) else {
            return node
        }

        findLeftmostNode(node: rightChild as! Element)

        return node
    }

    // O(m), where m is the height of the tree.
    mutating private func findLeftmostNode(node: Element) {
        nodeStack.append(node)

        guard let leftChild = node.child(at: 0) else {
            return
        }

        findLeftmostNode(node: leftChild as! Element)
    }
}

/// A binary-tree representation where nodes can have an optional value associated with them.
public class BinaryTree<Value> {
    typealias Tree = BinaryTree<Value>
    typealias Node = BinaryTreeNode<Value>

    var root: Node?
}

extension BinaryTree: Tree {
    public func isEmpty() -> Bool {
        return root == nil
    }
    
    public func width() -> Int {
        return Treesquid.width(of: self)
    }
    
    public func count() -> Int {
        return Treesquid.count(of: self)
    }
    
    public func depth() -> Int {
        return Treesquid.depth(of: self)
    }
}

extension BinaryTree: Sequence {
    //
    // Iterator support
    //

    public func makeIterator() -> BinaryTreeIterator<Value> {
        return BinaryTreeIterator<Value>(self)
    }
}

extension BinaryTree: GenericTree {
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

extension BinaryTree {
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
}
