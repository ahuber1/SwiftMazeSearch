//
//  main.swift
//  maze_search
//
//  Created by Andrew Huber on 12/14/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation
import DanshiDataStructures

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
