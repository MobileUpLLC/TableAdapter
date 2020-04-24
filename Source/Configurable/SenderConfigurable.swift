//
//  SenderConfigurable.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

// MARK: AnySenderConfigurable

public protocol AnySenderConfigurable {
    
    func anySetup(with item: Any, sender: Any?)
}

// MARK: SenderConfigurable

public protocol SenderConfigurable: AnySenderConfigurable {
    
    associatedtype SenderType: Any
    
    associatedtype ItemType: Any
    
    func setup(with item: ItemType, sender: SenderType)
}

// MARK: AnySenderConfigurable Implementation

public extension SenderConfigurable {
    
    func anySetup(with item: Any, sender: Any?) {
        
        guard let obj = item as? ItemType else {
            
            assertionFailure("Could not cast value of type '\(type(of: item))' to expected type '\(ItemType.self)'. '\(type(of: self))' must provide correct object type for Configurable protocol")
            return
        }
        
        guard let sen = sender as? SenderType else {
            
            assertionFailure("Could not cast sender of type '\(type(of: sender))' to expected type '\(SenderType.self)'. '\(type(of: self))' must provide correct sender type for SenderConfigurable protocol")
            
            return
        }
        
        setup(with: obj, sender: sen)
    }
}
