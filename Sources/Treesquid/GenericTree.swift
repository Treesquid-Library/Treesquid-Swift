import Foundation

enum TreeNodeOperationError: Error {
    case indexOutOfBounds
    case childCapacityExceeded
}

class TreeNode<T> {
    private(set) var parent: TreeNode<T>?
    lazy var children: [TreeNode<T>?] = []
    private(set) var value: T?
    
    init(value: T?) {
        self.value = value
    }
    
    // O(1)
    subscript(index: Int) -> TreeNode<T>? {
        get {
            children[index]
        }
        set(newChild) {
            children[index] = newChild
        }
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    func append(_ child: TreeNode<T>) throws {
        children.append(child)
    }
    
    // O(n)
    func prepend(_ child: TreeNode<T>) throws {
        children.insert(child, at: 0)
    }
    
    // O(n)
    func insert(_ child: TreeNode<T>, at index: Int) throws {
        children.insert(child, at: index)
    }
}

class GenericTree<T>: Tree {
    var root: TreeNode<T>?
    
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
    
    func append(node: TreeNode<T>) -> GenericTree {
        if root == nil {
            root = node
            return self
        }
        return append(node, depth: 1, level: [root!])
    }
    
    func levels() -> [[TreeNode<T>]] {
        guard let root = root else { return [] }
        var levelStack: [[TreeNode<T>]] = [[root]]
        levels(levelStack: &levelStack)
        return levelStack
    }
    
    //
    // Private functions
    //
    
    private func append(_ newNode: TreeNode<T>, depth: Int, level: [TreeNode<T>]) -> GenericTree<T> {
        var nextLevel: [TreeNode<T>] = []
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
        return append(newNode, depth: depth + 1, level: nextLevel)
    }
    
    private func depth(_ node: TreeNode<T>?) -> Int {
        guard let node = node else { return 0 }
        return node.children
            .filter { $0 != nil }
            .reduce(0, { max($0, depth($1)) })
            + 1
    }
    
    private func levels(levelStack: inout [[TreeNode<T>]]) {
        guard let deepestLevel = levelStack.last else { return }
        var nextLevel: [TreeNode<T>] = []
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
