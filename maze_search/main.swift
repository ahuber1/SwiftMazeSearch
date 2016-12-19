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

let list = LinkedList<Int>()
let min = 1
let max = 100000

for i in min...max {
    list.addToHead(i)
    print("Added \(i) to the list and it " + (list.contains(i) ? "contains" : "does NOT contain") + " \(i) in the list.")
}

while !list.empty {
    let valueToRemove = list.getDataAt(index: randomIntBetween(min: 0, max: (list.length - 1)))
    if let dataRemoved = list.remove(dataToSearchFor: valueToRemove!) {
        print("Removed \(dataRemoved) from the list. Now, the length is \(list.length).")
    }
    else {
        print("Unable to remove \(valueToRemove)")
    }
    
    //print("\t\(list)")
}
