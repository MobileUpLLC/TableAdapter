//
//  AnyDifferentiable.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

// MARK: AnyDifferentiable

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
