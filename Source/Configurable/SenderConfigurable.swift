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

/// Implement in order to receive item and sender for reusable view setup.
/// If real item value type provided by Section doesn't match ItemType,
/// or real sender type provided by TableAdapter doesn't math SenderType
/// `setup()` method won't get called.
public protocol SenderConfigurable: AnySenderConfigurable {
    
    associatedtype SenderType : Any
    associatedtype ItemType   : Any

    func setup(with item: ItemType, sender: SenderType)
}

// MARK: AnySenderConfigurable Implementation

public extension SenderConfigurable {
    
    func anySetup(with item: Any, sender: Any?) {
        
        guard let obj = item as? ItemType else {

            let msg = """
            Could not cast item of type '\(type(of: item))' to expected type '\(ItemType.self)'.
            '\(type(of: self))' must provide correct object type for SenderConfigurable protocol
            """
            
            assertionFailure(msg)

            return
        }
        
        guard let sen = sender as? SenderType else {

            let msg = """
            Could not cast sender of type '\(type(of: sender))' to expected type '\(SenderType.self)'.
            '\(type(of: self))' must provide correct sender type for SenderConfigurable protocol
            """

            assertionFailure(msg)
            
            return
        }
        
        setup(with: obj, sender: sen)
    }
}
