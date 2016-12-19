//
//  Queue.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

class Queue<T: Equatable>: CustomStringConvertible {
    let list = LinkedList<T>()
    var length: UInt { return list.length }
    var empty: Bool { return list.empty }
    var description: String { return list.description }
    
    func enqueue(_ data: T) {
        list.addToTail(data)
    }
    
    func dequeue() -> T? {
        return list.removeHead()
    }
    
    func peek() -> T? {
        return list.peekHead()
    }
}
