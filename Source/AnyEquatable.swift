//
//  AnyEquatable.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

// MARK: AnyEquatable

public protocol AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool
}

public extension AnyEquatable where Self: Equatable {

    func equal(any: AnyEquatable?) -> Bool {

        if let any = any as? Self {
            
            return any == self
        }

        return false
    }
}
