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

class RedBlackTree<T: Comparable>: CustomStringConvertible {
    
    ////////////////////////////////////////////////////////
    // Public properties
    ////////////////////////////////////////////////////////
    
    var traversalType: RBT_Traversal_Type // Used by traverse() to determine how it should traverse the tree
    var numberOfNodes: UInt { return numNodes }
    var description: String {
        var returnVal = ""
        
        traverse(onNodeTouched: { (contents: NodeContents<T>) -> () in
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
    private var numNodes: UInt = 0
    
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
            if data < node.data {
                return insert(data: data, node: node.left, parent: node, grandparent: parentOp)
            }
            else if data > node.data {
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
                
                if data < parent.data {
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
            // If we have to go left
            if data < node.data {
                return remove(data: data, node: node.left)
            }
            // If we have to go right
            else if data > node.data {
                return remove(data: data, node: node.right)
            }
            // If the node has TWO children
            else if let _ = node.left, let _ = node.right {
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
            // If the node has NO children
            else if node.left == nil && node.right == nil {
                // If there is a parent node
                if let parent = node.parent {
                    if parent.left == node {
                        parent.left = nil
                        node.parent = nil
                    }
                    else {
                        parent.right = nil
                        node.parent = nil
                    }
                }
                // If there is no parent node 
                else {
                    root = nil
                }
                
                return node.data
            }
            // If the node has ONE child
            else {
                deleteOneChild(node)
                return node.data
            }
        }
        else {
            return nil // node was not found
        }
    }
    
    private func deleteOneChild(_ node: Node<T>) {
        let child: Node<T>
        
        if let leftChild = node.left {
            child = leftChild
        }
        else {
            child = node.right!
        }
        
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
        if let parent = node.parent {
            if parent.left == node {
                parent.left = child
            }
            else {
                parent.right = child
            }
            
            child.parent = parent
        }
        else {
            root = child
        }
    }
    
    private func deleteCase1(_ node: Node<T>) {
        if node.parent != nil {
            deleteCase2(node)
        }
    }
    
    private func deleteCase2(_ node: Node<T>) {
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
        
        func inOrderPredecessorFinder(_ currentNode: Node<T>?) -> Node<T>? {
            if let rightChild = currentNode?.right {
                return inOrderPredecessorFinder(rightChild)
            }
            else {
                return currentNode
            }
        }
        
        return inOrderPredecessorFinder(node.left)
    }
    
    private func inOrderSuccessor(ofNode node: Node<T>) -> Node<T>? {
        
        func inOrderSuccessorFinder(_ currentNode: Node<T>?) -> Node<T>? {
            if let leftChild = currentNode?.left {
                return inOrderSuccessorFinder(leftChild)
            }
            else {
                return currentNode
            }
        }
        
        return inOrderSuccessorFinder(node.right)
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
        assert(root.right != nil)
     
        let gp = root.parent
        let pivot = root.right!
        let temp = pivot.left
        
        pivot.left = root
        root.right = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp?.parent = root
        
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
        assert(root.left != nil)
        
        let gp = root.parent
        let pivot = root.left!
        let temp = pivot.right
        
        pivot.right = root
        root.left = temp
        
        pivot.parent = gp
        root.parent = pivot
        temp?.parent = root
        
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
    
    func traverse(onNodeTouched: (NodeContents<T>) -> ()) {
        switch traversalType {
        case .InOrder:
            inOrderTraversal(root, onNodeTouched: onNodeTouched)
        case .PreOrder:
            preOrderTraversal(root, onNodeTouched: onNodeTouched)
        default:
            postOrderTraversal(root, onNodeTouched: onNodeTouched)
        }
    }
    
    private func makeNodeContentsStruct(nodeToMakeItFrom node: Node<T>) -> NodeContents<T> {
        return NodeContents<T>(nodeContents:        node.data,
                               nodeColor:           node.color,
                               leftChildContents:   node.left?.data,
                               rightChildContents:  node.right?.data,
                               parentContents:      node.parent?.data,
                               description:         node.description)
    }
    
    private func inOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            inOrderTraversal(node.left, onNodeTouched: onNodeTouched)
            onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
            inOrderTraversal(node.right, onNodeTouched: onNodeTouched)
        }
    }
    
    private func preOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
            preOrderTraversal(node.left, onNodeTouched: onNodeTouched)
            preOrderTraversal(node.right, onNodeTouched: onNodeTouched)
        }
    }
    
    private func postOrderTraversal(_ nodeOp: Node<T>?, onNodeTouched: (NodeContents<T>) -> ()) {
        if let node = nodeOp {
            postOrderTraversal(node.left, onNodeTouched: onNodeTouched)
            postOrderTraversal(node.right, onNodeTouched: onNodeTouched)
            onNodeTouched(makeNodeContentsStruct(nodeToMakeItFrom: node))
        }
    }
    
    private func color(of node: Node<T>?) -> RBT_Color {
        return node == nil ? .Black : node!.color
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

private class Node<T: Comparable> : CustomStringConvertible, Equatable {
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var parent: Node<T>? = nil
    var color: RBT_Color = .Red
    var data: T
    var description: String {
        let nodeDescription   = "  NODE: \(data) (\(color))"
        let parentDescription = "PARENT: " + (parent == nil ? "nil" : "\(parent!.data)")
        let leftDescription   = "  LEFT: " + (left == nil ? "nil" : "\(left!.data)")
        let rightDescription  = " RIGHT: " + (right == nil ? "nil" : "\(right!.data)")
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    
    init(data: T) {
        self.data = data
    }
    
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

struct NodeContents<T: Comparable> : CustomStringConvertible, Equatable {
    var nodeContents: T
    var nodeColor: RBT_Color
    var leftChildContents: T?
    var rightChildContents: T?
    var parentContents: T?
    var description: String 
    
    public static func ==(lhs: NodeContents<T>, rhs: NodeContents<T>) -> Bool {
        return lhs.nodeContents == rhs.nodeContents
    }
}
