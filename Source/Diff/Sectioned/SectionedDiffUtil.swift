//
//  SectionedDiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 27.04.2020.
//

import Foundation

public class SectionedDiffUtil<Item: Hashable, SectionId: Hashable, Header: Any>: DiffUtil {
    
    // MARK: Types
    
    typealias DiffType = Diff<Item, SectionId, Header>
    typealias SectionType = DiffType.SectionType
    
    // MARK: Private methods
    
    private static func calculateRowsDiff(
        
        from oldSections: [SectionType],
        to newSections: [SectionType]
        
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
    
    static func calculateSectionDiff(
        
        from oldSections: [SectionType],
        to newSections: [SectionType]
        
    ) throws -> DiffType {
        
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
