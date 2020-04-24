//
//  TableAdapterDataSource.swift
//  Pods
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import UIKit

// MARK: AnyTableAdapterDataSource

public protocol AnyTableAdapterDataSource: AnyObject {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String?
}

// MARK: TableAdapterDataSource

public protocol TableAdapterDataSource: AnyTableAdapterDataSource {
    
    associatedtype ItemType: Hashable
    associatedtype SectionType: Hashable
    associatedtype HeaderType: Any
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        cellIdentifierFor object: ItemType
    ) -> String?
}

// MARK: AnyTableAdapterDataSource Implementation

public extension TableAdapterDataSource {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String? {
        
        guard let resultAdapter = adapter as? TableAdapter<ItemType, SectionType, HeaderType> else {
            
            assertionFailure("Could not cast table adapter of type '\(type(of: adapter))' to expected type '\(TableAdapter<ItemType, SectionType, HeaderType>.self)'.")
            
            return nil
        }
        
        guard let resultItem = object as? ItemType else {
            
            assertionFailure("Could not cast cell item of type '\(type(of: object))' to expected type '\(ItemType.self)'.")
            
            return nil
        }
        
        return tableAdapter(resultAdapter, cellIdentifierFor: resultItem)
    }
}
