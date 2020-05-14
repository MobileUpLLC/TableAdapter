//
//  Diff.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

struct Diff<Item: Hashable, SectionId: Hashable> {
    
    typealias SectionType = Section<Item, SectionId>
    
    let sections : IndexSetDiff
    let rows     : IndexPathDiff

    let intermediateData : [SectionType]
    let resultData       : [SectionType]
}

// MARK: CustomStringConvertible

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
