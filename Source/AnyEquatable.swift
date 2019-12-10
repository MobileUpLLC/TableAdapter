//
//  AnyEquatable.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

// MARK: AnyIdentifiable

public protocol AnyIdentifiable {
    
    var id: AnyEquatable { get }
}

// MARK: AnyEquatable

public protocol AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool
}

public extension AnyEquatable where Self: Equatable {

    func equal(any: AnyEquatable?) -> Bool {

        if let any = any as? Self {
            
            return any == self
        }

        return false
    }
}

// MARK: AnyDifferentiableÔ

public typealias AnyDifferentiable = AnyIdentifiable & AnyEquatable

extension Int: AnyDifferentiable {
    
    public var id: AnyEquatable { return self }
    
}

extension String: AnyDifferentiable {
    
    public var id: AnyEquatable { return self }
    
}

extension Bool: AnyDifferentiable {
    
    public var id: AnyEquatable { return self }
    
}

extension Float: AnyDifferentiable {
    
    public var id: AnyEquatable { return self }
    
}

extension Double: AnyDifferentiable {
    
    public var id: AnyEquatable { return self }
    
}
