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
<<<<<<< HEAD
        if let node = nodeOp, let nodeData = node.data {
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
        else {
            let newNode: Node<T>
            
            // If we have have to add a node and it is NOT the root (i.e., if there is no node, but there is a parent)
            if let parent = parentOp {
                newNode = Node<T>(data: data)
                
                if data < parent.data! {
                    parent.left = newNode
=======
        if let node = nodeOp {
            if let nodeData = node.data {
                if data < nodeData {
                    return insert(data: data, node: node.left, parent: node, grandparent: parentOp)
                }
                else if data > nodeData {
                    return insert(data: data, node: node.right, parent: node, grandparent: parentOp)
>>>>>>> fix_removal
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
        
        // If unc exists AND its color is Red
        if node.uncle?.color == .Red {
            node.parent!.color = .Black
            node.uncle!.color = .Black
            node.grandparent!.color = .Red
            insertCase1(node.grandparent!)
        }
        else {
            insertCase4(node)
        }
        
    }
    
    private func insertCase4(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(node.grandparent != nil)
        
        var node = node // makes node a variable, not a constant
        
        if (node == node.parent!.right) && (node.parent == node.grandparent!.left) {
            rotateLeft(node.parent!)
            node = node.left!
        }
        else if (node == node.parent!.left) && (node.parent == node.grandparent!.right) {
            rotateRight(node.parent!)
            node = node.right!
        }
        
        insertCase5(node)
    }
    
    private func insertCase5(_ node: Node<T>) {
        assert(node.parent != nil)
        assert(node.grandparent != nil)
        
        node.parent!.color = .Black
        node.grandparent!.color = .Red
        
        if node == node.parent!.left {
            rotateRight(node.grandparent!)
        }
        else {
            rotateLeft(node.grandparent!)
        }
    }
    
    
    /**
     
     Removes an item from the Red Black Tree
     
     - parameters:
        - data: the data to remove
     
     - returns: the data that was removed or `nil` if it does not exist in the tree.
     
     */
    func remove(_ data: T) -> T? {
        if root != nil {
            if let returnData = remove(data: data, node: root!) {
                numNodes -= 1
                return returnData
            }
        }
        
        return nil
    }
    
    private func remove(data: T, node nodeOp: Node<T>?) -> T? {
        if let node = nodeOp {
<<<<<<< HEAD
            if let nodeData = node.data {
                // If we have to go left
                if data < nodeData {
                    return remove(data: data, node: node.left)
=======
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
>>>>>>> fix_removal
                }
                    // If we have to go right
                else if data > nodeData {
                    return remove(data: data, node: node.right)
                }
<<<<<<< HEAD
                    // If the node has TWO children
                else if node.hasALeftChild && node.hasARightChild {
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
                // If there are NO children
                else if !node.hasALeftChild && !node.hasARightChild {
                    let returnVal = node.data!
                    node.nullify()
                    return returnVal
                }
                else {
                    let returnVal = node.data!
                    deleteOneChild(node)
                    return returnVal
                }
            }
            else {
                return nil
=======
            }
            // If the node has no more than one child
            else {
                let returnVal = node.data
                
                if node.color == .Red {
                    // This can only occur when node has no children
                    node.nullify()
                }
                // node.color must be black at this point
                else if node.child.color == .Red {
                    replaceNode(node: node, child: node.child)
                    node.child.color = .Black
                }
                else {
                    // The node is black and there are two leaf children
                    replaceNode(node: node, child: node.child)
                    deleteCase1(node.child)
                }
                
                return returnVal
>>>>>>> fix_removal
            }
        }
        else {
            return nil // node was not found
        }
    }
    
<<<<<<< HEAD
    private func deleteOneChild(_ node: Node<T>) {
        // Assert there is only ONE child
        assert((node.hasALeftChild || node.hasARightChild) && !(node.hasALeftChild && node.hasARightChild))
        
        let child = node.hasALeftChild ? node.left! : node.right!
        
        replaceNode(node: node, child: child)
        
        if node.color == .Black {
            if child.color == .Red {
                child.color = .Black
            }
            else {
                deleteCase1(child)
            }
        }
    }
    
    private func replaceNode(node: Node<T>, child: Node<T>) {
        child.parent = node.parent
        
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
    }
    
=======
>>>>>>> fix_removal
    private func deleteCase1(_ node: Node<T>) {
        if node.parent != nil {
            deleteCase2(node)
        }
    }
    
    private func deleteCase2(_ node: Node<T>) {
        let sibling = node.sibling!
        
        if sibling.color == .Red {
            node.parent!.color = .Red
<<<<<<< HEAD
            sib.color = .Black // if sib's color is red, it exists
        }
        
        if node == node.parent!.left {
            rotateLeft(node.parent!)
        }
        else {
            rotateRight(node.parent!)
=======
            sibling.color = .Black
            
            if node == node.parent!.left {
                rotateLeft(node.parent!)
            }
            else {
                rotateRight(node.parent!)
            }
>>>>>>> fix_removal
        }
        
        deleteCase3(node)
    }
    
    private func deleteCase3(_ node: Node<T>) {
        let sibling = node.sibling!
        
<<<<<<< HEAD
        if color(of: node.parent) == .Black && color(of: sib) == .Black &&
            color(of: sib.left) == .Black && color(of: sib.right) == .Black
        {
            sib.color = .Red
=======
        if (node.parent!.color == .Black) &&
            (sibling.color == .Black) &&
            (sibling.left!.color == .Black) &&
            (sibling.right!.color == .Black)
        {
            sibling.color = .Red
>>>>>>> fix_removal
            deleteCase1(node.parent!)
        }
        else {
            deleteCase4(node)
        }
    }
    
    private func deleteCase4(_ node: Node<T>) {
        let sibling = node.sibling!
        
<<<<<<< HEAD
        if color(of: node.parent) == .Red && color(of: sib) == .Black &&
            color(of: sib.left) == .Black && color(of: sib.right) == .Black
        {
            sib.color = .Red
=======
        if (node.parent!.color == .Red) &&
            (sibling.color == .Black) &&
            (sibling.left!.color == .Black) &&
            (sibling.right!.color == .Black)
        {
            sibling.color = .Red
>>>>>>> fix_removal
            node.parent!.color = .Black
        }
        else {
            deleteCase5(node)
        }
    }
    
    private func deleteCase5(_ node: Node<T>) {
<<<<<<< HEAD
        assert(node.parent != nil)
        
        let sib = sibling(ofNode: node)
        
        if color(of: sib) == .Black {
            if node == node.parent!.left && color(of: sib.right) == .Black && color(of: sib.left) == .Red {
                sib.color = .Red
                sib.left!.color = .Black
                rotateRight(sib)
            }
            else if node == node.parent!.right && color(of: sib.left) == .Black && color(of: sib.right) == .Red {
                sib.color = .Red
                sib.right!.color = .Black
                rotateLeft(sib)
=======
        let sibling = node.sibling!
        
        if sibling.color == .Black {
            if (node == node.parent!.left) &&
                (sibling.right!.color == .Black) &&
                (sibling.left!.color == .Red)
            {
                sibling.color = .Red
                sibling.left!.color = .Black
                rotateRight(sibling)
            }
            else if (node == node.parent!.right) &&
                (sibling.left!.color == .Black) &&
                (sibling.right!.color == .Red)
            {
                sibling.color = .Red
                sibling.right!.color = .Black
                rotateLeft(sibling)
>>>>>>> fix_removal
            }
                    
        }
        
        deleteCase6(node)
    }
    
    private func deleteCase6(_ node: Node<T>) {
<<<<<<< HEAD
        assert(node.parent != nil)
        
        let sib = sibling(ofNode: node)
=======
        let sibling = node.sibling!
>>>>>>> fix_removal
        
        sibling.color = node.parent!.color
        node.parent!.color = .Black
        
        if (node == node.parent!.left) {
<<<<<<< HEAD
            sib.right!.color = .Black
            rotateLeft(node.parent!)
        }
        else {
            sib.left!.color = .Black
=======
            sibling.right!.color = .Black
            rotateLeft(node.parent!)
        }
        else {
            sibling.left!.color = .Black
>>>>>>> fix_removal
            rotateRight(node.parent!)
        }
    }
    
    private func inOrderPredecessor(ofNode node: Node<T>) -> Node<T>? {
<<<<<<< HEAD
        
        func inOrderPredecessorFinder(_ currentNode: Node<T>) -> Node<T> {
            if currentNode.hasARightChild {
                return inOrderPredecessorFinder(currentNode.right!)
=======
        func inOrderPredecessor(_ currentNode: Node<T>) -> Node<T> {
            if currentNode.hasRightChild {
                return inOrderPredecessor(currentNode.right!)
>>>>>>> fix_removal
            }
            else {
                return currentNode
            }
        }
        
<<<<<<< HEAD
        if node.hasALeftChild {
            return inOrderPredecessorFinder(node.left!)
=======
        if node.hasLeftChild {
            return inOrderPredecessor(node.left!)
>>>>>>> fix_removal
        }
        else {
            return nil
        }
    }
    
    
    
    private func inOrderSuccessor(ofNode node: Node<T>) -> Node<T>? {
<<<<<<< HEAD
        
        func inOrderSuccessorFinder(_ currentNode: Node<T>) -> Node<T> {
            if let leftChild = currentNode.left {
                return inOrderSuccessorFinder(leftChild)
=======
        func inOrderSuccessor(_ currentNode: Node<T>) -> Node<T> {
            if currentNode.hasLeftChild {
                return inOrderSuccessor(currentNode.left!)
>>>>>>> fix_removal
            }
            else {
                return currentNode
            }
        }
        
<<<<<<< HEAD
        if node.hasARightChild {
            return inOrderSuccessorFinder(node.right!)
=======
        if node.hasRightChild {
            return inOrderSuccessor(node.right!)
>>>>>>> fix_removal
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
    
    private func swapNodeColors(node1: Node<T>, node2: Node<T>) {
        let temp = node1.color
        node1.color = node2.color
        node2.color = temp
    }
    
<<<<<<< HEAD
    private func sibling(ofNode node: Node<T>) -> Node<T> {
        assert(node.parent != nil)
        
        if node.parent!.left == node {
            return node.parent!.right!
        }
        else {
            return node.parent!.left!
        }
    }
    
    private func uncle(ofNode node: Node<T>) -> Node<T>? {
        if let grandparent = node.parent!.parent {
            if grandparent.left == node.parent! {
                return grandparent.right
=======
    private func replaceNode(node: Node<T>, child: Node<T>) {
        child.parent = node.parent
        
        if let parent = node.parent {
            if parent.left == node {
                parent.left = child
>>>>>>> fix_removal
            }
            else {
                parent.right = child
            }
        }
        else {
            root = child // we are replacing the root
        }
    }
    
    ////////////////////////////////////////////////////////
    // Functions for tree rotations
    ////////////////////////////////////////////////////////
    
    private func rotateLeft(_ root: Node<T>) {
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
        
        // Check for circular references
        assert(gp != nil ? (gp!.left != nil ? gp!.left != gp!.left!.left : true) : true)
        assert(gp != nil ? (gp!.right != nil ? gp!.right != gp!.right!.right : true) : true)
        
        assert(root.left != nil ? root.left != root.left!.left : true)
        assert(root.right != nil ? root.right != root.right!.right : true)
        
        assert(pivot.left != nil ? pivot.left != pivot.left!.left : true)
        assert(pivot.right != nil ? pivot.right != pivot.right!.right : true)
        
        assert(temp.left != nil ? temp.left != temp.left!.left : true)
        assert(temp.right != nil ? temp.right != temp.right!.right : true)
    }
    
    private func rotateRight(_ root: Node<T>) {
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
        
        // Check for circular references
        assert(gp != nil ? (gp!.left != nil ? gp!.left != gp!.left!.left : true) : true)
        assert(gp != nil ? (gp!.right != nil ? gp!.right != gp!.right!.right : true) : true)
        
        assert(root.left != nil ? root.left != root.left!.left : true)
        assert(root.right != nil ? root.right != root.right!.right : true)
        
        assert(pivot.left != nil ? pivot.left != pivot.left!.left : true)
        assert(pivot.right != nil ? pivot.right != pivot.right!.right : true)
        
        assert(temp.left != nil ? temp.left != temp.left!.left : true)
        assert(temp.right != nil ? temp.right != temp.right!.right : true)
    }
    
    ////////////////////////////////////////////////////////
    // Functions for traversals
    ////////////////////////////////////////////////////////
    
<<<<<<< HEAD
    func traverse(onNodeTouched: (NodeContents<T>) -> ()) {
        if root != nil {
            switch traversalType {
            case .InOrder:
                inOrderTraversal(root!, onNodeTouched: onNodeTouched)
            case .PreOrder:
                preOrderTraversal(root!, onNodeTouched: onNodeTouched)
            default:
                postOrderTraversal(root!, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func makeNodeContentsStruct(nodeToMakeItFrom node: Node<T>) -> NodeContents<T> {
        assert(!node.isANullNode)
        return NodeContents<T>(nodeContents:        node.data!,
                               nodeColor:           node.color,
                               leftChildContents:   node.left?.data,
                               rightChildContents:  node.right?.data,
                               parentContents:      node.parent?.data,
                               description:         node.description)
    }
=======
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
>>>>>>> fix_removal
    
    private func inOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
<<<<<<< HEAD
            if !node.isANullNode {
                inOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
=======
            if node.data != nil {
                inOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
>>>>>>> fix_removal
                inOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func preOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
<<<<<<< HEAD
            if !node.isANullNode {
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
=======
            if node.data != nil {
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
>>>>>>> fix_removal
                preOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                preOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            }
        }
    }
    
    private func postOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (Node<T>) -> ()) {
        if let node = nodeOp {
<<<<<<< HEAD
            if !node.isANullNode {
                postOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                postOrderTraversal(node.right, onNodeTouched: onNodeTouched)
                onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
=======
            if node.data != nil {
                postOrderTraversal(node.left, onNodeTouched: onNodeTouched)
                postOrderTraversal(node.right, onNodeTouched: onNodeTouched)
                //onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
                onNodeTouched(node)
>>>>>>> fix_removal
            }
        }
    }
    
    private func color(of node: Node<T>?) -> RBT_Color {
        return node == nil ? .Black : node!.color
    }
    
    func checkTree() {
        var numNodes = 0
        var numNoParentNodes = 0
        let queue = Queue<Int>()
        
        func checkTree(node: Node<T>?, numberOfBlackNodes: Int) {
            if node == nil {
                return
            }
            else if node!.isNullNode {
                queue.enqueue(numberOfBlackNodes)
                assert(node!.color == .Black) // check Property 3
            }
            else {
                numNodes += 1
                
                if node!.parent == nil {
                    numNoParentNodes += 1
                }
                
                let numberOfBlackNodes = node!.color == .Black ? numberOfBlackNodes + 1 : numberOfBlackNodes
                
                if node!.color == .Red {
                    assert(color(of: node!.left) == .Black && color(of: node!.right) == .Black) // assert Property 4
                }
                
                checkTree(node: node!.left, numberOfBlackNodes: numberOfBlackNodes)
                checkTree(node: node!.right, numberOfBlackNodes: numberOfBlackNodes)
            }
        }
        
        checkTree(node: root!, numberOfBlackNodes: 0)
        
        assert(root!.color == .Black) // checks Property 2
        assert(numNodes == numberOfNodes) // ensures the tree is structured properly
        assert(numNoParentNodes == (numberOfNodes == 0 ? 0 : 1)) // ensures the tree is structured properly
        
        var headVal = queue.peek()
        
        while queue.length > 0 {
            let dequeuedValue = queue.dequeue()!
            assert(headVal == dequeuedValue) // checks Property 5
            headVal = dequeuedValue
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

<<<<<<< HEAD
private class Node<T: Comparable> : CustomStringConvertible, Equatable {
=======
public class Node<T> : CustomStringConvertible, Equatable where T: Comparable, T: CustomStringConvertible {
>>>>>>> fix_removal
    var data: T? = nil
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
<<<<<<< HEAD
    var color: RBT_Color {
        set {
            if isANullNode {
                rbtColor = .Black
            }
            else {
                rbtColor = newValue
            }
        }
        get {
            if isANullNode && rbtColor == .Red {
=======
    
    var grandparent: Node<T>? { return parent?.parent }
    var isNullNode: Bool { return data == nil }
    var hasLeftChild: Bool { return left != nil && left!.isNullNode == false }
    var hasRightChild: Bool { return right != nil && right!.isNullNode == false }
    var color: RBT_Color {
        set {
            rbtColor = (data == nil ? .Black : newValue)
        }
        get {
            if data == nil {
>>>>>>> fix_removal
                rbtColor = .Black
            }
            
            return rbtColor
        }
    }
<<<<<<< HEAD
    var description: String {
        let nodeDescription   = "  NODE: \(data) (\(color))"
        let parentDescription = "PARENT: " + (parent == nil ? "nil" : "\(parent!.data)")
        let leftDescription   = "  LEFT: " + (left?.data == nil ? "nil" : "\(left!.data)")
        let rightDescription  = " RIGHT: " + (right?.data == nil ? "nil" : "\(right!.data)")
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    var hasALeftChild: Bool { return left?.data != nil }
    var hasARightChild: Bool { return right?.data != nil }
    var isANullNode: Bool { return data == nil }
    
    private var rbtColor = RBT_Color.Black
=======
    public var description: String {
        let nodeDescription   = "  NODE: \(data) (\(color))"
        let parentDescription = "PARENT: " + (parent == nil ? "nil" : (parent!.data == nil ? "null node" : parent!.data!.description))
        let leftDescription   = "  LEFT: " + (  left == nil ? "nil" : (  left!.data == nil ? "null node" :   left!.data!.description))
        let rightDescription  = " RIGHT: " + ( right == nil ? "nil" : ( right!.data == nil ? "null node" :  right!.data!.description))
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    var sibling: Node<T>? {
        if let parent = self.parent {
            if parent.left == self {
                return parent.right
            }
            else {
                return parent.left
            }
        }
        else {
            return nil
        }
    }
    var child: Node<T> {
        if hasLeftChild {
            return left!
        }
        else if hasRightChild {
            return right!
        }
        else {
            return left! // choose the left child, which is a null node
        }
    }
    var uncle: Node<T>? { return parent?.sibling }
    
    private var rbtColor = RBT_Color.Black // set it to a value; may (and probably will) change in init
>>>>>>> fix_removal
    
    init(data: T) {
        self.data = data
        self.color = .Red
        self.left = Node<T>()
        self.right = Node<T>()
    }
    
<<<<<<< HEAD
    /**
     Converts a node that is _not_ null into a node that _is_ null. In other words, this function sets its
     data to `nil`, and sets its left and right child to `nil`.
=======
    init() {
        // Use default values
    }
    
    /**
     Turns a node that is not a null node into a null node
>>>>>>> fix_removal
    */
    func nullify() {
        self.data = nil
        self.left = nil
        self.right = nil
<<<<<<< HEAD
    }
    
    private init() {
        // Does not change default values
=======
>>>>>>> fix_removal
    }
    
    static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.isANullNode && rhs.isANullNode ? true : lhs.data == rhs.data
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
