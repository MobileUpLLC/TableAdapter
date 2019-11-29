//
//  ConfigurableCell.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

// MARK: AnyConfigurableCell

public protocol AnyConfigurableCell {
    
    var objectType: Any.Type { get }
    
    func anySetup(with object: Any)
}

// MARK: ConfigurableCell

public protocol ConfigurableCell: AnyConfigurableCell {
    
    associatedtype T: Any
    
    func setup(with object: T)
}

public extension ConfigurableCell {
    
    var objectType: Any.Type {
        
        return T.self
    }
    
    func anySetup(with object: Any) {
        
        if let object = object as? T {
            
            setup(with: object)
            
        } else {
            
            assertionFailure("Could not cast value of type \(type(of: object)) to expected type \(T.self). \(type(of: self)) must provide correct jeneric type for ConfigurableCell protocol")
        }
        
    }
}
