//
//  IndexSetDiff.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import Foundation

public struct IndexSetDiff {
    
    public var inserts: IndexSet
    public var moves: [Move<Int>]
    public var deletes: IndexSet
}

// MARK: CustomStringConvertible

extension IndexSetDiff: CustomStringConvertible {
    
    public var description: String {
        
        return """
        
        Inserts: \(Array(inserts))
        Deletes: \(Array(deletes))
        Moves: \(moves)
            
        """
    }
}

// MARK: Convert To IndexPaths

extension Move where T == Int {
    
    func convertToIndexPath(section: Int) -> Move<IndexPath> {
        
        return Move<IndexPath>(
            from: IndexPath(row: from, section: section),
            to: IndexPath(row: to, section: section)
        )
    }
}

extension Array where Element == Move<Int> {
    
    func convertToIndexPaths(section: Int) -> [Move<IndexPath>] {
        
        return map { $0.convertToIndexPath(section: section) }
    }
}

extension IndexSet {
    
    func convertToIndexPaths(section: Int) -> [IndexPath] {
        
        return self.map { IndexPath(row: $0, section: section) }
    }
}
