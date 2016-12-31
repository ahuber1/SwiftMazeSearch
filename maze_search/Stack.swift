//
//  Stack.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

class Stack<T: Equatable>: CustomStringConvertible, Sequence, IteratorProtocol, Equatable {
    let list: LinkedList<T>
    
    var numberOfNodes: Int { return list.numberOfNodes }
    var empty: Bool { return list.empty }
    var description: String { return list.description }
    
    typealias StackIterator = LinkedListIterator<T>
    private var iterator: StackIterator? = nil
    
    convenience init() {
        self.init(LinkedList<T>())
    }
    
    init(_ stack: Stack<T>) {
        list = LinkedList<T>(stack.list)
    }
    
    private init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    func push(_ data: T) {
        list.addToTail(data)
    }
    
    func pop() -> T? {
        return list.removeTail()
    }
    
    func peek() -> T? {
        return list.peekTail()
    }
    
    func contains(_ element: T) -> Bool {
        return list.contains(element)
    }
    
    public func removeAll() {
        list.removeAll()
    }
    
    public static func ==<T: Equatable>(left: Stack<T>, right: Stack<T>) -> Bool {
        return left.list == right.list
    }
    
    public func makeIterator() -> StackIterator {
        iterator = list.makeReverseIterator()
        return iterator!
    }
    
    public func next() -> T? {
        return iterator?.previous()
    }
}
