//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct Section<Item: Hashable, SectionId: Hashable, Header: Any> {
    
    typealias SectionType = Section<Item, SectionId, Header>
    
    // MARK: Public properties
    
    public var id: SectionId
    public var items: [Item]
    
    public let header: Header?
    public let footer: Header?
    
    public let headerIdentifier: String?
    public let footerIdentifier: String?
    
    // MARK: Public methods
    
    public init(
        id: SectionId,
        items: [Item],
        header: Header? = nil,
        footer: Header? = nil,
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
        lhs: Section<Item, SectionId, Header>,
        rhs: Section<Item, SectionId, Header>
    ) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
