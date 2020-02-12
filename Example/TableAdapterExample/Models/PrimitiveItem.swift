//
//  PrimitiveItem.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 24.01.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

struct PrimitiveItem {
    
    // MARK: Types
    
    enum ItemType {
        
        case integer
        case string
        case bool
        case float
    }
    
    // MARK: Public properties
    
    var id: String {
        
        return String(describing: value)
    }
    
    let type: ItemType
    
    let value: CustomStringConvertible
}

// MARK: Hashable

extension PrimitiveItem: Hashable {
    
    static func == (lhs: PrimitiveItem, rhs: PrimitiveItem) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
