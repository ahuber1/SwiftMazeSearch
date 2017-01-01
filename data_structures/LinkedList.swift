//
//  LinkedList.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

/**
    A doubly linked list.
 
    - Author:
    Andrew Huber
 
    - Version:
    1.0
*/
public class LinkedList<T: Equatable>: CustomStringConvertible, Sequence, Equatable {
    
    /// The number of nodes that are currently in the linked list.
    public var numberOfNodes: Int { return numNodes }
    
    /// `true` if there is nothing stored in the linked list, `false` if there _is_ something stored in the linked list.
    public var isEmpty: Bool { return numNodes == 0 }
    
    /// A textual representation of this linked list.
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
    
    private var head: LinkedListNode<T>? = nil
    private var tail: LinkedListNode<T>? = nil
    private var numNodes = 0
    
    /// Creates a new empty linked list.
    public init() {
        // Use default values
    }
    
    /**
     A copy initializer.
     
     - parameter list: the linked list to copy.
     */
    public init(_ list: LinkedList<T>) {
        for data in list {
            addToTail(data)
        }
    }
    
    /**
     Returns an iterator over the elements of this sequence that starts at the head of the linked list and ends at the tail.
     Complexity: O(1).
    */
    public func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator<T>(startingNode: head)
    }
    
    /**
        Returns an iterator over the elements of this sequence that starts at the tail (_not_ the head) of the list and ends at the
        head of the list.
    */
    public func makeReverseIterator() -> LinkedListIterator<T> {
        return LinkedListIterator<T>(startingNode: tail)
    }
    
    /**
        Adds an element to the head of the linked list.
     
        - parameter element: the element to add to the linked list.
    */
    public func addToHead(_ element: T) {
        let newNode = LinkedListNode(data: element)
        
        if let h = head {
            newNode.next = h
            h.prev = newNode
            head = newNode
        }
        else {
            head = newNode
            tail = newNode
        }
        
        numNodes += 1
    }
    /** 
        Adds an element to the tail of the linked list.
     
        - parameter element: the element to add to the linked list.
    */
    public func addToTail(_ element: T) {
        let newNode = LinkedListNode(data: element)
        
        if let t = tail {
            newNode.prev = t
            t.next = newNode
            tail = newNode
        }
        else {
            head = newNode
            tail = newNode
        }
        
        numNodes += 1
    }
    
    /**
        Removes the node at the head of the list.
     
        - returns: the data, if any, contained in the node that was removed.
    */
    public func removeHead() -> T? {
        return remove(nodeToRemove: head)
    }
    
    /**
        Removes the node at the tail of the list.
     
        - returns: the data, if any, contained in the node that was removed.
    */
    public func removeTail() -> T? {
        return remove(nodeToRemove: tail)
    }
    
    /**
        Removes the _first_ node that contains the data that is passed into this function.
     
        - parameter element: the data to search for.
        - returns: the data, if any, contained in the node that was removed.
    */
    public func remove(elementToSearchFor element: T) -> T? {
        return remove(nodeToRemove: getNode(data: element))
    }
    
    /**
        Removes an element at a particular index.
 
        - parameter index: the index value.
        - returns: the data, if any, contained in the node that was removed.
        - important: This is _not_ an O(1) operation. In the worst _and_ average case, it is an O(n) operation.
    */
    public func remove(atIndex index: Int) -> T? {
        return remove(nodeToRemove: getNodeAt(index: index))
    }
    
    /**
        Removes _all_ nodes that contain the data that is passed into this function.
     
        - parameter element: the data to search for.
        - returns: another linked list containing the data, if any, that was removed. If nothing was removed, 
                   the number of nodes in the linked list returned by this function will be zero.
    */
    public func removeAll(elementToSearchFor element: T) -> LinkedList<T> {
        let list = LinkedList<T>()
        var node = head
        
        while node != nil {
            if node!.data == element {
                let temp = node
                node = node!.next
                list.addToTail(remove(nodeToRemove: temp)!)
            }
            else {
                node = node!.next
            }
        }
        
        return list
    }
    
    /** 
        Removes a node from the linked list.
     
        - parameter nodeToRemove: the node to remove from the linked list.
        - returns: the data stored in `nodeToRemove`, if any.
    */
    private func remove(nodeToRemove: LinkedListNode<T>?) -> T? {
        if let node = nodeToRemove {
            if let prev = node.prev {
                // If there is a prev AND next reference
                if let next = node.next {
                    prev.next = next
                    next.prev = prev
                }
                // If prev is the tail
                else {
                    prev.next = nil
                    tail = prev
                }
            }
            else {
                // If there is a next reference, but no prev reference
                if let next = node.next {
                    next.prev = nil
                    head = next
                }
                // If there is no prev reference AND no next reference
                else {
                    head = nil
                    tail = nil
                }
            }
            
            numNodes -= 1
            return node.data
        }
        else {
            return nil // nil was passed into this function
        }
    }
    
    /**
        Makes an array containing the contents of this linked list.
     
        - returns: an array containing the contents of this linked list.
    */
    public func toArray() -> [T] {
        var array = [T]()
        
        for element in self {
            array.append(element)
        }
        
        return array
    }
    
    /**
        Checks to see if a certain element is in the linked list.
     
        - parameter element: the element to look for.
        - returns: `true` if `element` is in the linked list, `false` if it is not.
    */
    func contains(_ element: T) -> Bool {
        if getNode(data: element) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    /**
        Gets a value at a particular index.
     
        - parameter index: the index.
        - returns: the data contained in the node at index `index` if any.
        - important: This is _not_ an O(1) operation. In the worst _and_ average case, it is an O(n) operation.
    */
    func getDataAt(index: Int) -> T? {
        return getNodeAt(index: index)?.data
    }
    
    /**
        Gets a node at a particular index.
     
        - parameter index: the index.
        - returns: the node at index `index` if any.
        - important: This is _not_ an O(1) operation. In the worst _and_ average case, it is an O(n) operation.
    */
    private func getNodeAt(index: Int) -> LinkedListNode<T>? {
        var node: LinkedListNode<T>? = head
        var i = 0
        
        while node != nil && i < index {
            node = node!.next
            i += 1
        }
        
        if let n = node {
            if i == index {
                return n
            }
        }
        
        return nil
    }
    
    /**
     Gets a value at a particular index.
     
     - parameter index: the index.
     - returns: the data contained in the node at index `index` if any.
     - important: This is _not_ an O(1) operation. In the worst _and_ average case, it is an O(n) operation.
     */
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
    
    /**
        Returns the data at the head of the linked list _without_ removing it.
     
        - returns: the data contained in the head of the linked list.
    */
    public func peekHead() -> T? {
        return head?.data
    }
    
    /**
        Returns the data at the tail of the linked list _without_ removing it.
     
        - returns: the data contained in the tail of the linked list.
    */
    public func peekTail() -> T? {
        return tail?.data
    }
    
    /**
        This function iterates through each element in this linked list, and applies an operation
        to the element. Then, the results of those operations are stored in another linked list, and 
        the elements in the second linked list correspond to the elements in _this_ linked list.
     
        For example, if you have a linked list storing students' grades, you can convert the raw point
        values that they earned throughout the semester to a letter grade.
     
            // Type inference should be used here, but the type was
            // added to grades in order to make this explanation 
            // easier to understand.
            let grades: LinkedList<Double> = getGrades()
     
            // Highest number of points a student can earn in 
            // a semester.
            let maximumNumberOfPoints = 1000.0
     
            // Type inference should be used here as well, but the
            // type was added to letterGrades in order to make
            // this explanation easier to understand.
            let letterGrades: LinkedList<Character> = grades.map( 
                { pointsReceived in
     
                    let percentage = 
                        pointsReceived / maximumNumberOfPoints
                
                    if percentage >= 90.0 {
                        return "A"
                    }
                    else if percentage >= 80.0 {
                        return "B"
                    }
                    else if percentage >= 70.0 {
                        return "C"
                    }
                    else if percentage >= 60.0 {
                        return "D"
                    }
                    else {
                        return "F"
                    }
     
                } 
            )
     
        - parameter mappingFunction: a function that takes in an element in _this_ linked list and returns what
                                     should be stored in the second linked list (see example for more information).
        - returns: another linked list with the transformed data (i.e., the "second linked list")
    */
    public func map<U: Equatable>(_ mappingFunction: (T) -> U) -> LinkedList<U> {
        let list = LinkedList<U>()
        
        for data in self {
            list.addToTail(mappingFunction(data))
        }
        
        return list
    }
    
    /**
        Removes all elements from this linked list.
        - important: this is an O(1) operation.
    */
    func clear() {
        head = nil
        tail = nil
        numNodes = 0
    }
    
    /**
        Compares the elements of two `LinkedList` objects and checks _all_ the elements one-by-one
        to see if they are equal to each other. 
     
        - parameter left:  the `LinkedList` object on the left side of the `==` operator.
        - parameter right: the `LinkedList` object on the right side of the `==` operator.
        - returns: `true` if `left` and `right` contain the same number of nodes _and_ contains the
                    same elements in the same order, `false` otherwise.
    */
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

/**
    The iterator for `LinkedList`
 
    - Author:
    Andrew Huber
 
    - Version:
    1.0
*/
public struct LinkedListIterator<T: Equatable>: IteratorProtocol {
    
    /// The node the iterator is currently at.
    private var currentNode: LinkedListNode<T>? = nil
    
    /**
        Creates a new `LinkedListIterator`
    
        - parameter startingNode: the node at which this iterator starts at.
    */
    fileprivate init(startingNode: LinkedListNode<T>?) {
        currentNode = startingNode
    }
    
    public mutating func next() -> T? {
        let returnVal = currentNode?.data
        currentNode = currentNode?.next
        return returnVal
    }
    
    /**
        Returns the data contained in the node the iterator is currently at,
        and advances the iterator backward once (i.e., goes to the previous node).
     
        - returns: the data contained in the node the iterator is currently at, if any.
    */
    public mutating func previous() -> T? {
        let returnVal = currentNode?.data
        currentNode = currentNode?.prev
        return returnVal
    }
}

/**
    The nodes that constitute the linked list.
 
    - Author:
    Andrew Huber
 
    - Version:
    1.0
 */
fileprivate class LinkedListNode<T> {
    /// The previous node in the linked list
    fileprivate var prev: LinkedListNode<T>? = nil
    
    /// The next node in the linked list
    fileprivate var next: LinkedListNode<T>? = nil
    
    /// The data in the linked list
    fileprivate var data: T
    
    /**
        Creates a new node with `data` stored in the node, and its
        `prev` and `next` references being `nil`.
    
        - important: you need to set the `prev` and `next` references 
                     manually with this node.
    */
    fileprivate init(data: T) {
        self.data = data
    }
}
