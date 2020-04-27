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
                    
                    guard let olno = symbolEntry.onlo else {
                        
                        throw DiffError.unknown("OLNO sholuld be specified for unique pointer entry in symbol table")
                    }
                    
                    na[i] = .position(p: olno)
                    oa[olno] = .position(p: i)
                }
                
                
            case .position(_):
                throw DiffError.unknown("No position entry should be in NA on 3 pass")
            }
        }
        
        // Pass 4
        
        // Pass 5
        
        // Collect Result
        
        var result = IndexSetDiff(
            inserts: IndexSet(),
            moves: [],
            deletes: IndexSet()
        )
        
        // Insets & Moves
        
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
        
        // Deletes
        
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

