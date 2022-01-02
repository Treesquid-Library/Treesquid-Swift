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
                  children: Array(repeating: nil, count: keys.count > 0 ? keys.count + 1 : 0) as [BTreeNode?],
                  tree: nil)
    }
    
    internal convenience init(keys: [Key], values: [Value?]) {
        self.init(keys: keys,
                  values: Array(repeating: nil, count: keys.count) as [Value?],
                  children: Array(repeating: nil, count: keys.count > 0 ? keys.count + 1 : 0) as [BTreeNode?],
                  tree: nil)
    }

    internal convenience init(keys: [Key], values: [Value?], children: [BTreeNode?]) {
        self.init(keys: keys,
                  values: Array(repeating: nil, count: keys.count) as [Value?],
                  children: Array(repeating: nil, count: keys.count > 0 ? keys.count + 1 : 0) as [BTreeNode?],
                  tree: nil)
    }
    
    internal init(keys: [Key], values: [Value?], children: [BTreeNode?], tree: BTree<Key, Value>?) {
        self.keys = keys
        self.values = values
        self.children = children
        self.tree = tree
        
        // Overwrite parent for child nodes.
        self.children.forEach { child in child!.parent = self }
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
        for (index, child) in parent.children.enumerated() {
            if child === self { return index }
        }
        return -1
    }
}

