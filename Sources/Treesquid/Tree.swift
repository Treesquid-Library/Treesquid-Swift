protocol TraversableNode {
    associatedtype Node
    
    subscript(index: Int) -> Node? { get }
}

protocol MutableNode {
    associatedtype Node
    
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
    func depth() -> Int
    
    // O(n), where n is the number of nodes in the tree.
    func breadth() -> Int
    
    // Implementation dependent.
    func insert(node: Node) -> Tree
}
