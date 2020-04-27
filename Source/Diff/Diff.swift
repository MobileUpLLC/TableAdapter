//
//  Diff.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

// MARK: Move

public struct Move<T> {
    
    public let from: T
    public let to: T
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
    
    public var inserts: IndexSet
    public var moves: [Move<Int>]
    public var deletes: IndexSet
}

extension IndexSet {
    
    func convertToIndexPaths(section: Int) -> [IndexPath] {
        
        return self.map { IndexPath(row: $0, section: section) }
    }
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


extension IndexSetDiff: CustomStringConvertible {
    
    public var description: String {
        
        return """
        
        Inserts: \(Array(inserts))
        Deletes: \(Array(deletes))
        Moves: \(moves)
            
        """
    }
}

// MARK: Diff

struct Diff<ItemType: Hashable, SectionType: Hashable, HeaderType: Any> {
    
    typealias Sec = Section<ItemType, SectionType, HeaderType>
    
    let sections: IndexSetDiff
    let rows: IndexPathDiff
    
    let intermediateData: [Sec]
    let resultData: [Sec]
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
