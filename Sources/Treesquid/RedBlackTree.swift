import Foundation

// Note: This implementation does not enumerate the child indexes
//       as left/right, because index-arithmetic is being used.
//       Using an enumeration would make overshadow that left/right
//       must be assigned to 0/1.
public class RedBlackTreeNode<Key: Comparable, Value>: GenericNode {
    public typealias Node = RedBlackTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    internal var red: Bool
    internal var parent: Node?
    internal var grandparent: Node? {
        get {
            guard let parent = parent else { return nil }
            return parent.parent
        }
    }
    internal var sibling: Node? {
        get {
            guard let parent = parent else { return nil }
            return parent.children[1 - indexIn(parent: parent)]
        }
    }
    internal var uncle: Node? {
        get {
            guard let parent = parent else { return nil }
            return parent.sibling
        }
    }
    internal var closeNephew: Node? {
        get {
            guard let parent = parent else { return nil }
            guard let sibling = sibling else { return nil }
            return sibling.children[indexIn(parent: parent)]
        }
    }
    internal var distantNephew: Node? {
        get {
            guard let parent = parent else { return nil }
            guard let sibling = sibling else { return nil }
            return sibling.children[1 - indexIn(parent: parent)]
        }
    }
    internal lazy var children: [Node?] = [ nil, nil ]
    private(set) public var key: Key
    private(set) public var value: Value?
    
    internal convenience init(key: Key) {
        self.init(red: true, key: key, value: nil)
    }
    
    internal convenience init(red: Bool, key: Key) {
        self.init(red: red, key: key, value: nil)
    }
    
    internal init(red: Bool, key: Key, value: Value?) {
        self.red = red
        self.key = key
        self.value = value
    }
    
    //
    // Node properties
    //
    
    public func degree() -> Int {
        Treesquid.degree(of: self)
    }
    
    public func capacity() -> Int {
        Treesquid.capacity(of: self)
    }
    
    //
    // Child access (internal)
    //
    
    // O(1)
    @discardableResult
    internal func append(_ child: Node) throws -> Node {
        for childIndex in 0..<children.count {
            if children[childIndex] == nil {
                child.parent = self;
                children[childIndex] = child
                return self
            }
        }
        throw NodeOperationError.childCapacityExceeded
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
        children[childAt] = node as? RedBlackTreeNode<Key, Value>
        return self
    }
    
    //
    // Private helpers for calculating siblings and nephews.
    //
    internal func indexInParent() -> Int {
        return indexIn(parent: parent!)
    }
    
    internal func indexIn(parent: Node) -> Int {
        return parent.children[0] === self ? 0 : 1
    }
}

public class RedBlackTree<Key: Comparable, Value>: GenericTree {
    typealias Tree = RedBlackTree<Key, Value>
    typealias Node = RedBlackTreeNode<Key, Value>

    private enum InsertCases {
        case three
        case four
        case fiveSix
    }
    
    var root: Node?
    
    func isEmpty() -> Bool {
        return root == nil
    }
    
    func width() -> Int {
        return Treesquid.width(of: self)
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
    
    @discardableResult
    func insert(node: Node) -> Tree {
        let (parent, direction) = findForInsert(key: node.key)
        if direction == -1 && parent != nil {
            // TODO
            return self
        }
        do {
            try insert(parent: parent, insert: node, direction: direction)
        } catch {
            // TODO
        }
        return self
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
        return insert(node: node)
    }
    
    //
    // Red/black tree implementation.
    //
    
    public func find(key: Key) -> RedBlackTreeNode<Key, Value>? {
        var node = root
        while node != nil {
            if node!.key == key {
                return node
            }
            if node!.key > key {
                node = node!.children[0]
            } else {
                node = node!.children[1]
            }
        }
        return nil
    }
    
    func findForInsert(key: Key) -> (Node?, Int) {
        var node = root
        while node != nil {
            if node!.key == key {
                return (node, -1)
            }
            if node!.key > key {
                let child = node!.children[0]
                if child == nil {
                    return (node, 0)
                }
                node = child
            } else {
                let child = node!.children[1]
                if child == nil {
                    return (node, 1)
                }
                node = child
            }
        }
        return (nil, -1)
    }
    
    // Note: For `direction`, see the note on `RedBlackTreeNote` about
    //       why enumerations are not used.
    @discardableResult
    func rotate(parent: Node, direction: Int) throws -> Node {
        guard let sibling = parent.children[1 - direction] else {
            throw NodeOperationError.invalidTreeConfiguration
        }
        let grandparent = parent.parent
        let closeNephew = sibling.children[direction]
        parent.children[1 - direction] = closeNephew
        if closeNephew != nil {
            closeNephew!.parent = parent
        }
        sibling.children[direction] = parent
        parent.parent = sibling
        sibling.parent = grandparent
        if grandparent != nil {
            grandparent!.children[parent === grandparent!.children[1] ? 1 : 0] = sibling
        } else {
            root = sibling
        }
        return sibling
    }
    
    func insert(parent: Node?, insert newNode: Node, direction insertDirection: Int) throws {
        var node = newNode
        node.red = true
        node.parent = parent
        if parent == nil {
            root = node
            return
        }
        var direction = insertDirection
        parent!.children[direction] = node
        var iterativeParent: Node? = parent
        var grandparent: Node? = nil
        var nextCase = RedBlackTree.InsertCases.three
        repeat {
            // Case 1:
            if !iterativeParent!.red {
                // Parent is black, new node is red. All done!
                return
            }
            grandparent = iterativeParent!.parent
            if grandparent == nil {
                nextCase = RedBlackTree.InsertCases.four
                break;
            }
            direction = iterativeParent!.indexInParent()
            let uncle = grandparent!.children[1 - direction]
            if uncle == nil || !uncle!.red {
                nextCase = RedBlackTree.InsertCases.fiveSix
                break
            }
            // Case 2:
            iterativeParent!.red = false
            uncle!.red = false
            grandparent!.red = true
            node = grandparent!
            iterativeParent = node.parent
        } while(iterativeParent != nil)
        // Case 3: Parent is nil.
        if nextCase == RedBlackTree.InsertCases.three {
            return
        }
        // Case 4: Parent is root and red.
        if nextCase == RedBlackTree.InsertCases.four {
            iterativeParent!.red = false
            return
        }
        // Parent is red and uncle is black.
        if nextCase == RedBlackTree.InsertCases.fiveSix {
            // Case 5:
            if node === iterativeParent!.children[1 - direction] {
                try rotate(parent: iterativeParent!, direction: direction)
                node = iterativeParent!
                iterativeParent = grandparent!.children[direction]
            }
            // Case 6: Parent is red, uncle is black, and nephew is an
            //         outter grandchild of the grandparent.
            try rotate(parent: grandparent!, direction: 1 - direction)
            iterativeParent!.red = false
            grandparent!.red = true
        }
    }
}
