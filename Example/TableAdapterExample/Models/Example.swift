//
//  Example.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

struct Example {
    
    let name: String
    
    let controller: UIViewController.Type
}

// MARK: Hashable

extension Example: Hashable {
    
    static func == (lhs: Example, rhs: Example) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(name)
    }
}
