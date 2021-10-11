public enum NodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
    case treeUnassigned
    case invalidTreeConfiguration
    case immutable
}

public enum AnyNode<Key: Comparable, Value> {
    case generalTreeNode(GeneralTreeNode<Value>)
    case mAryTreeNode(MAryTreeNode<Value>)
    case binaryTreeNode(BinaryTreeNode<Value>)
    case redBlackTreeNode(RedBlackTreeNode<Key, Value>)
}

public enum AnyTree<Key: Comparable, Value> {
    case generalTree(GeneralTree<Value>)
    case mAryTree(MAryTree<Value>)
    case binaryTree(BinaryTree<Value>)
    case redBlackTree(RedBlackTree<Key, Value>)
}

internal protocol GenericNode {
    func capacity() -> Int
    
    func degree() -> Int
    
    func child(at index: Int) -> GenericNode?
    
    func getChildren() -> [GenericNode?]
    
    @discardableResult
    func append(child: GenericNode) throws -> Any
    
    @discardableResult
    func replace(childAt: Int, with node: GenericNode) -> Any
}

public protocol Node {
    associatedtype Node
    associatedtype Value
    
    var parent: Node? { get }
    var value: Value? { get }
    
    // O(1)
    func capacity() -> Int
    
    // O(n), where n is the degree of the node.
    func degree() -> Int
    
    // O(1)
    subscript(index: Int) -> Node? { get }
}

public protocol KeyNode: Node {
    associatedtype Key

    var key: Key { get }
}

public protocol ArrayNode {
    associatedtype Node
    associatedtype Value
    
    var parent: Node? { get }
    var values: [Value?] { get }
    
    // O(1)
    func capacity() -> Int
    
    // O(n), where n is the degree of the node.
    func degree() -> Int
    
    // O(1)
    subscript(index: Int) -> Node? { get }
}

public protocol KeyArrayNode: ArrayNode {
    associatedtype Key

    var keys: [Key] { get }
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
    // O(1)
    func isEmpty() -> Bool
    
    // O(n), where n is the number of nodes in the tree.
    func width() -> Int

    // O(n), where n is the number of nodes in the tree.
    func count() -> Int
    
    // O(n), where n is the number of nodes in the tree.
    func depth() -> Int
}

public protocol MutableTree {
    associatedtype Tree
    associatedtype Node
    
    // O(1)
    var root: Node? { get }
        
    // Implementation dependent.
    func insert(node: Node) -> Tree
}

//
// Void node
//
internal class VoidNode: GenericNode {
    private let arity: Int
    
    public init(degree: Int) {
        self.arity = degree
    }
    
    //
    // GenericNode
    //
    
    func capacity() -> Int {
        return arity
    }
    
    func degree() -> Int {
        return arity
    }
    
    func child(at index: Int) -> GenericNode? {
        return nil
    }
    
    func getChildren() -> [GenericNode?] {
        return Array(repeating: nil, count: arity)
    }
    
    func append(child: GenericNode) throws -> Any {
        throw NodeOperationError.immutable
    }
    
    func replace(childAt: Int, with node: GenericNode) -> Any {
        return self
    }
}

//
// GenericNode
//

internal func capacity(of node: GenericNode) -> Int {
    return node.getChildren().count
}

internal func degree(of node: GenericNode) -> Int {
    return node.getChildren().map { $0 != nil ? 1 : 0 }.reduce(0, { x, y in x + y })
}

//
// GenericTree
//

internal func width(of tree: GenericTree) -> Int {
    guard let root = tree.getRoot() else { return 0 }
    var levelStack = [[root]]
    levels(levelStack: &levelStack, fillWithVoidNodes: false)
    return levelStack.map { $0.count }.max()!
}

internal func count(of tree: GenericTree) -> Int {
    guard let root = tree.getRoot() else { return 0 }
    var levelStack = [[root]]
    levels(levelStack: &levelStack, fillWithVoidNodes: false)
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
    return levels(of: tree, fillWithVoidNodes: false)
}

internal func levels(of tree: GenericTree, fillWithVoidNodes: Bool) -> [[GenericNode]] {
    guard let root = tree.getRoot() else { return [] }
    var levelStack: [[GenericNode]] = [[root]]
    levels(levelStack: &levelStack, fillWithVoidNodes: fillWithVoidNodes)
    return levelStack
}

fileprivate func levels(levelStack: inout [[GenericNode]], fillWithVoidNodes: Bool) {
    guard let deepestLevel = levelStack.last else { return }
    var nextLevel: [GenericNode] = []
    if fillWithVoidNodes {
        var allNodesAreVoid = true
        for node in deepestLevel {
            for childIndex in 0..<node.capacity() {
                let child = node.child(at: childIndex)
                if child != nil && !(child is VoidNode) {
                    nextLevel.append(child!)
                    allNodesAreVoid = false
                } else {
                    nextLevel.append(VoidNode(degree: node.capacity()))
                }
            }
        }
        if allNodesAreVoid { return }
    } else {
        for node in deepestLevel {
            for child in node.getChildren() {
                if child != nil {
                    nextLevel.append(child!)
                }
            }
        }
        if nextLevel.isEmpty { return }
    }
    levelStack.append(nextLevel)
    return levels(levelStack: &levelStack, fillWithVoidNodes: fillWithVoidNodes)
}

internal func insert(within tree: GenericTree, newNode: GenericNode, maxDegree: UInt) -> GenericTree {
    if tree.isEmpty() {
        tree.setRoot(newNode)
        return tree
    }
    let root = tree.getRoot()!
    return insert(within: tree,
                  newNode: newNode,
                  depth: 0,
                  level: [root],
                  maxDegree: maxDegree)
}
    
fileprivate func insert(within tree: GenericTree, newNode: GenericNode, depth: Int, level: [GenericNode], maxDegree: UInt) -> GenericTree {
    var nextLevel: [GenericNode] = []
    for node in level {
        if node.degree() == 0 {
            try! node.append(child: newNode)
            return tree
        }
        let capacity = node.capacity()
        for childIndex in 0..<capacity {
            if node.child(at: childIndex) == nil {
                node.replace(childAt: childIndex, with: newNode)
                return tree
            }
            nextLevel.append(node.child(at: childIndex)!)
        }
        if capacity < maxDegree {
            try! node.append(child: newNode)
            return tree
        }
    }
    return insert(within: tree, newNode: newNode, depth: depth + 1, level: nextLevel, maxDegree: maxDegree)
}
