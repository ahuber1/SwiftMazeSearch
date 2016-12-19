//
//  RedBlackTree.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

enum RBT_Traversal_Type {
    case InOrder, PreOrder, PostOrder
}

class RedBlackTree<T: Comparable>: CustomStringConvertible {
    private var root: Node<T>? = nil
    private var traversalType: RBT_Traversal_Type
    private var numNodes: UInt = 0
    
    var numberOfNodes: UInt { return numNodes }
    var description: String { return traverse() }
    
    init(traversalType: RBT_Traversal_Type) {
        self.traversalType = traversalType
    }
    
    convenience init() {
        self.init(traversalType: .InOrder)
    }
    
    func insert(data: T) -> Bool {
        return insert(data: data, node: root, parent: nil, grandparent: nil)
    }
    
    private func insert(data: T, node nodeOp: Node<T>?, parent parentOp: Node<T>?, grandparent grandparentOp: Node<T>?) -> Bool {
        // If we have to keep going down the tree (i.e., if there is a node)
        if let node = nodeOp {
            if data < node.data {
                return insert(data: data, node: node.left, parent: node, grandparent: parentOp)
            }
            else {
                return insert(data: data, node: node.right, parent: node, grandparent: parentOp)
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
    
    // *** We have already determined that node has a parent
    private func insertCase2(_ node: Node<T>) {
        if node.parent!.color == .Black {
            return // Tree is still valid
        }
        else {
            insertCase3(node)
        }
    }
    
    // *** We have already determined that node has a parent
    private func insertCase3(_ node: Node<T>) {
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
    
    // *** We have already determined that node has a parent
    // *** There must be a grandparent at this stage
    private func insertCase4(_ node: Node<T>) {
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
    
    // *** We have already determined that node has a parent
    // *** There must be a grandparent at this stage
    private func insertCase5(_ node: Node<T>) {
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
    
    func remove(data: T) -> T? {
        if let nodeToRemove = findNode(data: data, node: root) {
            return remove(nodeToRemove)
        }
        else {
            return nil
        }
    }
    
    private func findNode(data: T, node nodeOp: Node<T>?) -> Node<T>? {
        if let node = nodeOp {
            if node.data < data {
                return findNode(data: data, node: node.left)
            }
            else if node.data > data {
                return findNode(data: data, node: node.right)
            }
            else {
                return node
            }
        }
        else {
            return nil
        }
    }
    
    
    
    private func rotateLeft(_ node: Node<T>) {
        let pivot = node.right!
        let temp = node.parent
        
        pivot.left = node
        node.right = pivot.left
        pivot.left!.parent = node
        node.parent = pivot
        pivot.parent = temp
    }
    
    private func rotateRight(_ node: Node<T>) {
        let pivot = node.left!
        let temp = node.parent
        
        node.left = pivot.left
        pivot.right = node
        pivot.right!.parent = node
        pivot.parent = temp
        node.parent = pivot
    }
    
    private func findMinElementInRightSubtree(rootOfRightSubtree node: Node<T>) -> Node<T> {
        if node.left != nil {
            return findMinElementInRightSubtree(rootOfRightSubtree: node.left!)
        }
        else {
            return node
        }
    }
    
    private func swapNodeData(node1: Node<T>, node2: Node<T>) {
        let temp = node1.data
        node1.data = node2.data
        node2.data = temp
    }
    
    private func traverse() -> String {
        var description = ""
        
        switch traversalType {
        case .InOrder:
            inOrderTraversal(root, string: &description)
        case .PreOrder:
            preOrderTraversal(root, string: &description)
        default:
            postOrderTraversal(root, string: &description)
        }
        
        let startIndex = description.index(description.startIndex, offsetBy: 1)
        let endIndex = description.index(description.endIndex, offsetBy: -2)
        return description.substring(with: startIndex..<endIndex)
    }
    
    private func inOrderTraversal(_ nodeOp: Node<T>?, string: inout String) {
        if let node = nodeOp {
            inOrderTraversal(node.left, string: &string)
            string += node.description + "\n\n"
            inOrderTraversal(node.right, string: &string)
        }
    }
    
    private func preOrderTraversal(_ nodeOp: Node<T>?, string: inout String) {
        if let node = nodeOp {
            string += node.description + "\n\n"
            preOrderTraversal(node.left, string: &string)
            preOrderTraversal(node.right, string: &string)
        }
    }
    
    private func postOrderTraversal(_ nodeOp: Node<T>?, string: inout String) {
        if let node = nodeOp {
            postOrderTraversal(node.left, string: &string)
            postOrderTraversal(node.right, string: &string)
            string += node.description + "\n\n"
        }
    }
    
    private func getColor(node: Node<T>?) -> RBT_Color {
        if let n = node {
            return n.color
        }
        else {
            return .Black
        }
    }
    
    private func uncle(ofNode node: Node<T>) -> Node<T>? {
        if let parent = node.parent {
            if let grandparent = parent.parent {
                if let grandparentLeft = grandparent.left {
                    if grandparentLeft.data == parent.data {
                        return grandparent.right
                    }
                }
                
                return grandparent.right!
            }
        }
        
        return nil
    }
    
    private func grandparent(ofNode node: Node<T>) -> Node<T>? {
        if let parent = node.parent {
            if let grandparent = parent.parent {
                return grandparent
            }
        }
        
        return nil
    }
    
    private func sibling(node: Node<T>) -> Node<T>? {
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
}

private enum RBT_Color : CustomStringConvertible {
    case Red, Black, DoubleBlack
    
    var description: String {
        switch self {
        case .Red:
            return "Red"
        case .Black:
            return "Black"
        default:
            return "Double Black"
        }
    }
}



private class Node<T: Comparable> : CustomStringConvertible, Equatable {
    var parent: Node<T>? = nil
    var left: Node<T>? = nil
    var right: Node<T>? = nil
    var color: RBT_Color = .Red
    var data: T
    var description: String {
        let nodeDescription   = "  NODE: \(data) (\(color))"
        let parentDescription = "PARENT: \(parent?.data)"
        let leftDescription   = "  LEFT: \(left?.data)"
        let rightDescription  = " RIGHT: \(right?.data)"
        return "\(nodeDescription)\n\(parentDescription)\n\(leftDescription)\n\(rightDescription)"
    }
    
    init(data: T) {
        self.data = data
    }
    
    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.data == rhs.data
    }
}
