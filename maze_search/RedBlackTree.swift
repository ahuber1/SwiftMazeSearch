//
//  RedBlackTree.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

enum RBT_Traversal_Type {
    /** In-Order traversal (left child, current node, right child) */
    case InOrder
    
    /** Pre-Order traversal (current node, left child, right child) */
    case PreOrder
    
    /** Post-Order traversal (left child, right child, current node) */
    case PostOrder
}

class RedBlackTree<T>: CustomStringConvertible where T: Comparable, T: CustomStringConvertible {
    
    ////////////////////////////////////////////////////////
    // Public properties
    ////////////////////////////////////////////////////////
    
    var traversalType: RBT_Traversal_Type // Used by traverse() to determine how it should traverse the tree
    var numberOfNodes: Int { return numNodes }
    var description: String {
        var returnVal = ""
        
        traverse(onNodeTouched: { (contents: Node<T>) -> () in
            returnVal += "\(contents)\n\n"
        })
        
        if returnVal != "" {
            return returnVal.substring(to: returnVal.index(returnVal.endIndex, offsetBy: -1))
        }
        else {
            return "Empty"
        }
    }
    
    ////////////////////////////////////////////////////////
    // Private properties
    ////////////////////////////////////////////////////////
    
    private var root: Node<T>? = nil
    private var numNodes = 0
    
    /**
     Creates a new Red Black Tree.
     
     - parameters:
        - traversalType: This is the type of traversal that is used when one gets a string representation of this Red Black Tree.
    */
    init(traversalType: RBT_Traversal_Type) {
        self.traversalType = traversalType
    }
    
    /**
     Creates a new Red Black Tree with an in-order traversal (i.e., when one gets a string representation of this Red Black Tree,
     an in-order traversal is used).
    */
    convenience init() {
        self.init(traversalType: .InOrder)
    }
    
    
    /**

     Inserts a new item into the Red Black Tree.
     
     - parameters:
        - data: the data to insert into the Red Black Tree
     
     - returns: `true` if `data` was successfully inserted into the Red Black Tree, `false` if it already exists in the tree.
     
    */
    func insert(_ data: T) -> Bool {
        return insert(data: data, node: root, parent: nil, grandparent: nil)
    }
    
    private func insert(data: T, node nodeOp: Node<T>?, parent parentOp: Node<T>?, grandparent grandparentOp: Node<T>?) -> Bool {
        // If we have to keep going down the tree (i.e., if there is a node)
        if let node = nodeOp {
            if let nodeData = node.data {
                if data < nodeData {
                    return insert(data: data, node: node.left, parent: node, grandparent: parentOp)
                }
                else if data > nodeData {
                    return insert(data: data, node: node.right, parent: node, grandparent: parentOp)
                }
                else {
                    return false // data already exists in the tree
                }
            }
        }
        
        let newNode: Node<T>
        
        // If we have have to add a node and it is NOT the root (i.e., if there is no node, but there is a parent)
        if let parent = parentOp {
            newNode = Node<T>(data: data)
            
            if data < parent.data! {
                parent.left = newNode
            }
            else {
                parent.right = newNode
            }
            
            newNode.parent = parent
        }
            // Add data as the root (i.e., if there is no node or a parent node)
        else {
            newNode = Node<T>(data: data)
            root = newNode
        }
        
        numNodes += 1
        insertCase1(newNode)
        return true
    }
    
    private func insertCase1(_ node: Node<T>) {
        if node.parent == nil {
            node.color = .Black
        }
        else {
            insertCase2(node)
        }
    }
    
    private func insertCase2(_ node: Node<T>) {
        assert(node.parent != nil)
        
        if node.parent!.color == .Black {
            return // Tree is still valid
        }
        else {
            insertCase3(node)
        }
    }
    
    private func insertCase3(_ node: Node<T>) {
        assert(node.parent != nil)
        
        let uncleOp = uncle(ofNode: node)
        
        // If unc exists AND its color is Red
        if uncleOp?.color == .Red {
            let unc = uncleOp!
            let gp = grandparent(ofNode: node)! // if there is an uncle, then there is a grandparent
            
            node.parent!.color = .Black
            unc.color = .Black
            gp.color = .Red
            insertCase1(gp)
        }
        else {
            insertCase4(node)
        }
        
    }
    
