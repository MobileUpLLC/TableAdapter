//
//  DefaultSection.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct ObjectsSection: Section {
    
    // MARK: Public properties
    
    public var id: AnyEquatable
    
    public var objects: [AnyEquatable]
    
    public let header: Any?
    
    public let footer: Any?
    
    // MARK: Public methods
    
    public init(
        
        id: AnyEquatable,
        objects: [AnyEquatable],
        header: Any? = nil,
        footer: Any? = nil
    ) {
        self.id = id
        self.objects = objects
        
        self.header = header
        self.footer = footer
    }
}

// MARK: Equatable

extension ObjectsSection: Equatable {
    
    public static func == (lhs: ObjectsSection, rhs: ObjectsSection) -> Bool {
        
        return lhs.id.equal(any: rhs.id)
    }
}
