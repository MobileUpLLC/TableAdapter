//
//  Diff.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

struct Diff<ItemType: Hashable, SectionType: Hashable, HeaderType: Any> {
    
    typealias Sec = Section<ItemType, SectionType, HeaderType>
    
    let sections: IndexSetDiff
    let rows: IndexPathDiff
    
    let intermediateData: [Sec]
    let resultData: [Sec]
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
