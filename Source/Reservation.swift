//
//  Reservation.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 20.12.2019.
//

import Foundation

struct Reservation {
    
    let cellId: String
    let indexPath: IndexPath
    
    var row: Int { return indexPath.row }
    var section: Int { return indexPath.section }
    
    init(cellId: String, row: Int, section: Int) {
        
        self.cellId = cellId
        indexPath = IndexPath(row: row, section: section)
    }
}

// MARK: AnyEquatable

extension Reservation: Hashable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(indexPath)
    }
    
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        
        return lhs.indexPath == rhs.indexPath
    }
}

extension Reservation: Comparable {
    
    static func < (lhs: Reservation, rhs: Reservation) -> Bool {
        
        return lhs.indexPath < rhs.indexPath
    }    
}

extension Reservation: CustomStringConvertible {
    
    var description: String {
        
        return "CellId: `\(cellId)`, Position: [\(section), \(row)]"
    }
}
