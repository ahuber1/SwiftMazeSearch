//
//  Queue.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

class Queue<T: Equatable>: CustomStringConvertible, Sequence, Equatable {
    let list: LinkedList<T>
    
    var length:Int { return list.numberOfNodes }
    var empty: Bool { return list.empty }
    var description: String { return list.description }
    
    convenience init() {
        self.init(LinkedList<T>())
    }
    
    init(_ queue: Queue<T>) {
        list = LinkedList<T>(queue.list)
    }
    
    private init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    func enqueue(_ data: T) {
        list.addToTail(data)
    }
    
    func dequeue() -> T? {
        return list.removeHead()
    }
    
    func peek() -> T? {
        return list.peekHead()
    }
    
    func map<U: Equatable>(_ mappingFunction: (T) -> U) -> Queue<U> {
        return Queue<U>(list.map(mappingFunction))
    }
    
    func contains(_ element: T) -> Bool {
        return list.contains(element)
    }
    
    func removeAll() {
        list.removeAll()
    }
    
    typealias QueueIterator = LinkedListIterator<T>
    func makeIterator() -> QueueIterator {
        return list.makeIterator()
    }
    
    public static func==<T: Equatable>(left: Queue<T>, right: Queue<T>) -> Bool {
        return left.list == right.list
    }
}
