//
//  Stack.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

class Stack<T: Equatable>: CustomStringConvertible {
    let list = LinkedList<T>()
    var length: UInt { return list.length }
    var empty: Bool { return list.empty }
    var description: String { return list.description }
    
    func push(_ data: T) {
        list.addToTail(data)
    }
    
    func pop() -> T? {
        return list.removeTail()
    }
    
    func peek() -> T? {
        return list.peekTail()
    }
}
