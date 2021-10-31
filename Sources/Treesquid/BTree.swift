import Foundation

public class BTreeNode<Key: Comparable, Value>: KeyArrayNode, GenericNode {
    public typealias Node = BTreeNode<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    internal(set) public var parent: Node?
    internal var children: [Node?] = []
    internal(set) public var keys: [Key]
    internal(set) public var values: [Value?]
    
    internal var tree: BTree<Key, Value>?
    
    internal convenience init(keys: [Key]) {
        self.init(keys: keys,
                  values: Array(repeating: nil, count: keys.count) as [Value?],
                  children: Array(repeating: nil, count: keys.count) as [BTreeNode?],
                  tree: nil)
    }
    
    internal convenience init(keys: [Key], values: [Value?]) {
        self.init(keys: keys,
                  values: Array(repeating: nil, count: keys.count) as [Value?],
                  children: Array(repeating: nil, count: keys.count) as [BTreeNode?],
                  tree: nil)
    }

    internal convenience init(keys: [Key], values: [Value?], children: [BTreeNode?]) {
        self.init(keys: keys,
                  values: Array(repeating: nil, count: keys.count) as [Value?],
                  children: Array(repeating: nil, count: keys.count) as [BTreeNode?],
                  tree: nil)
    }
    
    internal init(keys: [Key], values: [Value?], children: [BTreeNode?], tree: BTree<Key, Value>?) {
        self.keys = keys
        self.values = values
        self.children = children
        self.tree = tree
        
        // Overwrite parent for child nodes.
        self.children.forEach { child in child?.parent = self }
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
    
    public func maxDegree() -> Int {
        guard let tree = tree else { return 0 }
        return Int(tree.m)
    }
    
    public subscript(index: Int) -> Node? {
        get {
            child(at: index) as! Node?
        }
        set(newChild) {
            newChild?.parent = self
            children[index] = newChild
        }
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
        children[childAt] = node as? BTreeNode<Key, Value>
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

public class BTreeNodeSlice<Key: Comparable, Value>: Node {
    public typealias Node = BTreeNodeSlice<Key, Value>
    public typealias Key = Key
    public typealias Value = Value
    
    internal(set) public var parent: Node?
    internal var children: [Node?] = [ nil, nil ]
    internal(set) public var key: Key
    internal(set) public var value: Value?
    
    internal convenience init(key: Key) {
        self.init(key: key, value: nil)
    }

    internal init(key: Key, value: Value?) {
        self.key = key
        self.value = value
    }
    
    //
    // Node properties
    //
    
    public func degree() -> Int {
        return children.map { $0 != nil ? 1 : 0 }.reduce(0, { x, y in x + y })
    }
    
    public func capacity() -> Int {
        return children.count
    }
    
    public func maxDegree() -> Int {
        return 2
    }
    
    public subscript(index: Int) -> Node? {
        return children[index]
    }
}

public class BTree<Key: Comparable, Value>: Tree, GenericTree {
    typealias Tree = BTree<Key, Value>
    typealias Node = BTreeNode<Key, Value>

    var root: Node?
    private(set) public var m: UInt
    
    public init(m: UInt) {
        self.m = m
    }
    
    public func isEmpty() -> Bool {
        return root == nil
    }
    
    public func width() -> Int {
        return Treesquid.width(of: self)
    }
    
    public func count() -> Int {
        return Treesquid.count(of: self)
    }
    
    public func depth() -> Int {
        return Treesquid.depth(of: self)
    }
    
    //
    // Tree access
    //
    
    @discardableResult
    func insert(_ value: Value, forKey: Key) -> Tree {
        guard let root = root else {
            self.root = BTreeNode(keys: [forKey], values: [value], children: [nil, nil], tree: self)
            return self
        }
        let (node, index) = findForUpdate(node: root, key: forKey)
        if index < node.keys.count && node.keys[index] == forKey {
            // Key already exists: replace value.
            node.values[index] = value
            return self
        }
        insert(node: node, left: nil, right: nil, key: forKey, value: value, at: index)
        return self
    }
    
    // Removes the node with the matching key. If no node with a matching
    // key is found, then the tree is not being altered.
    @discardableResult
    func delete(key: Key) -> Tree {
        // TODO
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
    
    public func find(key: Key) -> BTreeNodeSlice<Key, Value>? {
        guard let root = root else { return nil }
        return find(node: root, key: key)
    }
    
    func find(node: Node, key: Key) -> BTreeNodeSlice<Key, Value>? {
        let (hasKey, insertionIndex) = node.keys.insertionPoint(value: key)
        if hasKey { return BTreeNodeSlice(key: key, value: node.values[insertionIndex]) }
        let child = node.children[insertionIndex]
        if child == nil { return nil }
        return find(node: child!, key: key)
    }
    
    func findForUpdate(key: Key) -> (Node?, Int) {
        guard let root = root else { return (nil, 0) }
        return findForUpdate(node: root, key: key)
    }
    
    func findForUpdate(node: Node, key: Key) -> (Node, Int) {
        let (hasKey, insertionIndex) = node.keys.insertionPoint(value: key)
        if hasKey { return (node, insertionIndex) }
        let child = node.children[insertionIndex]
        if child == nil { return (node, insertionIndex) }
        return findForUpdate(node: child!, key: key)
    }

    // Note: For `direction`, see the note on `RedBlackTreeNote` about
    //       why enumerations are not used.
    @discardableResult
    func rotate(parent: Node, direction: Int) throws -> Node {
        // TODO
        return root!
    }
    
    func insert(node: Node, left: Node?, right: Node?, key: Key, value: Value?, at index: Int) {
        node.keys.insert(key, at: index)
        node.values.insert(value, at: index)
        node.children.insert(left, at: index)
        node.children[index + 1] = right
        left?.parent = node
        right?.parent = node
        if node.keys.count <= m - 1 { return }
        let splitIndex = node.keys.count / 2
        let splitLeft = BTreeNode(keys: Array(node.keys[..<splitIndex]),
                                  values: Array(node.values[..<splitIndex]),
                                  children: Array(node.children[...splitIndex]),
                                  tree: self)
        let splitRight = BTreeNode(keys: Array(node.keys[(splitIndex + 1)...]),
                                   values: Array(node.values[(splitIndex + 1)...]),
                                   children: Array(node.children[(splitIndex + 1)...]),
                                   tree: self)
        if node.parent == nil {
            // We are at the root!
            root = BTreeNode(keys: [node.keys[splitIndex]],
                             values: [node.values[splitIndex]],
                             children: [splitLeft, splitRight],
                             tree: self)
            return
        }
        let (_, indexInParent) = node.parent!.keys.insertionPoint(value: key)
        insert(node: node.parent!,
               left: splitLeft,
               right: splitRight,
               key: node.keys[splitIndex],
               value: node.values[splitIndex],
               at: indexInParent)
    }
    
    @discardableResult
    func delete(node: Node) -> Tree {
        // TODO
        return self
    }
    
    func deleteLeaf(node deleteNode: Node) throws -> Tree {
        // TODO
        return self
    }
}
