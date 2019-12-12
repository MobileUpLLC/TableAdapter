//
//  AnyIdentifiable.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 12.12.2019.
//

import Foundation

// MARK: AnyIdentifiable

public protocol AnyIdentifiable {
    
    var id: AnyEquatable { get }
}
