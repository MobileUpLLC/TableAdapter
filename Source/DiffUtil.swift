//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

enum DiffError: Error {
    
    case duplicates
}

public class DiffUtil {
    
    // MARK: Private methods
    
    private static func calculateSectionsDiff(
        
        from oldObjects: [AnyEquatable],
        to newObjects: [AnyEquatable]
        
    ) -> IndexSetDiff {
        
        var inserts = IndexSet()
        var moves = [Move<Int>]()
        var deletes = IndexSet()
        
        deletes.insert(integersIn: oldObjects.indices)
        
        for (newIdx, newObject) in newObjects.enumerated() {
            
            if let oldIdx = oldObjects.firstIndex(where: { newObject.equal(any: $0) }) {
                
                deletes.remove(oldIdx)
                
                if oldIdx != newIdx {
                    
                    moves.append(Move<Int>(from: oldIdx, to: newIdx))
                }
                
            } else {
                
                inserts.insert(newIdx)
            }
        }
        
        return IndexSetDiff(inserts: inserts, moves: moves, deletes: deletes)
    }
    
    private static func calculateRowsDiff(
        
        from oldSections: [Section],
        to newSections: [Section]
        
    ) -> IndexPathDiff {
        
        var rowInserts = [IndexPath]()
        var rowDeletes = [IndexPath]()
        var rowMoves = [Move<IndexPath>]()
        
        // Map sections to index pathes.
        rowDeletes = oldSections.enumerated().flatMap({ (groupIdx, group) -> [IndexPath] in

            return group.objects.enumerated().map { IndexPath(row: $0.offset, section: groupIdx) }
        })
        
        for (newSectionIdx, newSection) in newSections.enumerated() {
            
            for (newRowObjectIdx, newRowObject) in newSection.objects.enumerated() {
                
                let newRowObjectIp = IndexPath(row: newRowObjectIdx, section: newSectionIdx)
                
                if let oldRowObjectIp = getIndexPath(for: newRowObject, in: oldSections) {
                    
                    rowDeletes.removeAll(where: { $0 == oldRowObjectIp })
                    
                    if newRowObjectIp != oldRowObjectIp {
                        
                        rowMoves.append(Move<IndexPath>(from: oldRowObjectIp, to: newRowObjectIp))
                    }
                    
                } else {
                    
                    rowInserts.append(newRowObjectIp)
                }
            }
        }
        
        return IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes)
    }
    
    private static func getIndexPath(for object: AnyEquatable, in groups: [Section]) -> IndexPath? {
        
        for (groupIdx, group) in groups.enumerated() {
            
            if let objectIdx = group.objects.firstIndex(where: { object.equal(any: $0) }) {
                
                return IndexPath(row: objectIdx, section: groupIdx)
            }
        }
        
        return nil
    }
    
    private static func checkDuplicates(in sections: [Section]) -> Bool {
        
        let allObjects = sections.flatMap { $0.objects }
        
        for (lhsIdx, lhsObj) in allObjects.enumerated() {
            
            for (rhsIdx, rhsObj) in allObjects.enumerated() {
                
                if lhsObj.equal(any: rhsObj) && lhsIdx != rhsIdx {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    // MARK: Public methods
    
    static func calculateDiff(from oldSections: [Section], to newSections: [Section]) throws -> Diff {
        
        guard
            checkDuplicates(in: oldSections) == false,
            checkDuplicates(in: newSections) == false
        else {
            
            throw DiffError.duplicates
        }
        
        // Sections diff.
        let sectionsDiff = calculateSectionsDiff(from: oldSections, to: newSections)
        
        // Build intermediate sections data.
        var intermediateSections: [Section] = []
        
        for newSection in newSections {
            
            let oldSection = oldSections.first(where: { $0.equal(any: newSection) })
            
            intermediateSections.append(oldSection ?? newSection)
        }
        
        // Rows diff.
        let rowsDiff = calculateRowsDiff(from: intermediateSections, to: newSections)
        
        return Diff(
            sections: sectionsDiff,
            rows: rowsDiff,
            intermediateData: intermediateSections,
            resultData: newSections
        )
    }
}
