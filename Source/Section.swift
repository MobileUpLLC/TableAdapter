//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct Section<ItemType: Hashable, SectionType: Hashable, HeaderType: Any> {
    
    // MARK: Public properties
    
    public var id: SectionType
    public var items: [ItemType]
    
    public let header: HeaderType?
    public let footer: HeaderType?
    
    public let headerIdentifier: String?
    public let footerIdentifier: String?
    
    // MARK: Public methods
    
    public init(
        id: SectionType,
        items: [ItemType],
        header: HeaderType? = nil,
        footer: HeaderType? = nil,
        headerIdentifier: String? = nil,
        footerIdentifier: String? = nil
    ) {
        self.id = id
        self.items = items
        
        self.header = header
        self.footer = footer
        
        self.headerIdentifier = headerIdentifier
        self.footerIdentifier = footerIdentifier
    }
}

// MARK: Hashable

extension Section: Hashable {
    
    public static func == (
        lhs: Section<ItemType, SectionType, HeaderType>,
        rhs: Section<ItemType, SectionType, HeaderType>
    ) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
