//
//  ConfigurableCell.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

// MARK: AnyConfigurable

public protocol AnyConfigurable {
    
    var anyObjectType: Any.Type { get }
    
    func anySetup(with object: Any)
}

// MARK: Configurable

public protocol Configurable: AnyConfigurable {
    
    associatedtype T: Any
    
    func setup(with object: T)
}

// MARK: AnyConfigurable Implementation

public extension Configurable {
    
    var anyObjectType: Any.Type {
        
        return T.self
    }
    
    func anySetup(with object: Any) {
        
        if let object = object as? T {
            
            setup(with: object)
            
        } else {
            
            assertionFailure("Could not cast value of type '\(type(of: object))' to expected type '\(T.self)'. '\(type(of: self))' must provide correct jeneric type for Configurable protocol")
        }
    }
}
