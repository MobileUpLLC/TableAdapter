//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

enum DiffError: Error {
    
    case duplicates
    case moveSection
}

public class DiffUtil {
    
    // MARK: Private methods
    
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
    
    static func calculateSectionsDiff(from oldGroups: [Section], to newGroups: [Section]) throws -> GroupsDiff {
        
        guard
            
            checkDuplicates(in: oldGroups) == false,
            checkDuplicates(in: newGroups) == false
        
        else {
            
            throw DiffError.duplicates
        }
        
        let sectionDiff = try DiffUtil.calculateDiff(from: oldGroups, to: newGroups)
        
        var rowInserts = [IndexPath]()
        var rowDeletes = [IndexPath]()
        var rowMoves = [Move<IndexPath>]()
        var rowReloads = [IndexPath]()
        
        // Map groups to index pathes.
        rowDeletes = oldGroups.enumerated().flatMap({ (groupIdx, group) -> [IndexPath] in

            return group.objects.enumerated().map { IndexPath(row: $0.offset, section: groupIdx) }
        })
        
        for (newGroupIdx, newGroup) in newGroups.enumerated() {
            
            for (newRowObjectIdx, newRowObject) in newGroup.objects.enumerated() {
                
                let newRowObjectIp = IndexPath(row: newRowObjectIdx, section: newGroupIdx)
                
                if let oldRowObjectIp = getIndexPath(for: newRowObject, in: oldGroups) {
                    
                    rowDeletes.removeAll(where: { $0 == oldRowObjectIp })
                    
                    if newRowObjectIp != oldRowObjectIp {
                        
                        rowMoves.append(Move<IndexPath>(from: oldRowObjectIp, to: newRowObjectIp))
                    }
                    
//                    let oldRowObject = oldGroups[oldRowObjectIp.section].objects[oldRowObjectIp.row]
//
//                    if newRowObject.equal(any: oldRowObject) == false {
//
//                        rowReloads.append(newRowObjectIp)
//                    }
                    
                } else {
                    
                    rowInserts.append(newRowObjectIp)
                }
            }
        }
        
        let rowsDiff = IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes, reloads: rowReloads)
        
        return GroupsDiff(sectionsDiff: sectionDiff, rowsDiff: rowsDiff)
    }
    
    public static func calculateDiff(
        
        from oldObjects: [AnyEquatable],
        to newObjects: [AnyEquatable]
        
    ) throws -> IndexSetDiff {
        
        var inserts = IndexSet()
        var moves = [Move<Int>]()
        var deletes = IndexSet()
        var reloads = IndexSet()
        
        deletes.insert(integersIn: oldObjects.indices)
        
        for (newIdx, newObject) in newObjects.enumerated() {
            
            if let oldIdx = oldObjects.firstIndex(where: { newObject.equal(any: $0) }) {
                
                deletes.remove(oldIdx)
                
                if oldIdx != newIdx {
                    
                    moves.append(Move<Int>(from: oldIdx, to: newIdx))
                    
                    throw DiffError.moveSection
                }
                
//                let oldObject = oldObjects[oldIdx]
//
//                if oldObject.equal(any: newObject) == false {
//
//                    reloads.insert(newIdx)
//                }
                                
            } else {
                
                inserts.insert(newIdx)
            }
        }
        
        return IndexSetDiff(inserts: inserts, moves: moves, deletes: deletes, reloads: reloads)
    }
}
