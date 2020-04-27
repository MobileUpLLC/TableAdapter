//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

struct SymbolEntry {

    var oc: Int
    var nc: Int
    var onlo: Int?
    
    var isUnque: Bool {
        
        return oc == 1 && nc == 1
    }
}

enum Entry<T: Hashable> {

    case pointer(p: T)
    case position(p: Int)
}

enum DiffError: Error {

    case duplicates
}

public class DiffUtil<ItemType: Hashable, SectionType: Hashable, HeaderType: Any> {
    
    typealias Sec = Section<ItemType, SectionType, HeaderType>
    
    // MARK: Private methods
    
    public static func calculatePhDiff<T: Hashable>(

        form oldItems: [T],
        to newItems: [T]

    ) -> IndexSetDiff {

        var symbolTable: [T: SymbolEntry] = [:]
        
        var na: [Entry<T>] = []
        var oa: [Entry<T>] = []

        // Pass 1.
        for (i, item) in newItems.enumerated() {
            
            if var symbolEntry = symbolTable[item] {
                
                symbolEntry.nc += 1
                
                symbolTable[item] = symbolEntry
                
            } else {
                
                symbolTable[item] = SymbolEntry(oc: 0, nc: 1, onlo: nil)
            }
            
            na.append(.pointer(p: item))
        }

        // Pass 2.
        for (j, item) in oldItems.enumerated() {
            
            if var symbolEntry = symbolTable[item] {
                
                symbolEntry.oc += 1
                symbolEntry.onlo = j
                
                symbolTable[item] = symbolEntry
                
            } else {
                
                symbolTable[item] = SymbolEntry(oc: 1, nc: 0, onlo: j)
            }
            
            
            oa.append(.pointer(p: item))
        }
        

        // Pass 3.
        for (i, entry) in na.enumerated() {
            
            switch entry {
                
            case .pointer(let p):
                if let symbolEntry = symbolTable[p], symbolEntry.isUnque {
                    
                    na[i] = .position(p: symbolEntry.onlo!)
                    oa[symbolEntry.onlo!] = .position(p: i)
                }
                
                
            case .position(_):
                assertionFailure("No positions here")
                break
            }
        }

        
        var result = IndexSetDiff(
            inserts: IndexSet(),
            moves: [],
            deletes: IndexSet()
        )
        
        
        for (i, entry) in na.enumerated() {
            
            switch entry {
                
            case .pointer(let p):
                result.inserts.insert(i)
                
            case .position(let p):
                
                if p != i {
                    
                    let m = Move<Int>(from: p, to: i)
                    result.moves.append(m)
                }
            }
        }
        
        for (j, entry) in oa.enumerated() {
            
            switch entry {
                
            case .pointer(let p):
                result.deletes.insert(j)
                
            case .position(let p):
                break
            }
            
        }

        return result
    }
    
    
    
    
    
    
    
    
    
    
    private static func calculateSectionsDiff(
        
        from oldObjects: [Sec],
        to newObjects: [Sec]
        
    ) -> IndexSetDiff {
        
        return calculatePhDiff(form: oldObjects, to: newObjects)
        
//        var inserts = IndexSet()
//        var moves = [Move<Int>]()
//        var deletes = IndexSet()
//
//        deletes.insert(integersIn: oldObjects.indices)
//
//        for (newIdx, newObject) in newObjects.enumerated() {
//
//            if let oldIdx = oldObjects.firstIndex(where: { newObject == $0 }) {
//
//                deletes.remove(oldIdx)
//
//                if oldIdx != newIdx {
//
//                    moves.append(Move<Int>(from: oldIdx, to: newIdx))
//                }
//
//            } else {
//
//                inserts.insert(newIdx)
//            }
//        }
//
//        return IndexSetDiff(inserts: inserts, moves: moves, deletes: deletes)
    }
    
