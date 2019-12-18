//
//  DefaultSection.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

public struct DefaultSection {
    
    public var objects: [AnyEquatable]
    
    public let headerObject: AnyEquatable?
    public let footerObject: AnyEquatable?
}

// MARK: DefaultSection

extension DefaultSection: Section {
    
    public var header: Any? {

        return headerObject
    }

    public var footer: Any? {
        
        return footerObject
    }
}

// MARK: Equatable

extension DefaultSection: Equatable {
    
    public static func == (lhs: DefaultSection, rhs: DefaultSection) -> Bool {
        
        return compare(lhs: lhs.headerObject, rhs: rhs.headerObject)
            && compare(lhs: lhs.footerObject, rhs: rhs.footerObject)
    }
    
    private static func compare(lhs: AnyEquatable?, rhs: AnyEquatable?) -> Bool {
        
        switch (lhs, rhs) {
            
        case let (l?, r?):
            return l.equal(any: r)
            
        case (.none, .none):
            return true
        
        case (.none, .some), (.some, .none):
            return false
        }
    }
}
