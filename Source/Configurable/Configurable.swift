//
//  ConfigurableCell.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

// MARK: AnyConfigurable

public protocol AnyConfigurable {
    
    func anySetup(with item: Any)
}

// MARK: Configurable

public protocol Configurable: AnyConfigurable {
    
    associatedtype ItemType: Any
    
    func setup(with item: ItemType)
}

// MARK: AnyConfigurable Implementation

public extension Configurable {
    
    func anySetup(with item: Any) {
        
        if let item = item as? ItemType {
            
            setup(with: item)
            
        } else {
            
            assertionFailure("Could not cast value of type '\(type(of: item))' to expected type '\(ItemType.self)'. '\(type(of: self))' must provide correct jeneric type for Configurable protocol")
        }
    }
}
