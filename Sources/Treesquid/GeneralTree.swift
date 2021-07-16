import Foundation

enum NodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
}

class GeneralNode<T>: TraversableNode, MutableNode {
    typealias Node = GeneralNode<T>
    
    private(set) var parent: GeneralNode<T>?
    lazy var children: [GeneralNode<T>?] = []
    private(set) var value: T?
    
    init(value: T?) {
        self.value = value
    }
    
    // O(1)
    subscript(index: Int) -> Node? {
        get {
            children[index]
        }
        set(newChild) {
            children[index] = newChild
        }
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    @discardableResult func append(_ child: GeneralNode<T>) throws -> GeneralNode<T> {
        children.append(child)
        return self
    }
    
    // O(n)
    @discardableResult func prepend(_ child: GeneralNode<T>) throws -> GeneralNode<T> {
        children.insert(child, at: 0)
        return self
    }
    
    // O(n)
    @discardableResult func insert(_ child: GeneralNode<T>, at index: Int) throws -> GeneralNode<T> {
        children.insert(child, at: index)
        return self
    }
}

class GeneralTree<T>: Treelike {
    var root: GeneralNode<T>?
    
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
        guard let root = root else { return 0 }
        var levelStack = [[root]]
        levels(levelStack: &levelStack)
        return levelStack.map { $0.count }.max()!
    }
    
    func depth() -> Int {
        return depth(root)
    }
    
    //
    // Tree access
    //
    
    @discardableResult func insert(node: GeneralNode<T>) -> GeneralTree {
        if root == nil {
            root = node
            return self
        }
        return insert(node, depth: 1, level: [root!])
    }
    
    func levels() -> [[GeneralNode<T>]] {
        guard let root = root else { return [] }
        var levelStack: [[GeneralNode<T>]] = [[root]]
        levels(levelStack: &levelStack)
        return levelStack
    }
    
    //
    // Private functions
    //
    
    private func insert(_ newNode: GeneralNode<T>, depth: Int, level: [GeneralNode<T>]) -> GeneralTree<T> {
        var nextLevel: [GeneralNode<T>] = []
        for node in level {
            if node.children.count == 0 {
                try! node.append(newNode)
                return self
            }
            for childIndex in 0..<node.children.count {
                if node[childIndex] == nil {
                    node[childIndex] = newNode
                    return self
                }
                nextLevel.append(node[childIndex]!)
            }
        }
        return insert(newNode, depth: depth + 1, level: nextLevel)
    }
    
    private func depth(_ node: GeneralNode<T>?) -> Int {
        guard let node = node else { return 0 }
        return node.children
            .filter { $0 != nil }
            .reduce(0, { max($0, depth($1)) })
            + 1
    }
    
    private func levels(levelStack: inout [[GeneralNode<T>]]) {
        guard let deepestLevel = levelStack.last else { return }
        var nextLevel: [GeneralNode<T>] = []
        for node in deepestLevel {
            for child in node.children {
                if child != nil { nextLevel.append(child!) }
            }
        }
        if nextLevel.isEmpty { return }
        levelStack.append(nextLevel)
        return levels(levelStack: &levelStack)
    }

}
