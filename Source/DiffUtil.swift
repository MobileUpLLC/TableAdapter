//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

public struct Move<T> {
    
    let from: T
    let to: T
}

extension Move: CustomStringConvertible {
    
    public var description: String {
        
        return "\(from) -> \(to)"
    }
}

public struct IndexPathDiff {
    
    var inserts: [IndexPath]
    var moves: [Move<IndexPath>]
    var deletes: [IndexPath]
    var reloads: [IndexPath]
}

public struct IndexSetDiff {
    
    var inserts: IndexSet
    var moves: [Move<Int>]
    var deletes: IndexSet
    var reloads: IndexSet
}

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

enum DiffError: Error {
    
    case duplicates
    case moveSection
}

public class DiffUtil {
    
    // MARK: Private methods
    
    private static func getIndexPath(for object: AnyDifferentiable, in groups: [Section]) -> IndexPath? {
        
        for (groupIdx, group) in groups.enumerated() {
            
            if let objectIdx = group.rowObjects.firstIndex(where: { object.id.equal(any: $0.id) }) {
                
                return IndexPath(row: objectIdx, section: groupIdx)
            }
        }
        
        return nil
    }
    
    private static func checkDuplicates(in sections: [Section]) -> Bool {
        
        let allObjects = sections.flatMap { $0.rowObjects }
        
        for (lhsIdx, lhsObj) in allObjects.enumerated() {
            
            for (rhsIdx, rhsObj) in allObjects.enumerated() {
                
                if lhsObj.id.equal(any: rhsObj.id) && lhsIdx != rhsIdx {
                    
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
        
        var rowInserts = [IndexPath]()
        var rowDeletes = [IndexPath]()
        var rowMoves = [Move<IndexPath>]()
        var rowReloads = [IndexPath]()
        
        // Map groups to index pathes.
        rowDeletes = oldGroups.enumerated().flatMap({ (groupIdx, group) -> [IndexPath] in

            return group.rowObjects.enumerated().map { IndexPath(row: $0.offset, section: groupIdx) }
        })
        
        for (newGroupIdx, newGroup) in newGroups.enumerated() {
            
            for (newRowObjectIdx, newRowObject) in newGroup.rowObjects.enumerated() {
                
                let newRowObjectIp = IndexPath(row: newRowObjectIdx, section: newGroupIdx)
                
                if let oldRowObjectIp = getIndexPath(for: newRowObject, in: oldGroups) {
                    
                    rowDeletes.removeAll(where: { $0 == oldRowObjectIp })
                    
                    if newRowObjectIp != oldRowObjectIp {
                        
                        rowMoves.append(Move<IndexPath>(from: oldRowObjectIp, to: newRowObjectIp))
                    }
                    
                    let oldRowObject = oldGroups[oldRowObjectIp.section].rowObjects[oldRowObjectIp.row]
                    
                    if newRowObject.equal(any: oldRowObject) == false {
                        
                        rowReloads.append(newRowObjectIp)
                    }
                    
                } else {
                    
                    rowInserts.append(newRowObjectIp)
                }
            }
        }
        
        let sectionDiff = DiffUtil.calculateDiff(from: oldGroups, to: newGroups)
        
        let rowsDiff = IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes, reloads: rowReloads)
        
        return GroupsDiff(sectionsDiff: sectionDiff, rowsDiff: rowsDiff)
    }
    
    public static func calculateDiff(
        
        from oldObjects: [AnyDifferentiable],
        to newObjects: [AnyDifferentiable]
        
    ) -> IndexSetDiff {
        
        var inserts = IndexSet()
        var moves = [Move<Int>]()
        var deletes = IndexSet()
        var reloads = IndexSet()
        
        deletes.insert(integersIn: oldObjects.indices)
        
        for (newIdx, newObject) in newObjects.enumerated() {
            
            if let oldIdx = oldObjects.firstIndex(where: { newObject.id.equal(any: $0.id) }) {
                
                let oldObject = oldObjects[oldIdx]
                
                deletes.remove(oldIdx)
                
                if oldIdx != newIdx {
                    
                    moves.append(Move<Int>(from: oldIdx, to: newIdx))
                }
                
                if oldObject.equal(any: newObject) == false {
                    
                    reloads.insert(newIdx)
                }
                                
            } else {
                
                inserts.insert(newIdx)
            }
        }
        
        return IndexSetDiff(inserts: inserts, moves: moves, deletes: deletes, reloads: reloads)
    }
}
