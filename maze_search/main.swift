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

let dictionary = RedBlackDictionary<Int, Int>()

for num in 1...10 {
    dictionary[num] = 0
}

let maximumNumberOfIterations = 100_000
let width = String(maximumNumberOfIterations).characters.count

for numberOfIterations in 1...maximumNumberOfIterations {
    dictionary[randomIntBetween(min: 1, max: 10)] += 1
    print("Ran for \(numberOfIterations.format(withNumberOfDigits: width)) iterations out of \(maximumNumberOfIterations.format(withNumberOfDigits: width))")
}

let keysAndValues = dictionary.keysAndValues.map( { item in
    return RedBlackDictionaryItem<Int, String>(key: item.key, value: "\(Double(item.value! * 100) / Double(maximumNumberOfIterations))%")
} )

for item in keysAndValues {
    print(item)
}
