//
//  Group.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

struct Group {
    
    // MARK: Public properties
    
    let header: AnyEquatable?
    
    let footer: AnyEquatable?
    
    var rowObjects: [AnyEquatable]
}

// MARK: Equatable

extension Group: Equatable, AnyEquatable {
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        
        return compare(lhs: lhs.header, rhs: rhs.header) && compare(lhs: lhs.footer, rhs: rhs.footer)
    }
    
    // nil nil -> equal
    // any nil -> not equal
    // nil any -> not euqal
    // any any -> check
    private static func compare(lhs: AnyEquatable?, rhs: AnyEquatable?) -> Bool {
        
        if lhs == nil && rhs == nil {
            
            return true
            
        } else if lhs != nil && rhs == nil {
            
            return false
            
        } else if lhs == nil && rhs != nil {
            
            return false
            
        } else {
            
            return lhs!.equal(any: rhs!)
        }
    }
}
