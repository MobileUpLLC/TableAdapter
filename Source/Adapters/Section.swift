//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

/// Section contains all iformation for section setup in table view.
public struct Section<Item: Hashable, SectionId: Hashable> {
    
    typealias SectionType = Section<Item, SectionId>
    
    // MARK: Public properties
    
    public var id    : SectionId
    public var items : [Item]

    public let header : HeaderFooterConfig?
    public let footer : HeaderFooterConfig?

    // MARK: Public methods

    /// Intitialize section.
    /// - Parameters:
    ///   - id: Section id. Must be unique in terms of Hashable protocol.
    ///   - items: Items for cells in table view section.
    ///   - header: Model for header view setup.
    ///   - footer: Model for footer view setup.
    public init(
        id               : SectionId,
        items            : [Item],
        header           : HeaderFooterConfig?     = nil,
        footer           : HeaderFooterConfig?     = nil
    ) {
        self.id = id
        self.items = items
        
        self.header = header
        self.footer = footer
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
