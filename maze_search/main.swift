//
//  main.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation


func randomIntBetween(min: UInt, max: UInt) -> UInt {
    return UInt(arc4random_uniform(UInt32(UInt(max - min + 1)))) + min
}

let rbt = RedBlackTree<UInt>(traversalType: .InOrder)
let numNodes: UInt = UInt(pow(Double(2), Double(10)))

while rbt.numberOfNodes < numNodes {
    let num = randomIntBetween(min: 0, max: numNodes)
    if rbt.insert(num) {
        print("Inserted \(num)\t\(rbt.numberOfNodes)/\(numNodes) inserted.")
    }
}

var nodeCount: UInt = 0
rbt.traverse(onNodeTouched: { _ in nodeCount += 1 } )
assert(nodeCount == rbt.numberOfNodes)

while rbt.numberOfNodes > numNodes / 2 {
    if let removedNumber = rbt.remove(randomIntBetween(min: 0, max: numNodes)) {
        var nodeCount: UInt = 0
        rbt.traverse(onNodeTouched: { _ in nodeCount += 1 } )
        print("Removed \(removedNumber)\tnodeCount: \(nodeCount)\tnumberOfNodes: \(rbt.numberOfNodes)")
        assert(nodeCount == rbt.numberOfNodes)
    }
}
