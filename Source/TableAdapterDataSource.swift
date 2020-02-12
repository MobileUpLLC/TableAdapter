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
    
    associatedtype ItemType: AnyEquatable
    associatedtype SectionType: AnyEquatable
    associatedtype HeaderType: Any
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        cellIdentifierFor object: ItemType
    ) -> String?
}

// MARK: AnyTableAdapterDataSource Implementation

public extension TableAdapterDataSource {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String? {
        
        tableAdapter(
            adapter as! TableAdapter<ItemType, SectionType, HeaderType>,
            cellIdentifierFor: object as! ItemType
        )
    }
}

