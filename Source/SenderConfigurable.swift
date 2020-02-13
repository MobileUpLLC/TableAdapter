//
//  SenderConfigurable.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

// MARK: AnySenderConfigurable

public protocol AnySenderConfigurable {
    
    var anySenderType: Any.Type { get }
    
    var anyObjectType: Any.Type { get }
    
    func anySetup(with object: Any, sender: Any?)
}

// MARK: SenderConfigurable

public protocol SenderConfigurable: AnySenderConfigurable {
    
    associatedtype S: Any
    
    associatedtype T: Any
    
    func setup(with object: T, sender: S)
}

// MARK: AnySenderConfigurable Implementation

public extension SenderConfigurable {
    
    var anyObjectType: Any.Type {
        
        return T.self
    }
    
    var anySenderType: Any.Type {
        
        return S.self
    }
    
    func anySetup(with object: Any, sender: Any?) {
        
        guard let obj = object as? T else {
            
            assertionFailure("Could not cast value of type '\(type(of: object))' to expected type '\(T.self)'. '\(type(of: self))' must provide correct object type for Configurable protocol")
            return
        }
        
        guard let sen = sender as? S else {
            
            assertionFailure("Could not cast sender of type '\(type(of: sender))' to expected type '\(S.self)'. '\(type(of: self))' must provide correct sender type for SenderConfigurable protocol")
            
            return
        }
        
        setup(with: obj, sender: sen)
    }
    
}
