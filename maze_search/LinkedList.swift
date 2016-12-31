//
//  LinkedList.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

class LinkedList<T: Equatable>: CustomStringConvertible, Sequence, Equatable {
    private var head: LinkedListNode<T>? = nil
    private var tail: LinkedListNode<T>? = nil
    private var numNodes = 0
    
    public var numberOfNodes: Int { return numNodes }
    public var empty: Bool { return numNodes == 0 }
    public var description: String {
        var temp = "["
        var node = head
        
        while node != nil {
            temp += String(describing: node!.data)
            if node!.next != nil {
                temp += ", "
            }
            node = node!.next
        }
        
        temp += "]"
        return temp
    }
    
    init() {
        // Use default values
    }
    
    init(_ list: LinkedList<T>) {
        for data in list {
            addToTail(data)
        }
    }
    
    func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator<T>(startingNode: head)
    }
    
    func makeReverseIterator() -> LinkedListIterator<T> {
        return LinkedListIterator<T>(startingNode: tail)
    }
    
    func addToHead(_ data: T) {
        let node = LinkedListNode(data: data)
        
        if let h = head {
            node.next = h
            h.prev = node
            head = node
        }
        else {
            head = node
            tail = node
        }
        
        numNodes += 1
    }
    
    func addToTail(_ data: T) {
        let node = LinkedListNode(data: data)
        
        if let t = tail {
            node.prev = t
            t.next = node
            tail = node
        }
        else {
            head = node
            tail = node
        }
        
        numNodes += 1
    }
    
    func removeHead() -> T? {
        return __remove(nodeToRemove: head)
    }
    
    func removeTail() -> T? {
        return __remove(nodeToRemove: tail)
    }
    
    func remove(dataToSearchFor data: T) -> T? {
        return __remove(nodeToRemove: getNode(data: data))
    }
    
    private func __remove(nodeToRemove: LinkedListNode<T>?) -> T? {
        if let node = nodeToRemove {
            if let prev = node.prev {
                if let next = node.next {
                    prev.next = next
                    next.prev = prev
                }
                else {
                    prev.next = nil
                    tail = prev
                }
            }
            else {
                if let next = node.next {
                    next.prev = nil
                    head = next
                }
                else {
                    head = nil
                    tail = nil
                }
            }
            
            numNodes -= 1
            return node.data
        }
        else {
            return nil
        }
    }
    
    func contains(_ data: T) -> Bool {
        if getNode(data: data) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func getDataAt(index: UInt) -> T? {
        var node: LinkedListNode<T>? = head
        var i: UInt = 0
        
        while node != nil && i < index {
            node = node!.next
            i += 1
        }
        
        if let n = node {
            if i == index {
                return n.data
            }
        }
        
        return nil
    }
    
    private func getNode(data: T) -> LinkedListNode<T>? {
        var node: LinkedListNode<T>? = head
        
        while node != nil {
            if node!.data == data {
                return node!
            }
            else {
                node = node!.next
            }
        }
        
        return nil
    }
    
    func peekHead() -> T? {
        if let h = head {
            return h.data
        }
        else {
            return nil
        }
    }
    
    func peekTail() -> T? {
        if let t = tail {
            return t.data
        }
        else {
            return nil
        }
    }
    
    func map<U: Equatable>(_ mappingFunction: (T) -> U) -> LinkedList<U> {
        let list = LinkedList<U>()
        
        for data in self {
            list.addToTail(mappingFunction(data))
        }
        
        return list
    }
    
    public static func ==<T: Equatable>(left: LinkedList<T>, right: LinkedList<T>) -> Bool {
        if left.numberOfNodes == right.numberOfNodes {
            var leftIterator = left.makeIterator()
            var rightIterator = right.makeIterator()
            var leftValue = leftIterator.next()
            var rightValue = rightIterator.next()
            
            while leftValue != nil && rightValue != nil {
                if leftValue! != rightValue! {
                    return false
                }
                
                leftValue = leftIterator.next()
                rightValue = rightIterator.next()
            }
            
            return true
        }
        
        return false
    }
}

struct LinkedListIterator<T: Equatable>: IteratorProtocol {
    private var currentNode: LinkedListNode<T>? = nil
    
    init(startingNode: LinkedListNode<T>?) {
        currentNode = startingNode
    }
    
    mutating func next() -> T? {
        let returnVal = currentNode?.data
        currentNode = currentNode?.next
        return returnVal
    }
    
    mutating func previous() -> T? {
        let returnVal = currentNode?.data
        currentNode = currentNode?.prev
        return returnVal
    }
}

internal class LinkedListNode<T> {
    var prev: LinkedListNode<T>? = nil
    var next: LinkedListNode<T>? = nil
    var data: T
    
    init(data: T) {
        self.data = data
    }
}
