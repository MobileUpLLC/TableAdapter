//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct Section<Item: Hashable, SectionId: Hashable> {
    
    typealias SectionType = Section<Item, SectionId>
    
    // MARK: Public properties
    
    public var id: SectionId
    public var items: [Item]
    
    public let header: Any?
    public let footer: Any?
    
    public let headerIdentifier: String?
    public let footerIdentifier: String?
    
    // MARK: Public methods
    
    public init(
        id               : SectionId,
        items            : [Item],
        header           : Any?     = nil,
        footer           : Any?     = nil,
        headerIdentifier : String?  = nil,
        footerIdentifier : String?  = nil
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
        lhs: Section<Item, SectionId>,
        rhs: Section<Item, SectionId>
    ) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
}
