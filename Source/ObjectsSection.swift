//
//  DefaultSection.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct Section<ItemType: AnyEquatable, SectionType: AnyEquatable>: AnyEquatable {
    
    // MARK: Public properties
    
    public var id: SectionType
    
    public var objects: [ItemType]
    
    public let header: Any?
    public let footer: Any?
    
    // MARK: Public methods
    
    public init(
        
        id: SectionType,
        objects: [ItemType],
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

extension Section: Equatable {
    
    public static func == (lhs: Section, rhs: Section) -> Bool {
        
        return lhs.id.equal(any: rhs.id)
    }
}
