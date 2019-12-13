//
//  Network.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 10.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

struct Network {
    
    // MARK: Public properties
    
    let name: String
    
    let identifier = UUID()
}

// MARK: AnyDifferentiable

extension Network: Equatable, AnyEquatable {
    
    static func == (lhs: Network, rhs: Network) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
