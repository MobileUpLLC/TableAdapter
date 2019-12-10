//
//  Group.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

public protocol SectionGroup {
    
    var header: Any { get }
    
    var footer: Any { get }
    
    var rowObjects: [AnyDifferentiable] { get }
}

public struct Group {
    
    // MARK: Public properties
    
    let header: AnyEquatable?
    
    let footer: AnyEquatable?
    
    var rowObjects: [AnyDifferentiable]
}

// MARK: Equatable

extension Group: Equatable, AnyEquatable {
    
    public static func == (lhs: Group, rhs: Group) -> Bool {
        
        return compare(lhs: lhs.header, rhs: rhs.header) && compare(lhs: lhs.footer, rhs: rhs.footer)
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
