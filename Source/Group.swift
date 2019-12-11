//
//  Group.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

public protocol SectionGroup: AnyDifferentiable {
    
    var header: AnyDifferentiable? { get }
    
    var footer: AnyDifferentiable? { get }
    
    var rowObjects: [AnyDifferentiable] { get set }
}

public struct Group {
    
    // MARK: Public properties
    
    public let header: AnyDifferentiable?
    
    public let footer: AnyDifferentiable?
    
    public var rowObjects: [AnyDifferentiable]
}

// MARK: Equatable

extension Group: Equatable, SectionGroup {
    
    public var id: AnyEquatable {
        
        let headerId = header?.id ?? ""
        let footerId = footer?.id ?? ""
        
        return "\(headerId)-\(footerId)"
    }
    
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