    private func insertCase4(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(grandparent(ofNode: node) != nil)
        
        var node = node // makes node a variable, not a constant
        let gp = grandparent(ofNode: node)! // There must be a grandparent if we have gotten to this stage
        
        if (node == node.parent!.right) && (node.parent == gp.left) {
            rotateLeft(node.parent!)
            node = node.left!
        }
        else if (node == node.parent!.left) && (node.parent == gp.right) {
            rotateRight(node.parent!)
            node = node.right!
        }
        
        insertCase5(node)
    }
    
    private func insertCase5(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(grandparent(ofNode: node) != nil)
        
        let gp = grandparent(ofNode: node)! // There must be a grandparent if we have gotten to this stage
        
        node.parent!.color = .Black
        gp.color = .Red
        
        if node == node.parent!.left {
            rotateRight(gp)
        }
        else {
            rotateLeft(gp)
        }
    }
    
    
    /**
     
     Removes an item from the Red Black Tree
     
     - parameters:
        - data: the data to remove
     
     - returns: the data that was removed or `nil` if it does not exist in the tree.
     
     */
    func remove(_ data: T) -> T? {
        if let returnData = remove(data: data, node: root) {
            numNodes -= 1
            return returnData
        }
        else {
            return nil
        }
    }
    
    private func remove(data: T, node nodeOp: Node<T>?) -> T? {
        if let node = nodeOp {
            // If we reached a null node 
            if node.data == nil {
                return nil
            }
            // If we have to go left
            if data < node.data! {
                return remove(data: data, node: node.left)
            }
            // If we have to go right
            else if data > node.data! {
                return remove(data: data, node: node.right)
            }
            // If the node has TWO children
            else if node.hasLeftChild && node.hasRightChild {
                if let predecessor = inOrderPredecessor(ofNode: node) {
                    swapNodeData(node1: node, node2: predecessor)
                    return remove(data: data, node: predecessor)
                }
                else {
                    let successor = inOrderSuccessor(ofNode: node)!
                    swapNodeData(node1: node, node2: successor)
                    return remove(data: data, node: successor)
                }
            }
            // If the node has no more than one child
            else {
                
                /*
                    If M is a red node, we simply replace it with its child C, which must be black by property 4. (This can only
                    occur when M has two leaf children, because if the red node M had a black non-leaf child on one side but just
                    a leaf child on the other side, then the count of black nodes on both sides would be different, thus the tree
                    would violate property 5.) All paths through the deleted node will simply pass through one fewer red node, and
                    both the deleted node's parent and child must be black, so property 3 (all leaves are black) and property 4
                    (both children of every red node are black) still hold.
                */
                
                if node.color == .Red {
                    print("Simple Case 1")
                    let returnVal = node.data
                    _ = deleteOneChild(node)
                    return returnVal
                }
                
                /*
                    Another simple case is when M is black and C is red. Simply removing a black node could break Properties 4 
                    (“Both children of every red node are black”) and 5 (“All paths from any given node to its leaf nodes contain 
                    the same number of black nodes”), but if we repaint C black, both of these properties are preserved.
                 */
                else if color(of: node.left) == .Red || color(of: node.right) == .Red {
                    print("Simple Case 2")
                    let returnVal = node.data
                    let child = deleteOneChild(node)
                    
                    child.color = .Black
                    
                    return returnVal
                }
                
                /*
                    The complex case is when both M and C are black. (This can only occur when deleting a black node which has two 
                    leaf children, because if the black node M had a black non-leaf child on one side but just a leaf child on the 
                    other side, then the count of black nodes on both sides would be different, thus the tree would have been an 
                    invalid red–black tree by violation of property 5.) We begin by replacing M with its child C. We will relabel 
                    this child C (in its new position) N, and its sibling (its new parent's other child) S. (S was previously the 
                    sibling of M.) In the diagrams below, we will also use P for N's new parent (M's old parent), SL for S's left 
                    child, and SR for S's right child (S cannot be a leaf because if M and C were black, then P's one subtree 
                    which included M counted two black-height and thus P's other subtree which includes S must also count two 
                    black-height, which cannot be the case if S is a leaf node).
                */
                else {
                    print("Complex Case")
                    let returnVal = node.data
                    
                    deleteCase1(node)
                    
                    // Nullify the node
                    node.data = nil
                    node.left = nil
                    node.right = nil
                    
                    return returnVal
                }
                
             }
        }
        else {
            return nil // node was not found
        }
    }
    
