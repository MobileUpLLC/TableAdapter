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
    var reloads: [IndexPath]
}

// MARK: IndexSetDiff

public struct IndexSetDiff {
    
    var inserts: IndexSet
    var moves: [Move<Int>]
    var deletes: IndexSet
    var reloads: IndexSet
}

// MARK: GroupsDiff

struct GroupsDiff {
    
    let sectionsDiff: IndexSetDiff
    let rowsDiff: IndexPathDiff
}

extension GroupsDiff: CustomStringConvertible {
    
    var description: String {
        
        return """
        
        Sec inserts: \(Array(sectionsDiff.inserts))
        Sec deletes: \(Array(sectionsDiff.deletes))
        Sec moves: \(sectionsDiff.moves)
        
        Row inserts: \(rowsDiff.inserts)
        Row deletes: \(rowsDiff.deletes)
        Row moves: \(rowsDiff.moves)
        
        """
    }
}
