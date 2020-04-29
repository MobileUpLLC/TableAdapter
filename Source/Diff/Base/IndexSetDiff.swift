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

extension IndexSetDiff {
    
    func convertToIndexPathDiff(section: Int) -> IndexPathDiff {
        
        let m = moves.map {
            
            Move<IndexPath>(
                from: IndexPath(row: $0.from, section: section),
                to: IndexPath(row: $0.to, section: section)
            )
        }
        
        return IndexPathDiff(
            inserts: inserts.convertToIndexPaths(section: section),
            moves: m,
            deletes: deletes.convertToIndexPaths(section: section)
        )
    }
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

extension IndexSet {
    
    func convertToIndexPaths(section: Int) -> [IndexPath] {
        
        return self.map { IndexPath(row: $0, section: section) }
    }
}
