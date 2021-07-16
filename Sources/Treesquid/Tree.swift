protocol TraversableNode {
    associatedtype Node
    
    // O(1)
    func arity() -> Int
    
    // O(n), where n is the arity of the node.
    func count() -> Int
    
    // O(1)
    subscript(index: Int) -> Node? { get }
}

protocol MutableNode {
    associatedtype Node
    
    // O(1) for get
    // O(n) for set, where n is the arity of the node, but might be O(1)
    //      is no space reallocation is necessary.
    subscript(index: Int) -> Node? { get set }
    
    func append(_ child: Node) throws -> Node

    func prepend(_ child: Node) throws -> Node
    
    func insert(_ child: Node, at index: Int) throws -> Node
}

protocol Treelike {
    associatedtype Tree
    associatedtype Node
    
    // O(1)
    func isEmpty() -> Bool
    
    // O(n), where n is the number of nodes in the tree.
    func breadth() -> Int

    // O(n), where n is the number of nodes in the tree.
    func count() -> Int
    
    // O(n), where n is the number of nodes in the tree.
    func depth() -> Int
        
    // Implementation dependent.
    func insert(node: Node) -> Tree
}
