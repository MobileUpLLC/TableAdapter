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
    
    enum ItemType {
        
        case integer
        case string
        case bool
        case float
    }
    
    let type: ItemType
    let value: AnyEquatable
}

extension PrimitiveItem: AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool {
        return value.equal(any: any)
    }
}
