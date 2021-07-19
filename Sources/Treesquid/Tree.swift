public enum NodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
}

internal protocol GenericNode {
    func degree() -> Int
    
    func child(at index: Int) -> Any?
    
    func getChildren() -> [GenericNode?]
    
    @discardableResult
    func append(child: GenericNode) throws -> Any
    
    @discardableResult
    func replace(childAt: Int, with node: GenericNode) -> Any
}

public protocol TraversableNode {
    associatedtype Node
    associatedtype Key
    associatedtype Value
    
    var parent: Node? { get }
    var key: Key? { get }
    var value: Value? { get }
    
    // O(1)
    func degree() -> Int
    
    // O(n), where n is the degree of the node.
    func count() -> Int
    
    // O(1)
    subscript(index: Int) -> Node? { get }
}

public protocol MutableNode {
    associatedtype Node
    
    // O(1) for get
    // O(n) for set, where n is the degree of the node, but might be O(1)
    //      is no space reallocation is necessary.
    subscript(index: Int) -> Node? { get set }
    
    @discardableResult
    func append(_ child: Node) throws -> Node

    @discardableResult
    func prepend(_ child: Node) throws -> Node
    
    @discardableResult
    func insert(_ child: Node, at index: Int) throws -> Node
    
    @discardableResult
    func remove(at index: Int) -> Node
    
    @discardableResult
    func replace(childAt: Int, with node: Node) -> Node
}

internal protocol GenericTree {
    func isEmpty() -> Bool
    
    func getRoot() -> GenericNode?
    
    func setRoot(_ node: GenericNode)
    
    func insert(node: GenericNode) -> Any
}

public protocol Tree {
    associatedtype Tree
    associatedtype Node
    
    // O(1)
    func isEmpty() -> Bool
    
    // O(n), where n is the number of nodes in the tree.
    func width() -> Int

    // O(n), where n is the number of nodes in the tree.
    func count() -> Int
    
    // O(n), where n is the number of nodes in the tree.
    func depth() -> Int
        
    // Implementation dependent.
    func insert(node: Node) -> Tree
}

//
// GenericNode
//

internal func degree(of node: GenericNode) -> Int {
    return node.getChildren().count
}

internal func count(of node: GenericNode) -> Int {
    return node.getChildren().map { $0 != nil ? 1 : 0 }.reduce(0, { x, y in x + y })
}

//
// GenericTree
//

internal func width(of tree: GenericTree) -> Int {
    guard let root = tree.getRoot() else { return 0 }
    var levelStack = [[root]]
    levels(levelStack: &levelStack)
    return levelStack.map { $0.count }.max()!
}

internal func count(of tree: GenericTree) -> Int {
    guard let root = tree.getRoot() else { return 0 }
    var levelStack = [[root]]
    levels(levelStack: &levelStack)
    // NOTE: This duplicates the space requirement.
    return levelStack.map { $0.count }.reduce(0, { x, y in x + y })
}

internal func depth(of tree: GenericTree) -> Int {
    return depth(tree.getRoot())
}

fileprivate func depth(_ node: GenericNode?) -> Int {
    guard let node = node else { return 0 }
    return node.getChildren()
        .reduce(0, { max($0, depth($1)) })
        + 1
}

internal func levels(of tree: GenericTree) -> [[GenericNode]] {
    guard let root = tree.getRoot() else { return [] }
    var levelStack: [[GenericNode]] = [[root]]
    levels(levelStack: &levelStack)
    return levelStack
}

fileprivate func levels(levelStack: inout [[GenericNode]]) {
    guard let deepestLevel = levelStack.last else { return }
    var nextLevel: [GenericNode] = []
    for node in deepestLevel {
        for child in node.getChildren() {
            if child != nil {
                nextLevel.append(child!)
            }
        }
    }
    if nextLevel.isEmpty { return }
    levelStack.append(nextLevel)
    return levels(levelStack: &levelStack)
}

internal func insert(within tree: GenericTree, newNode: GenericNode) -> GenericTree {
    if tree.isEmpty() {
        tree.setRoot(newNode)
        return tree
    }
    return insert(within: tree, newNode: newNode, depth: 0, level: [tree.getRoot()!])
}
    
fileprivate func insert(within tree: GenericTree, newNode: GenericNode, depth: Int, level: [GenericNode]) -> GenericTree {
    var nextLevel: [GenericNode] = []
    for node in level {
        if node.degree() == 0 {
            try! node.append(child: newNode)
            return tree
        }
        for childIndex in 0..<node.degree() {
            if node.child(at: childIndex) == nil {
                node.replace(childAt: childIndex, with: newNode)
                return tree
            }
            nextLevel.append(node.child(at: childIndex) as! GenericNode)
        }
    }
    return insert(within: tree, newNode: newNode, depth: depth + 1, level: nextLevel)
}
