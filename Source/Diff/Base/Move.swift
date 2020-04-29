//
//  Move.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import Foundation

public struct Move<T> {
    
    public let from: T
    public let to: T
}

// MARK: CustomStringConvertible

extension Move: CustomStringConvertible {
    
    public var description: String {
        
        return "\(from) -> \(to)"
    }
}
