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

let dictionary = RedBlackDictionary<String, Int>()
dictionary["Huber"] = 3
dictionary["Kirsch"] = 1
dictionary["DuBois"] = 1
dictionary["Thiede"] = 2
dictionary["Thiede"] *= 10

print(dictionary)
