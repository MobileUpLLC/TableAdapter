//
//  DiffUtil.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

public protocol AnyEquatable {
    
    func equal(any: AnyEquatable?) -> Bool
}

public extension AnyEquatable where Self: Equatable {

    func equal(any: AnyEquatable?) -> Bool {

        if let aany = any as? Self {
            return aany == self
        }

        return false
    }
}

extension Int: AnyEquatable {}
extension String: AnyEquatable {}
extension Bool: AnyEquatable {}
extension Float: AnyEquatable {}
extension Double: AnyEquatable {}


public struct Move<T> {
    
    let from: T
    let to: T
}

public struct IndexPathsDiff {
    
    let inserts: [IndexPath]
    let moves: [Move<IndexPath>]
    let deletes: [IndexPath]
    let reloads: [IndexPath]
}

public struct Diff {
    
    let inserts: IndexSet
    let moves: [Move<Int>]
    let deletes: IndexSet
}

public class DiffUtil {
    
    // MARK: Override properties
    
    // MARK: Private properties
    
    // MARK: Public properties
    
    // MARK: Override methods
    
    // MARK: Private methods
    
    // MARK: Public methods
    
    public func calculateDiff(from oldObjects: [Any], to newObjects: [Any]) -> Diff? {
        
        let a = IndexSet(arrayLiteral: 1, 2, 3)
        
        let b = a.map { IndexPath(item: $0, section: 1) }
        
        return nil
    }
    
}