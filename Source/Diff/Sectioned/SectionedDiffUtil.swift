//
//  SectionedDiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 27.04.2020.
//

import Foundation

public class SectionedDiffUtil: DiffUtil {
    
    private static func calculateRowsDiff<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>(
        
        from oldSections: [Section<ItemType, SectionType, HeaderType>],
        to newSections: [Section<ItemType, SectionType, HeaderType>]
        
    ) throws -> IndexPathDiff {
        
        guard oldSections.count == newSections.count else {
            
            throw DiffError.invalidItemsCount("Old and new sections number mismatch")
        }
        
        var result = IndexPathDiff(inserts: [], moves: [], deletes: [])
        
        for i in 0..<oldSections.count {
            
            let indexSetDiff = try calculateDiff(form: oldSections[i].items, to: newSections[i].items)
            
            let indexPathDiff = indexSetDiff.convertToIndexPathDiff(section: i)
            
            result.inserts.append(contentsOf: indexPathDiff.inserts)
            result.moves.append(contentsOf: indexPathDiff.moves)
            result.deletes.append(contentsOf: indexPathDiff.deletes)
        }
        
        return result
    }
    
    // MARK: Public methods
    
    static func calculateSectionDiff<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>(
        
        from oldSections: [Section<ItemType, SectionType, HeaderType>],
        to newSections: [Section<ItemType, SectionType, HeaderType>]
        
    ) throws -> Diff<ItemType, SectionType, HeaderType> {
        
        let sectionsDiff = try calculateDiff(form: oldSections, to: newSections)
        
        let intermediateSections = applyDiff(sectionsDiff, from: oldSections) { newSections[$0] }
        
        let rowsDiff = try calculateRowsDiff(from: intermediateSections, to: newSections)
        
        return Diff(
            sections: sectionsDiff,
            rows: rowsDiff,
            intermediateData: intermediateSections,
            resultData: newSections
        )
    }
    
}
