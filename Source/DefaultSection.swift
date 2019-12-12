//
//  DefaultSection.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct DefaultSection: Section {
    
    // MARK: Public properties
    
    public var id: AnyEquatable
    
    public let header: Any?
    
    public let footer: Any?
    
    public var objects: [AnyDifferentiable]
    
    // MARK: Public methods
    
    public init(
        
        id: AnyEquatable,
        header: Any? = nil,
        footer: Any? = nil,
        objects: [AnyDifferentiable]
    ) {
        self.id = id
        self.header = header
        self.footer = footer
        self.objects = objects
    }
}

// MARK: Equatable

extension DefaultSection: Equatable {
    
    public static func == (lhs: DefaultSection, rhs: DefaultSection) -> Bool {
        
        return lhs.id.equal(any: rhs.id)
    }
}
