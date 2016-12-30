//
//  main.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

extension Int {
    enum Alignment {
        case Left, Right
    }
    
    func format(withNumberOfDigits digits: Int, alignedToThe alignment: Alignment) -> String {
        if alignment == .Right {
            return String(format: "%\(digits)d", self)
        }
        else {
            return String(format: "%-\(digits)d", self)
        }
    }
    
    func format(withNumberOfDigits digits: Int) -> String {
        return format(withNumberOfDigits: digits, alignedToThe: .Right)
    }
}

func randomIntBetween(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}

let rbt = RedBlackTree<Int>(traversalType: .InOrder)
let numNodes = 10_000
let width = String(numNodes).characters.count

while rbt.numberOfNodes < numNodes {
    let num = randomIntBetween(min: 0, max: numNodes)
    if rbt.insert(num) {
        print("Inserted \(num.format(withNumberOfDigits: width))",
            "\t\(rbt.numberOfNodes.format(withNumberOfDigits: width))/\(numNodes.format(withNumberOfDigits: width, alignedToThe: .Left)) inserted.",
            "\tChecking tree...")
        rbt.checkTree()
    }
    
    var nodeCount = 0
    rbt.traverse(onNodeTouched: { _ in nodeCount += 1 } )
    assert(nodeCount == rbt.numberOfNodes)
}

while rbt.numberOfNodes > 0 {
    let num = randomIntBetween(min: 0, max: numNodes)
    if let removedNumber = rbt.remove(num) {
        print("Removed \(removedNumber.format(withNumberOfDigits: width))", "\trbt.numberOfNodes: \(rbt.numberOfNodes)\tChecking tree...")
        rbt.checkTree()
    }
}
