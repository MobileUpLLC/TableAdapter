//
//  DefaultSection.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public struct DefaultSection: Section {
    
    public func equal(any: AnyEquatable?) -> Bool { return false }
    
    public var id: AnyEquatable
    
    public let header: Any?
    
    public let footer: Any?
    
    public var rowObjects: [AnyDifferentiable]
}

public extension DefaultSection {
    
    init(
        id: AnyEquatable,
        header: Any? = nil,
        footer: Any? = nil,
        objects: [AnyDifferentiable]
    ) {
        self.id = id
        self.header = header
        self.footer = footer
        self.rowObjects = objects
    }
}
