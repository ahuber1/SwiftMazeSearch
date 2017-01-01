//
//  MazeSearch.swift
//  maze_search
//
//  Created by Andrew Huber on 12/31/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import Foundation

public class MazeSearcher {
    
    private static let mazeDimensionsLineNumber = 1
    private static let finishingPointLineNumber = 2
    private static let lineNumberThatStartsMazeContents = 3
    private static let numberOfNumbersInMazeDimensions = 2
    private static let numberOfNumbersInFinishingPoint = 2
    private static let rowIndex = 0
    private static let columnIndex = 1
    private static let separator = " "
    private static let numberOfDirections = 4
    private static let rightIndex = 0
    private static let downIndex = 1
    private static let leftIndex = 2
    private static let upIndex = 3
    private static let wall = "1"
    private static let noWall = "0"
    
    private static var mazeDimensionsIndexNumber: Int { return mazeDimensionsLineNumber - 1 }
    private static var finishingPointIndexNumber: Int { return finishingPointLineNumber - 1 }
    private static var indexNumberThatStartsMazeContents: Int { return lineNumberThatStartsMazeContents - 1 }
    
    private let maze: [[MazeCell]]
    private let finishingPoint: MazeIndex
    
    public init(mazeFileName: String) throws {
        (maze, finishingPoint) = try MazeSearcher.buildMazeFromFile(mazeFileName)
    }
    
    private static func buildMazeFromFile(_ mazeFileName: String) throws -> ([[MazeCell]], MazeIndex) {
        let content = try String.init(contentsOfFile: mazeFileName)
        let lines = content.components(separatedBy: "\n")
        try errorAssert(condition: lines.count >= 3, errorOnFailure: MazeConfigurationError.fileTooShort("\(mazeFileName) needs to be at least three " +
            "lines long, but it is only \(lines.count) \(lines.count == 1 ? "line" : "lines") long"))
        
        let mazeDimensionsLine = lines[mazeDimensionsIndexNumber]
        let mazeDimensions = mazeDimensionsLine.components(separatedBy: separator)
        try errorAssert(condition: mazeDimensions.count == numberOfNumbersInMazeDimensions,
                        errorOnFailure: MazeConfigurationError.mazeDimensionsUnreadable("Line \(mazeDimensionsLineNumber) in \(mazeFileName) must contain " +
                            "\(numberOfNumbersInMazeDimensions) integers separated by a space, but we were able to split it \(mazeDimensions.count) " +
                            "\(mazeDimensions.count == 1 ? "time" : "times")"))
        let numberOfRowsString = mazeDimensions[rowIndex]
        let numberOfColumnsString = mazeDimensions[columnIndex]
        
        if let numberOfRows = Int(numberOfRowsString), let numberOfColumns = Int(numberOfColumnsString) {
            let finishingPointLine = lines[finishingPointIndexNumber]
            let finishingPoint = finishingPointLine.components(separatedBy: separator)
            try errorAssert(condition: finishingPoint.count == numberOfNumbersInFinishingPoint,
                            errorOnFailure: MazeConfigurationError.finishingPointUnreadable("Line \(finishingPointLineNumber) in \(mazeFileName) must contain " +
                                "\(numberOfNumbersInFinishingPoint) integers separated by a space, but we were able to split it \(finishingPoint.count) " +
                                "\(finishingPoint.count == 1 ? "time" : "times")"))
            let finishingPointRowString = finishingPoint[rowIndex]
            let finishingPointColumnString = finishingPoint[columnIndex]
            
            if let finishingPointRow = Int(finishingPointRowString), let finishingPointColumn = Int(finishingPointColumnString) {
                var maze = [[MazeCell]]()
                var index = indexNumberThatStartsMazeContents
                var lineNumber: Int { return index + 1 }
                for _ in 0..<numberOfRows { // iterate through the rows
                    var row = [MazeCell]()
                    for _ in 0..<numberOfColumns { // iterate through the columns
                        let line = lines[index]
                        let walls = line.components(separatedBy: separator)
                        try errorAssert(condition: walls.count == numberOfDirections,
                                        errorOnFailure: MazeConfigurationError.mazeCellUnreadable("\(walls.count) \(walls.count == 1 ? "wall was" : "walls were") detected, but \(numberOfDirections) \(numberOfDirections == 1 ? "was" : "were") found on line \(lineNumber)"))
                        
                        let rightWall = numberToWall(walls[rightIndex])
                        let downWall = numberToWall(walls[downIndex])
                        let leftWall = numberToWall(walls[leftIndex])
                        let upWall = numberToWall(walls[upIndex])
                        
                        row.append(MazeCell(rightWall: rightWall, downWall: downWall, leftWall: leftWall, upWall: upWall))
                        index += 1
                    }
                    maze.append(row)
                }
                
                return (maze, MazeIndex(row: finishingPointRow, column: finishingPointColumn))
            }
            else {
                throw MazeConfigurationError.finishingPointUnreadable("The finishing point of the maze, which are on line \(finishingPointLineNumber) of " +
                    "\(mazeFileName) are supposed to be two integers separated by a space.")
            }
        }
        else {
            throw MazeConfigurationError.mazeDimensionsUnreadable("The dimensions of the maze, which are on line \(mazeDimensionsLineNumber) of \(mazeFileName)," + "are supposed to be two integers separated by a space.")
        }
    }
    
