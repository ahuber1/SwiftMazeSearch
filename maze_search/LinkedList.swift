//
//  LinkedList.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

class LinkedList<T: Equatable>: CustomStringConvertible {
    private var head: LinkedListNode<T>? = nil
    private var tail: LinkedListNode<T>? = nil
    private var len: UInt = 0
    
    public var length: UInt { return len }
    public var empty: Bool { return len == 0 }
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
        
        len += 1
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
        
        len += 1
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
            
            len -= 1
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
}

private class LinkedListNode<T> {
    var prev: LinkedListNode<T>? = nil
    var next: LinkedListNode<T>? = nil
    var data: T
    
    init(data: T) {
        self.data = data
    }
}
