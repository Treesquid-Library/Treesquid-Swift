import Foundation

enum NodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
}

class GeneralTreeNode<Key, Value>: TraversableNode, MutableNode, GenericNode {
    typealias Node = GeneralTreeNode<Key, Value>
    typealias Key = Key
    typealias Value = Value
    
    private(set) var parent: Node?
    lazy var children: [Node] = []
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
            guard let newChild = newChild else {
                children.remove(at: index)
                return
            }
            children[index] = newChild
        }
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    @discardableResult
    func append(_ child: Node) throws -> Node {
        children.append(child)
        return self
    }
    
    // O(n)
    @discardableResult
    func prepend(_ child: Node) throws -> Node {
        children.insert(child, at: 0)
        return self
    }
    
    // O(n)
    @discardableResult
    func insert(_ child: Node, at index: Int) throws -> Node {
        children.insert(child, at: index)
        return self
    }
    
    // O(n)
    @discardableResult
    func remove(at index: Int) -> Node {
        children.remove(at: index)
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
    
    func append(child: GenericNode) throws -> Any {
        return try! append(child as! Node)
    }
    
    func replace(childAt: Int, with node: GenericNode) -> Any {
        return children[childAt] = node as! Node
    }
}

class GeneralTree<Key, Value>: Tree, GenericTree {
    typealias Tree = GeneralTree<Key, Value>
    typealias Node = GeneralTreeNode<Key, Value>
    
    var root: Node?
    
    //
    // Boolean tree-properties
    //
    
    func isEmpty() -> Bool {
        return root == nil
    }
    
    //
    // Non-boolean tree-properties
    //
    
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
    
    @discardableResult func insert(node: Node) -> Tree {
        return Treesquid.insert(within: self, newNode: node) as! Tree
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