    /*
        Replaces a node with its child or not; _this includes nodes with __no__ children.
     
        - parameters:
            - node: the node to replace
     
        - returns: the child node
    */
    private func deleteOneChild(_ node: Node<T>) -> Node<T> {
        print("There is a child")
        let child = node.hasLeftChild ? node.left! : node.right!
        if let parent = node.parent {
            if parent.left == node {
                parent.left = child
            }
            else {
                parent.right = child
            }
        }
        else {
            root = child
        }
        
        child.parent = node.parent
        
        //child.left = Node<T>()
        //child.right = Node<T>()
        
        if child.left == nil {
            child.left = Node<T>()
        }
        
        if child.right == nil {
            child.right = Node<T>()
        }
        
        return child
    }
    
    private func deleteCase1(_ node: Node<T>) {
        print("Delete Case 1")
        if node.parent != nil {
            deleteCase2(node)
        }
    }
    
    private func deleteCase2(_ node: Node<T>) {
        print("Delete Case 2")
        assert(node.parent != nil)
        
        let sib = sibling(ofNode: node)
        
        if color(of: sib) == .Red {
            node.parent!.color = .Red
            sib!.color = .Black // if sib's color is red, it exists
        }
        
        if node == node.parent!.left {
            rotateLeft(node.parent!)
        }
        else {
            rotateRight(node.parent!)
        }
        
        deleteCase3(node)
    }
    
    private func deleteCase3(_ node: Node<T>) {
        print("Delete Case 3")
        assert(node.parent != nil)
        
        let sib = sibling(ofNode: node)
        
        if color(of: node.parent) == .Black && color(of: sib) == .Black &&
            color(of: sib?.left) == .Black && color(of: sib?.right) == .Black
        {
            sib?.color = .Red
            deleteCase1(node.parent!)
        }
        else {
            deleteCase4(node)
        }
    }
    
    private func deleteCase4(_ node: Node<T>) {
        print("Delete Case 4")
        assert(node.parent != nil)
        
        let sib = sibling(ofNode: node)
        
        if color(of: node.parent) == .Red && color(of: sib) == .Black &&
            color(of: sib?.left) == .Black && color(of: sib?.right) == .Black
        {
            sib?.color = .Red
            node.parent!.color = .Black
        }
        else {
            deleteCase5(node)
        }
    }
    
    private func deleteCase5(_ node: Node<T>) {
        print("Delete Case 5")
        assert(node.parent != nil)
        assert(sibling(ofNode: node) != nil) // we need to be able to rotate on it
        
        let sib = sibling(ofNode: node)!
        
        if color(of: sib) == .Black {
            if node == node.parent!.left && color(of: sib.right) == .Black && color(of: sib.left) == .Red {
                sib.color = .Red
                sib.left?.color = .Black
                rotateRight(sib)
            }
            else if node == node.parent!.right! && color(of: sib.left) == .Black && color(of: sib.right) == .Red {
                sib.color = .Red
                sib.right?.color = .Black
                rotateLeft(sib)
            }
        }
        
        deleteCase6(node)
    }
    
    private func deleteCase6(_ node: Node<T>) {
        print("Delete Case 6")
        assert(node.parent != nil)
        assert(sibling(ofNode: node) != nil)
        
        let sib = sibling(ofNode: node)!
        
        sib.color = node.parent!.color
        node.parent!.color = .Black
        
        if (node == node.parent!.left) {
            sib.right?.color = .Black
            rotateLeft(node.parent!)
        }
        else {
            sib.left?.color = .Black
            rotateRight(node.parent!)
        }
    }
    