    private static func errorAssert(condition: Bool, errorOnFailure: Error) throws {
        if condition == false {
            throw errorOnFailure
        }
    }
    
    private static func numberToWall(_ number: String) -> MazeWall {
        return number == wall ? .Wall : .NoWall
    }
    
    public func findPath(startingRow: Int, startingColumn: Int) throws -> LinkedList<MazeIndex>? {
        if let stack = try findPath(MazeSearcher.MazeIndex(row: startingRow, column: startingColumn)) {
            let list = LinkedList<MazeIndex>()
            
            while !stack.empty {
                list.addToTail(stack.pop()!)
            }
            
            return list
        }
        else {
            return nil
        }
    }
    
    private func findPath(_ currentPosition: MazeIndex) throws -> Stack<MazeIndex>? {
        let cell = try currentPosition.retrieveFrom2DArray(maze)
        
        if currentPosition == finishingPoint {
            let stack = Stack<MazeIndex>()
            stack.push(currentPosition)
            return stack
        }
        
        if let partialPath = try lookInADirection(direction: .right, currentPosition: currentPosition, currentCell: cell) {
            return partialPath
        }
        
        if let partialPath = try lookInADirection(direction: .down, currentPosition: currentPosition, currentCell: cell) {
            return partialPath
        }
        
        if let partialPath = try lookInADirection(direction: .left, currentPosition: currentPosition, currentCell: cell) {
            return partialPath
        }
        
        if let partialPath = try lookInADirection(direction: .up, currentPosition: currentPosition, currentCell: cell) {
            return partialPath
        }
        
        return nil
    }
    
    private func lookInADirection(direction: MazeDirection, currentPosition: MazeIndex, currentCell: MazeCell) throws -> Stack<MazeIndex>? {
        if currentPosition.getNeighbor(direction: direction).isValidIndex(maze) {
            let visited = try currentPosition.getNeighbor(direction: direction).retrieveFrom2DArray(maze).visited
            if currentCell.canGo(direction) && !visited {
                if currentPosition.getNeighbor(direction: direction).isValidIndex(maze) {
                    try currentPosition.retrieveFrom2DArray(maze).visited = true
                    if let partialPath = try findPath(currentPosition.getNeighbor(direction: direction)) {
                        partialPath.push(currentPosition)
                        return partialPath
                    }
                    else {
                        try currentPosition.retrieveFrom2DArray(maze).visited = false
                    }
                }
                else {
                    throw MazeConfigurationError.mazeIsOpen("The perimeter of the maze is not closed at \(currentPosition)")
                }
            }
        }
        
        return nil
    }
    
    private enum MazeConfigurationError: Error {
        case fileTooShort(String)
        case mazeDimensionsUnreadable(String)
        case finishingPointUnreadable(String)
        case mazeCellUnreadable(String)
        case mazeIsOpen(String)
    }
    
    private class MazeCell {
        let directions = RedBlackDictionary<MazeDirection, MazeWall>()
        var visited = false
        
        public init(rightWall: MazeWall, downWall: MazeWall, leftWall: MazeWall, upWall: MazeWall) {
            directions[.right] = rightWall
            directions[.down] = downWall
            directions[.left] = leftWall
            directions[.up] = upWall
        }
        
        public func canGo(_ direction: MazeDirection) -> Bool {
            return directions[direction] == .NoWall
        }
    }
    
    public enum MazeDirection: Int, Comparable, CustomStringConvertible {
        case right = 0
        case down, left, up
        
        public static func ==(left: MazeDirection, right: MazeDirection) -> Bool {
            return left.rawValue == right.rawValue
        }
        
        public static func <(left: MazeDirection, right: MazeDirection) -> Bool {
            return left.rawValue < right.rawValue
        }
        
        public var description: String {
            switch self {
            case .right:
                return "Right"
            case .down:
                return "Down"
            case .left:
                return "Left"
            default:
                return "Up"
            }
        }
    }
    
    private enum MazeWall: CustomStringConvertible {
        case Wall
        case NoWall
        
        public var description: String { return self == .Wall ? "Wall" : "No Wall" }
    }
    
    public struct MazeIndex: CustomStringConvertible, Comparable {
        let row: Int
        let column: Int
        
        public var description: String { return "(\(row), \(column))" }
        
        public func getNeighbor(direction: MazeDirection) -> MazeIndex {
            switch direction {
            case .right:
                return MazeIndex(row: row,     column: column + 1  )
            case .down:
                return MazeIndex(row: row + 1, column: column      )
            case .left:
                return MazeIndex(row: row,     column: column - 1  )
            default:
                return MazeIndex(row: row - 1, column: column      )
            }
        }
            
        public func isValidIndex<T>(_ array: [[T]]) -> Bool {
            return row >= 0 && column >= 0 && row < array.count && column < array[row].count
        }
        
        public func retrieveFrom2DArray<T>(_ array: [[T]]) throws -> T {
            if isValidIndex(array) {
                return array[row][column]
            }
            else {
                throw MazeIndexOutOfBounds.outOfBounds(self)
            }
        }
        
        public enum MazeIndexOutOfBounds: Error {
            case outOfBounds(MazeIndex)
        }
        
        public static func ==(left: MazeIndex, right: MazeIndex) -> Bool {
            return left.row == right.row && left.column == right.column
        }
        
        public static func <(left: MazeIndex, right: MazeIndex) -> Bool {
            return left.row < right.row ? true : left.column < right.column
        }
    }
}
