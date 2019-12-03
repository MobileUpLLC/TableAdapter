//
//  AnyEquatable.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

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

extension Int: AnyEquatable {}
extension String: AnyEquatable {}
extension Bool: AnyEquatable {}
extension Float: AnyEquatable {}
extension Double: AnyEquatable {}
