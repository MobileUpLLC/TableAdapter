//
//  Diff.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

// MARK: Move

public struct Move<T> {
    
    let from: T
    let to: T
}

extension Move: CustomStringConvertible {
    
    public var description: String {
        
        return "\(from) -> \(to)"
    }
}

// MARK: IndexPathDiff

public struct IndexPathDiff {
    
    var inserts: [IndexPath]
    var moves: [Move<IndexPath>]
    var deletes: [IndexPath]
}

// MARK: IndexSetDiff

public struct IndexSetDiff {
    
    var inserts: IndexSet
    var moves: [Move<Int>]
    var deletes: IndexSet
}

// MARK: GroupsDiff

struct Diff {
    
    let sections: IndexSetDiff
    let rows: IndexPathDiff
}

extension Diff: CustomStringConvertible {
    
    var description: String {
        
        return """
        
        Sec inserts: \(Array(sections.inserts))
        Sec deletes: \(Array(sections.deletes))
        Sec moves: \(sections.moves)
        
        Row inserts: \(rows.inserts)
        Row deletes: \(rows.deletes)
        Row moves: \(rows.moves)
        
        """
    }
}