    private func inOrderPredecessor(ofNode node: Node<T>) -> Node<T>? {
        
        func inOrderPredecessorFinder(_ currentNode: Node<T>) -> Node<T>? {
            if currentNode.hasRightChild {
                return inOrderPredecessorFinder(currentNode.right!)
            }
            else {
                assert(currentNode.parent != nil)
                return currentNode
            }
        }
        
        if node.hasLeftChild {
            return inOrderPredecessorFinder(node.left!)
        }
        else {
            return nil
        }
    }
    
    private func inOrderSuccessor(ofNode node: Node<T>) -> Node<T>? {
        
        func inOrderSuccessorFinder(_ currentNode: Node<T>) -> Node<T>? {
            if currentNode.hasLeftChild {
                return inOrderSuccessorFinder(currentNode.left!)
            }
            else {
                assert(currentNode.parent != nil)
                return currentNode
            }
        }
        
        if node.hasRightChild {
            return inOrderSuccessorFinder(node.right!)
        }
        else {
            return nil
        }
    }
    
    private func swapNodeData(node1: Node<T>, node2: Node<T>) {
        let temp = node1.data
        node1.data = node2.data
        node2.data = temp
    }
    
    private func grandparent(ofNode node: Node<T>) -> Node<T>? {
        if let parent = node.parent {
            if let grandparent = parent.parent {
                return grandparent
            }
        }
        
        return nil
    }
    
    private func sibling(ofNode node: Node<T>) -> Node<T>? {
        if let parent = node.parent {
            if let parentLeft = parent.left {
                if parentLeft.data == node.data {
                    return parent.right
                }
                else {
                    return parent.left
                }
            }
        }
        
        return nil
    }
    
    private func uncle(ofNode node: Node<T>) -> Node<T>? {
        if let grandparent = node.parent!.parent {
            if grandparent.left == node.parent! {
                return grandparent.right
            }
            else {
                return grandparent.left
            }
        }
        else {
            return nil
        }
    }
    
    ////////////////////////////////////////////////////////
    // Functions for tree rotations
    ////////////////////////////////////////////////////////
    
    private func rotateLeft(_ root: Node<T>) {
        print("Rotate Left")
        let gp = root.parent
        let pivot = root.right!
        let temp = pivot.left!
        
        pivot.left = root
        root.right = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp.parent = root
        
        // Update the root if necessary
        if gp == nil {
            self.root = pivot
        }
        
        // Make sure the grandparent (gp) now references the correct child
        else {
            if gp!.left == root {
                gp!.left = pivot
            }
            else {
                gp!.right = pivot
            }
        }
    }
    
    private func rotateRight(_ root: Node<T>) {
        print("Rotate Right")
        let gp = root.parent
        let pivot = root.left!
        let temp = pivot.right!
        
        pivot.right = root
        root.left = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp.parent = root
        
        // Update the root if necessary
        if gp == nil {
            self.root = pivot
        }
            
            // Make sure the grandparent (gp) now references the correct child
        else {
            if gp!.left == root {
                gp!.left = pivot
            }
            else {
                gp!.right = pivot
            }
        }
    }
    
    ////////////////////////////////////////////////////////
    // Functions for traversals
    ////////////////////////////////////////////////////////
    
    func traverse(onNodeTouched: (Node<T>) -> ()) {
        switch traversalType {
        case .InOrder:
            inOrderTraversal(root, onNodeTouched: onNodeTouched)
        case .PreOrder:
            preOrderTraversal(root, onNodeTouched: onNodeTouched)
        default:
            postOrderTraversal(root, onNodeTouched: onNodeTouched)
        }
    }
    
//    private func makeNodeContentsStruct(nodeToMakeItFrom node: Node<T>) -> NodeContents<T> {
//        return NodeContents<T>(nodeContents:        node.data,
//                               nodeColor:           node.color,
//                               leftChildContents:   node.left?.data,
//                               rightChildContents:  node.right?.data,
//                               parentContents:      node.parent?.data,
//                               description:         node.description)
//    }
    
