import Foundation

enum NodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
}

class Node<T> {
    private(set) var parent: Node<T>?
    lazy var children: [Node<T>?] = []
    private(set) var value: T?
    
    init(value: T?) {
        self.value = value
    }
    
    // O(1)
    subscript(index: Int) -> Node<T>? {
        get {
            children[index]
        }
        set(newChild) {
            children[index] = newChild
        }
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    @discardableResult func append(_ child: Node<T>) throws -> Node<T> {
        children.append(child)
        return self
    }
    
    // O(n)
    @discardableResult func prepend(_ child: Node<T>) throws -> Node<T> {
        children.insert(child, at: 0)
        return self
    }
    
    // O(n)
    @discardableResult func insert(_ child: Node<T>, at index: Int) throws -> Node<T> {
        children.insert(child, at: index)
        return self
    }
}

class GeneralTree<T>: Tree {
    var root: Node<T>?
    
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
    
    @discardableResult func insert(node: Node<T>) -> GeneralTree {
        if root == nil {
            root = node
            return self
        }
        return insert(node, depth: 1, level: [root!])
    }
    
    func levels() -> [[Node<T>]] {
        guard let root = root else { return [] }
        var levelStack: [[Node<T>]] = [[root]]
        levels(levelStack: &levelStack)
        return levelStack
    }
    
    //
    // Private functions
    //
    
    private func insert(_ newNode: Node<T>, depth: Int, level: [Node<T>]) -> GeneralTree<T> {
        var nextLevel: [Node<T>] = []
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
    
    private func depth(_ node: Node<T>?) -> Int {
        guard let node = node else { return 0 }
        return node.children
            .filter { $0 != nil }
            .reduce(0, { max($0, depth($1)) })
            + 1
    }
    
    private func levels(levelStack: inout [[Node<T>]]) {
        guard let deepestLevel = levelStack.last else { return }
        var nextLevel: [Node<T>] = []
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