/// A B-tree representation where nodes have a key and an optional value associated with them.
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
    private(set) public var m: Int
    
    public init(m: Int) {
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
    
    internal var minChildren: Int { get { Int(ceil(Float(m) / 2)) } }
    internal var minKeys: Int { get { Int(ceil(Float(m) / 2)) - 1 } }
    
    //
    // Tree access
    //
    
    @discardableResult
    func insert(_ value: Value, forKey: Key) -> Tree {
        guard let root = root else {
            self.root = BTreeNode(keys: [forKey], values: [value], children: [], tree: self)
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
    func delete(withKey: Key) -> Tree {
        guard let root = root else { return self }
        let (potentialNode, index) = findForDelete(node: root, key: withKey)
        guard let node = potentialNode else { return self }
        delete(node: node, at: index)
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
        if node.children.count == 0 { return (node, insertionIndex) }
        // if insertionIndex > node.children.count { return (node, insertionIndex) }
        return findForUpdate(node: node.children[insertionIndex]!, key: key)
    }
    
    func findForDelete(node: Node, key: Key) -> (Node?, Int) {
        let (hasKey, insertionIndex) = node.keys.insertionPoint(value: key)
        if hasKey { return (node, insertionIndex) }
        if node.children.count == 0 { return (nil, insertionIndex) }
        return findForDelete(node: node.children[insertionIndex]!, key: key)
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
        if left != nil || right != nil {
            node.children.insert(left, at: index)
            node.children[index + 1] = right
            left?.parent = node
            right?.parent = node
        }
        if node.keys.count <= m - 1 { return }
        let splitIndex = node.keys.count / 2
        let childrenLeft = node.children.count > 0 ? Array(node.children[...splitIndex]) : []
        let childrenRight = node.children.count > 0 ? Array(node.children[(splitIndex + 1)...]) : []
        let splitLeft = BTreeNode(keys: Array(node.keys[..<splitIndex]),
                                  values: Array(node.values[..<splitIndex]),
                                  children: childrenLeft,
                                  tree: self)
        let splitRight = BTreeNode(keys: Array(node.keys[(splitIndex + 1)...]),
                                   values: Array(node.values[(splitIndex + 1)...]),
                                   children: childrenRight,
                                   tree: self)
        if node.parent == nil {
            // We are at the root!
            root = BTreeNode(keys: [node.keys[splitIndex]],
                             values: [node.values[splitIndex]],
                             children: [splitLeft, splitRight],
                             tree: self)
            return
        }
        let parentNode = node.parent!
        let (_, indexInParent) = parentNode.keys.insertionPoint(value: key)
        insert(node: parentNode,
               left: splitLeft,
               right: splitRight,
               key: node.keys[splitIndex],
               value: node.values[splitIndex],
               at: indexInParent)
    }
    
    func delete(node: Node, at index: Int) {
        if node.children.count == 0 {
            node.keys.remove(at: index)
            node.values.remove(at: index)
            if node === root {
                // Special case: root node!
                if node.keys.isEmpty {
                    root = nil
                }
                return
            }
            if node.keys.count >= minKeys {
                // Enough keys left:
                return
            }
            // Here there are fewer than ceil(m / 2) children in the node left (underflow):
            handleUnderflow(node)
            return
        }
        // TODO: Find both predecessor and successor, then delete from whichever is fuller.
        let inOrderPredecessorNode = findInOrderPredecessorNode(node.children[index]!)
        let inOrderPredecessorKey = inOrderPredecessorNode.keys.removeLast()
        let inOrderPredecessorValue = inOrderPredecessorNode.values.removeLast()
        if inOrderPredecessorNode.children.count > 0 {
            inOrderPredecessorNode.children.removeLast()
        }
        node.keys[index] = inOrderPredecessorKey
        node.values[index] = inOrderPredecessorValue
        if inOrderPredecessorNode.keys.count >= minKeys {
            return
        }
        // In-order predecessor node has fewer than ceil(m / 2) children left now (underflow):
        handleUnderflow(inOrderPredecessorNode)
    }
    
    internal func handleUnderflow(_ node: Node) {
        let (indexInParent, fullestSibling, direction) = findFullestSibling(node)
        if fullestSibling.keys.count > minKeys {
            // Transfer 1x (key, value, child) from sibling:
            if direction == 1 {
                node.keys.append(node.parent!.keys[indexInParent])
                node.values.append(node.parent!.values[indexInParent])
                if node.children.count > 0 {
                    let transferredChild = fullestSibling.children.removeFirst()!
                    transferredChild.parent = node
                    node.children.append(transferredChild)
                }
                node.parent!.keys[indexInParent] = fullestSibling.keys.removeFirst()
                node.parent!.values[indexInParent] = fullestSibling.values.removeFirst()
            } else {
                node.keys.insert(node.parent!.keys[indexInParent - 1], at: 0)
                node.values.insert(node.parent!.values[indexInParent - 1], at: 0)
                if node.children.count > 0 {
                    let transferredChild = fullestSibling.children.removeLast()!
                    transferredChild.parent = node
                    node.children.insert(transferredChild, at: 0)
                }
                node.parent!.keys[indexInParent - 1] = fullestSibling.keys.removeLast()
                node.parent!.values[indexInParent - 1] = fullestSibling.values.removeLast()
            }
            return
        }
        // Merge nodes:
        let mergedNode: BTreeNode<Key, Value>
        if direction == 1 {
            let mergedKeys = node.keys + [node.parent!.keys.remove(at: indexInParent)] + fullestSibling.keys
            let mergedValues = node.values + [node.parent!.values.remove(at: indexInParent)] + fullestSibling.values
            let mergedChildren = node.children + fullestSibling.children
            node.parent!.children.remove(at: indexInParent)
            node.parent!.children.remove(at: indexInParent)
            mergedNode = BTreeNode(keys: mergedKeys, values: mergedValues, children: mergedChildren, tree: self)
        } else {
            let mergedKeys = fullestSibling.keys + [node.parent!.keys.remove(at: indexInParent - 1)] + node.keys
            let mergedValues = fullestSibling.values + [node.parent!.values.remove(at: indexInParent - 1)] + node.values
            let mergedChildren = fullestSibling.children + node.children
            node.parent!.children.remove(at: indexInParent - 1)
            node.parent!.children.remove(at: indexInParent - 1)
            mergedNode = BTreeNode(keys: mergedKeys, values: mergedValues, children: mergedChildren, tree: self)
        }
        if node.parent === root {
            // Parent is the root node, which might be empty now. Check for that...
            if node.parent!.keys.count == 0 {
                root = mergedNode
                return
            }
            mergedNode.parent = node.parent
            node.parent!.children.insert(mergedNode, at: direction == 1 ? indexInParent : indexInParent - 1)
            return
        }
        mergedNode.parent = node.parent
        node.parent!.children.insert(mergedNode, at: direction == 1 ? indexInParent : indexInParent - 1)
        if node.parent!.keys.count < minKeys {
            // New underflow in parent:
            handleUnderflow(node.parent!)
        }
    }

    internal func findFullestSibling(_ node: Node) -> (Int, Node, Int) {
        // Find fullest sibling:
        let indexInParent = node.indexInParent()
        let leftSibling = indexInParent > 0 ? node.parent!.children[indexInParent - 1] : nil
        let rightSibling = indexInParent < node.parent!.children.count - 1 ? node.parent!.children[indexInParent + 1] : nil
        if leftSibling == nil {
            return (indexInParent, rightSibling!, 1)
        } else if rightSibling == nil {
            return (indexInParent, leftSibling!, -1)
        } else {
            if leftSibling!.keys.count >= rightSibling!.keys.count {
                return (indexInParent, leftSibling!, -1)
            } else {
                return (indexInParent, rightSibling!, 1)
            }
        }
    }
    
    internal func findInOrderPredecessorNode(_ node: Node) -> Node {
        if node.children.count == 0 { return node }
        guard let rightMostChild = node.children.last! else {
            return node
        }
        if rightMostChild.keys.count == 0 {
            return node
        }
        return findInOrderPredecessorNode(rightMostChild)
    }
}
