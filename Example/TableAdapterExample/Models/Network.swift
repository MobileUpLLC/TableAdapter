//
//  Network.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 10.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

// MARK: Item

enum Item: Hashable {
    
    case net(Network)
    case config(String)
}

// MARK: Network

struct Network {
    
    // MARK: Public properties
    
    let name: String
    
    let identifier = UUID()
}

// MARK: Hashable

extension Network: Hashable {
    
    static func == (lhs: Network, rhs: Network) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
