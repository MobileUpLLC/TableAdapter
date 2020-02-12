//
//  DefaultSection.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct Section<ItemType: AnyEquatable, SectionType: AnyEquatable, HeaderType: Any>: AnyEquatable {
    
    // MARK: Public properties
    
    public var id: SectionType
    
    public var objects: [ItemType]
    
    public let header: HeaderType?
    public let footer: HeaderType?
    
    public let headerIdentifier: String?
    public let footerIdentifier: String?
    
    // MARK: Public methods
    
    public init(
        id: SectionType,
        objects: [ItemType],
        header: HeaderType? = nil,
        footer: HeaderType? = nil,
        headerIdentifier: String? = nil,
        footerIdentifier: String? = nil
    ) {
        self.id = id
        self.objects = objects
        
        self.header = header
        self.footer = footer
        
        self.headerIdentifier = headerIdentifier
        self.footerIdentifier = footerIdentifier
    }
}

// MARK: Equatable

extension Section: Equatable {
    
    public static func == (lhs: Section, rhs: Section) -> Bool {
        
        return lhs.id.equal(any: rhs.id)
    }
}
