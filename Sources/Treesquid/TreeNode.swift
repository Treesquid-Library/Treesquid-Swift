import Foundation

class TreeNode<T> {
    private(set) var parent: TreeNode?
    lazy var children: [TreeNode?] = []
    private(set) var value: T
    
    init(value: T) {
        self.value = value
    }
    
    // O(1)
    subscript(index: Int) -> TreeNode? {
        get {
            children[index]
        }
        set(newChild) {
            children[index] = newChild
        }
    }
    
    // O(n), but might be O(1) if no space reallocation is necessary.
    func append(_ child: TreeNode) {
        children.append(child)
    }
    
    // O(n)
    func prepend(_ child: TreeNode) {
        children.insert(child, at: 0)
    }
    
    // O(n)
    func insert(_ child: TreeNode, at index: Int) {
        children.insert(child, at: index)
    }
}
