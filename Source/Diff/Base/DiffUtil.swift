//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

enum DiffError: Error {

    case invalidItemsCount(String)
    case unknown(String)
}

public class DiffUtil {
    
    public static func calculateDiff<T: Hashable>(

        form oldItems: [T],
        to newItems: [T]

    ) throws -> IndexSetDiff {

        var symbolTable: [T: SymbolEntry] = [:]
        
        var na: [Entry<T>] = []
        var oa: [Entry<T>] = []

        // Pass 1
        
        for item in newItems {
            
            if var symbolEntry = symbolTable[item] {
                
                symbolEntry.nc += 1
                
                symbolTable[item] = symbolEntry
                
            } else {
                
                symbolTable[item] = SymbolEntry(oc: 0, nc: 1, olno: nil)
            }
            
            na.append(.stPointer(p: item))
        }

        // Pass 2
        
        for (j, item) in oldItems.enumerated() {
            
            if var symbolEntry = symbolTable[item] {
                
                symbolEntry.oc += 1
                symbolEntry.olno = j
                
                symbolTable[item] = symbolEntry
                
            } else {
                
                symbolTable[item] = SymbolEntry(oc: 1, nc: 0, olno: j)
            }
            
            oa.append(.stPointer(p: item))
        }
        
        // Pass 3
        
        for (i, entry) in na.enumerated() {
            
            switch entry {
                
            case .stPointer(let p):
                if let symbolEntry = symbolTable[p], symbolEntry.isMutualUnqueLine {
                    
                    guard let olno = symbolEntry.olno else {
                        
                        throw DiffError.unknown("OLNO sholuld be specified for pointer entry `\(p)` in symbol table")
                    }
                    
                    na[i] = .oppositePosition(p: olno)
                    oa[olno] = .oppositePosition(p: i)
                }
                
            case .oppositePosition(let p):
                throw DiffError.unknown("No position entry `\(p)` should be in NA array on 3 pass")
            }
        }
        
        // Pass 4
        
        for i in 0..<na.count {
            
            if
                case let Entry.oppositePosition(p) = na[i],
                case let Entry.oppositePosition(j) = oa[p],
                i == j,
                
                na.count > i + 1,
                oa.count > j + 1,
                case let Entry.stPointer(ip) = na[i + 1],
                case let Entry.stPointer(jp) = oa[j + 1],
                ip == jp
            {
                na[i + 1] = .oppositePosition(p: j + 1)
                oa[j + 1] = .oppositePosition(p: i + 1)
            }
        }
        
        // Pass 5
        
        for i in (0..<na.count).reversed() {
            
            if
                case let Entry.oppositePosition(p) = na[i],
                case let Entry.oppositePosition(j) = oa[p],
                i == j,
                
                i > 0,
                j > 0,
                na.count > i,
                oa.count > j,
                case let Entry.stPointer(ip) = na[i - 1],
                case let Entry.stPointer(jp) = oa[j - 1],
                ip == jp
            {
                na[i - 1] = .oppositePosition(p: j - 1)
                oa[j - 1] = .oppositePosition(p: i - 1)
            }
        }
        
        // Collect Result
        
        var result = IndexSetDiff(
            inserts: IndexSet(),
            moves: [],
            deletes: IndexSet()
        )
        
        // Insets & Moves
        
        for (i, entry) in na.enumerated() {
            
            switch entry {
                
            case .stPointer(_):
                result.inserts.insert(i)
                
            case .oppositePosition(let p):
                
                if p != i {
                    
                    result.moves.append(Move<Int>(from: p, to: i))
                }
            }
        }
        
        // Deletes
        
        for (j, entry) in oa.enumerated() {
            
            switch entry {
                
            case .stPointer(_):
                result.deletes.insert(j)
                
            case .oppositePosition(_):
                break
            }
            
        }

        return result
    }
    
    public static func applyDiff<T: Hashable>(
        _ diff: IndexSetDiff,
        from old: [T],
        insertsProvider: ((Int) -> T)
    ) -> [T] {
        
        let resultCount = old.count + diff.inserts.count - diff.deletes.count
        
        var result = Array<T?>(repeating: nil, count: resultCount)
        
        var oldD: [T?] = old
        
        for delete in diff.deletes {
            
            oldD[delete] = nil
        }
        
        for move in diff.moves {
            
            result[move.to] = oldD[move.from]
        }
        
        for insert in diff.inserts {
            
            result[insert] = insertsProvider(insert)
        }
        
        for i in 0..<result.count {
            
            if result[i] == nil {
                
                result[i] = oldD[i]
            }
        }
        
        return result.compactMap { $0 }
    }
}