    private static func calculateRowsDiff(
        
        from oldSections: [Sec],
        to newSections: [Sec]
        
    ) -> IndexPathDiff {
        
        assert(oldSections.count == newSections.count, "Sections count mismatch")
        
        var result = IndexPathDiff(inserts: [], moves: [], deletes: [])
        
        for i in 0..<oldSections.count {
            
            let indexSetDiff = calculatePhDiff(form: oldSections[i].items, to: newSections[i].items)
            let indexPathDiff = indexSetDiff.convertToIndexPathDiff(section: i)
            
            result.inserts.append(contentsOf: indexPathDiff.inserts)
            result.moves.append(contentsOf: indexPathDiff.moves)
            result.deletes.append(contentsOf: indexPathDiff.deletes)
        }
        
        return result
        
        
        
//        var rowInserts = [IndexPath]()
//        var rowDeletes = [IndexPath]()
//        var rowMoves = [Move<IndexPath>]()
//
//        // Map sections to index pathes.
//        rowDeletes = oldSections.enumerated().flatMap({ (groupIdx, group) -> [IndexPath] in
//
//            return group.items.enumerated().map { IndexPath(row: $0.offset, section: groupIdx) }
//        })
//
//        for (newSectionIdx, newSection) in newSections.enumerated() {
//
//            for (newRowObjectIdx, newRowObject) in newSection.items.enumerated() {
//
//                let newRowObjectIp = IndexPath(row: newRowObjectIdx, section: newSectionIdx)
//
//                if let oldRowObjectIp = getIndexPath(for: newRowObject, in: oldSections) {
//
//                    rowDeletes.removeAll(where: { $0 == oldRowObjectIp })
//
//                    if newRowObjectIp != oldRowObjectIp {
//
//                        rowMoves.append(Move<IndexPath>(from: oldRowObjectIp, to: newRowObjectIp))
//                    }
//
//                } else {
//
//                    rowInserts.append(newRowObjectIp)
//                }
//            }
//        }
//
//        return IndexPathDiff(inserts: rowInserts, moves: rowMoves, deletes: rowDeletes)
    }
    
//    private static func getIndexPath(
//        for object: ItemType,
//        in groups: [Sec]
//    ) -> IndexPath? {
//        
//        for (groupIdx, group) in groups.enumerated() {
//            
//            if let objectIdx = group.items.firstIndex(where: { object == $0 }) {
//                
//                return IndexPath(row: objectIdx, section: groupIdx)
//            }
//        }
//        
//        return nil
//    }
    
    private static func checkDuplicates(in sections: [Sec]) -> Bool {
        
        let allObjects = sections.flatMap { $0.items }
        
        for i in 0..<allObjects.count {
            
            for j in i+1..<allObjects.count {
                
                if allObjects[i] == allObjects[j] {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    // MARK: Public methods
    
    public static func applyDiff<T: Hashable>(
        _ diff: IndexSetDiff,
        from old: [T],
        insertsProvider: ((Int) -> T)
    ) -> [T] {
        
        let resultCount = old.count + diff.inserts.count - diff.deletes.count
        
        var result = Array<T?>(repeating: nil, count: resultCount)
        
        for move in diff.moves {
            
            result[move.to] = old[move.from]
        }
        
        for insert in diff.inserts {
            
            result[insert] = insertsProvider(insert)
        }
        
        for i in 0..<result.count {
            
            if result[i] == nil {
                
                result[i] = old[i]
            }
        }
        
//        for i in 0..<result.count {
//
//            if let move = diff.moves.first(where: { (move) -> Bool in move.to == i }) {
//
//                result[i] = old[move.from]
//
//            } else if diff.inserts.contains(i) {
//
//                result[i] = insertsProvider(i)
//
//            } else {
//
//                result[i] = old[i]
//            }
//        }
        
        return result.compactMap { $0 }
    }

    
    static func calculateDiff(
        from oldSections: [Sec],
        to newSections: [Sec]
    ) throws -> Diff<ItemType, SectionType, HeaderType> {
        
        guard
            checkDuplicates(in: oldSections) == false,
            checkDuplicates(in: newSections) == false
        else {
            
            throw DiffError.duplicates
        }
        
        // Sections diff.
        let sectionsDiff = calculateSectionsDiff(from: oldSections, to: newSections)
        
        // Build intermediate sections data.
//        var intermediateSections: [Sec] = []
//
//        for newSection in newSections {
//
//            let oldSection = oldSections.first(where: { $0 == newSection })
//
//            intermediateSections.append(oldSection ?? newSection)
//        }
        
        let intermediateSections = applyDiff(sectionsDiff, from: oldSections) { newSections[$0] }
        
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