    private func inOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                inOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
                inOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func preOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
                preOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                preOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func postOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
            if node.data != nil {
                postOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                postOrderTraversal(node.right, onNodeTouched: onNodeTouched)
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
            }
        }
    }
    
    private func color(of node: Node<T>?) -> RBT_Color {
        return node == nil ? .Black : node!.color
    }
    
    func checkTree() {
        if root != nil && !root!.isNullNode {
            var numNodes = 0
            var numNoParentNodes = 0
            let queue = Queue<Int>()
            
            func checkTree(node: Node<T>, numberOfBlackNodes: Int) {
                if node.isNullNode {
                    assert(node.color == .Black) // check Property 3
                    queue.enqueue(numberOfBlackNodes)
                }
                else {
                    numNodes += 1
                    
                    if node.parent == nil {
                        numNoParentNodes += 1
                    }
                    
                    let numberOfBlackNodes = node.color == .Black ? numberOfBlackNodes + 1 : numberOfBlackNodes
                    
                    if node.color == .Red {
                        assert(color(of: node.left) == .Black && color(of: node.right) == .Black) // assert Property 4
                    }
                    
                    checkTree(node: node.left!, numberOfBlackNodes: numberOfBlackNodes)
                    checkTree(node: node.right!, numberOfBlackNodes: numberOfBlackNodes)
                }
            }
            
            checkTree(node: root!, numberOfBlackNodes: 0)
            
            assert(root!.color == .Black) // checks Property 2
            assert(numNodes == numberOfNodes) // ensures the tree is structured properly
            assert(numNoParentNodes == 1) // ensures the tree is structured properly
            
            var headVal = queue.peek()
            
            while queue.length > 0 {
                let dequeuedValue = queue.dequeue()!
                assert(headVal == dequeuedValue) // checks Property 5
                headVal = dequeuedValue
            }
        }
    }
}

enum RBT_Color : CustomStringConvertible {
    case Red, Black
    
    var description: String {
        switch self {
        case .Red:
            return "Red"
        default:
            return "Black"
        }
    }
}

public class Node<T> : CustomStringConvertible, Equatable where T: Comparable, T: CustomStringConvertible {
    var data: T? = nil
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
    
    var isNullNode: Bool { return data == nil }
    var hasLeftChild: Bool { return left != nil && left!.isNullNode == false }
    var hasRightChild: Bool { return right != nil && right!.isNullNode == false }
    var color: RBT_Color {
        set {
            rbtColor = (data == nil ? .Black : newValue)
        }
        get {
            if data == nil {
                rbtColor = .Black
            }
            
            return rbtColor
        }
    }
    public var description: String {
        let nodeDescription   = "  NODE: \(data) (\(color))"
        let parentDescription = "PARENT: " + (parent == nil ? "nil" : (parent!.data == nil ? "null node" : parent!.data!.description))
        let leftDescription   = "  LEFT: " + (  left == nil ? "nil" : (  left!.data == nil ? "null node" :   left!.data!.description))
        let rightDescription  = " RIGHT: " + ( right == nil ? "nil" : ( right!.data == nil ? "null node" :  right!.data!.description))
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    
    private var rbtColor = RBT_Color.Black // set it to a value; may (and probably will) change in init
    
    init(data: T) {
        self.data = data
        self.color = .Red
        self.left = Node<T>()
        self.right = Node<T>()
    }
    
    init() {
        // Use default values
    }
    
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

//struct NodeContents<T: Comparable> : CustomStringConvertible, Equatable {
//    var nodeContents: T?
//    var nodeColor: RBT_Color
//    var leftChildContents: T?
//    var rightChildContents: T?
//    var parentContents: T?
//    var description: String 
//    
//    public static func ==(lhs: NodeContents<T>, rhs: NodeContents<T>) -> Bool {
//        return lhs.nodeContents == rhs.nodeContents
//    }
//}
