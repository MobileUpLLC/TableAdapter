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
}

public struct IndexSetDiff {
    
    var inserts: IndexSet
    var moves: [Move<Int>]
    var deletes: IndexSet
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

public class DiffUtil {
    
    // MARK: Private methods
    
    static func getIndexPath(for object: AnyEquatable, in groups: [Group]) -> IndexPath? {
        
        for (groupIdx, group) in groups.enumerated() {
            
            if let objectIdx = group.rowObjects.firstIndex(where: { object.equal(any: $0) }) {
                
                return IndexPath(row: objectIdx, section: groupIdx)
            }
        }
        
        return nil
    }
    
    // MARK: Public methods
    
    static func calculateOrderedGroupsDiff(from oldGroups: [Group], to newGroups: [Group]) -> GroupsDiff {
        
        var secInserts = IndexSet()
        var secMoves = [Move<Int>]()
        var secDeletes = IndexSet()
        
        var rowInserts = [IndexPath]()
        var rowDeletes = [IndexPath]()
        var rowMoves = [Move<IndexPath>]()
        
        // Do some staff...
        
        
        var secDiff = IndexSetDiff(inserts: secInserts, moves: secMoves, deletes: secDeletes)
        var rowsDiff = IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes)
        
        var groupDiff = GroupsDiff(sectionsDiff: secDiff, rowsDiff: rowsDiff)
        
        return groupDiff
    }
    
    static func calculateGroupsDiff(from oldGroups: [Group], to newGroups: [Group]) -> GroupsDiff {
        
        var rowInserts = [IndexPath]()
        var rowDeletes = [IndexPath]()
        var rowMoves = [Move<IndexPath>]()
        
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
                    
                } else {
                    
                    rowInserts.append(newRowObjectIp)
                }
            }
        }
        
        var sectionDiff = DiffUtil.calculateDiff(from: oldGroups, to: newGroups)
//        sectionDiff.moves = []
        
        var rowsDiff = IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes)
//        rowsDiff.moves = []
//        rowsDiff.deletes = [IndexPath(row: 1, section: 0)]
        
        return GroupsDiff(sectionsDiff: sectionDiff, rowsDiff: rowsDiff)
    }
    
    public static func calculateDiff(from oldObjects: [AnyEquatable], to newObjects: [AnyEquatable]) -> IndexSetDiff {
        
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
                    
                } else {
                    
                    reloads.insert(newIdx)
                }
                                
            } else {
                
                inserts.insert(newIdx)
            }
        }
        
        return IndexSetDiff(inserts: inserts, moves: moves, deletes: deletes)
    }
}
