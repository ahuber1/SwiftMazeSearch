//
//  RedBlackDictionary.swift
//  maze_search
//
//  Created by Andrew Huber on 12/30/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

class RedBlackDictionary<K, V>: CustomStringConvertible where K: Comparable, K: CustomStringConvertible, V: Equatable, V: CustomStringConvertible {
    public var description: String {
        var returnVal = ""
        tree.traverse(onNodeTouched: { returnVal += "\($0.nodeContents.description)\n" } )
        
        if returnVal == "" {
            return "Empty"
        }
        else {
            return returnVal.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private let tree = RedBlackTree<RedBlackDictionaryItem<K, V>>()
    
    var keysAndValues: LinkedList<RedBlackDictionaryItem<K, V>> {
        let list = LinkedList<RedBlackDictionaryItem<K, V>>()

        tree.traverse(onNodeTouched: { contents in
            list.addToTail(RedBlackDictionaryItem<K, V>(contents.nodeContents))
        })
        
        return list
    }
    
    var keys: LinkedList<K> { return keysAndValues.map( { return $0.key } ) }
    var values: LinkedList<V> { return keysAndValues.map( { return $0.value! } ) }
    
    /**
     Adds a new key-value pair, or changes the value of a pre-existing key-value pair with `newValue`
     
     - parameters:
        - key: The key in the key-value pair
        - newValue: If `key` already exists in the dictionary, then its value is set to `newValue`.
                    Otherwise, a new key-value pair is made with the key set to `key` and the value
                    set to `newValue`.
     
     - returns: `true` if a new key-value pair was inserted _or_ if a pre-existing key-value pair was
                successfully altered, `false` if it was not.
    */
    func set(key: K, value newValue: V?) -> Bool {
        let item = RedBlackDictionaryItem<K, V>(key: key, value: newValue)
        
        // We can pass newValue into here because only the keys are compared in the RBT
        if let preexistingValue = tree.get(item) {
            preexistingValue.value = newValue
            return true
        }
        else {
            return tree.insert(item)
        }
    }
    
    /**
     Gets the value in a key-value pair.
     
     - parameters:
        - key: the key in the key-value pair
     
     - returns: the value in the key-value pair, or `nil` if `key` does not exist in the dictionary.
    */
    func get(key: K) -> V? {
        // It's okay to pass in nil; only the keys are compared in the RBT
        if let item = tree.get(RedBlackDictionaryItem<K, V>(key: key, value: nil)) {
            return item.value
        }
        else {
            return nil
        }
    }
    
    
    /**
     Checks if a particular key exists in the key-value pair.
     
     - parameters:
        - key: the key in the key-value pair
     
     - returns: `true` if `key` exists in the dictionary, `false` if it does not
    */
    func contains(key: K) -> Bool {
        return get(key: key) != nil
    }
    
    /**
     Removes a key-value pair from the dictionary.
     
     - parameters:
        - key: the key in the key-value pair
     
     - returns: the value that was removed or `nil` if `key` was not found
    */
    func remove(key: K) -> V? {
        // It's okay to pass in nil; only the keys are compared in RBT
        if let removedItem = tree.remove(RedBlackDictionaryItem<K, V>(key: key, value: nil)) {
            return removedItem.value
        }
        else {
            return nil
        }
    }
    
    subscript (key: K) -> V? {
        get {
            return get(key: key)
        }
        set (newValue) {
            _ = set(key: key, value: newValue!)
        }
    }
    
    subscript (key: K) -> V {
        get {
            return get(key: key)!
        }
        set (newValue) {
            _ = set(key: key, value: newValue)
        }
    }
}

class RedBlackDictionaryItem<K, V>: CustomStringConvertible, Comparable where K : Comparable, K : CustomStringConvertible, V: Equatable, V : CustomStringConvertible  {
    let key: K
    var value: V?
    
    public var description: String { return "(\(key), \(value == nil ? "nil" : value!.description))" }
    
    init(key: K, value: V?) {
        self.key = key
        self.value = value
    }
    
    convenience init(_ item: RedBlackDictionaryItem<K, V>) {
        self.init(key: item.key, value: item.value)
    }
    
    public static func <(lhs: RedBlackDictionaryItem<K, V>, rhs: RedBlackDictionaryItem<K, V>) -> Bool {
        return lhs.key < rhs.key
    }
    
    public static func ==(lhs: RedBlackDictionaryItem<K, V>, rhs: RedBlackDictionaryItem<K, V>) -> Bool {
        return lhs.key == rhs.key
    }
}
