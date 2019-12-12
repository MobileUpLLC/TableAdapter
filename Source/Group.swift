//
//  Group.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

struct Group {
    
    public let headerObject: AnyDifferentiable?
    
    public let footerObject: AnyDifferentiable?
    
    public var objects: [AnyDifferentiable]
}

// MARK: SectionGroup

extension Group: Section {
    
    public var header: Any? {

        return headerObject
    }

    public var footer: Any? {
        
        return footerObject
    }
    
    public var id: AnyEquatable {
        
        let headerId = headerObject?.id ?? ""
        let footerId = footerObject?.id ?? ""
        
        return "\(headerId)-\(footerId)"
    }
}

// MARK: Equatable

extension Group: Equatable {
    
    public static func == (lhs: Group, rhs: Group) -> Bool {
        
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
