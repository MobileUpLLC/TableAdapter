//
//  TableAdapterDelegate.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import UIKit

public protocol AnyTableAdapterDelegate: AnyObject {
    
    func tableAdapter(_ adapter: Any, didSelect object: Any)
}

public protocol TableAdapterDelegate: AnyTableAdapterDelegate {
    
    associatedtype ItemType: Hashable
    associatedtype SectionType: Hashable
    associatedtype HeaderType: Any
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        didSelect object: ItemType
    )
}

// MARK: AnyTableAdapterDelegate Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: Any, didSelect object: Any) {
        
        guard let resultAdapter = adapter as? TableAdapter<ItemType, SectionType, HeaderType> else {
            
            assertionFailure("Could not cast table adapter of type '\(type(of: adapter))' to expected type '\(TableAdapter<ItemType, SectionType, HeaderType>.self)'.")
            
            return
        }
        
        guard let resultItem = object as? ItemType else {
            
            assertionFailure("Could not cast cell item of type '\(type(of: object))' to expected type '\(ItemType.self)'.")
            
            return
        }
        
        tableAdapter(resultAdapter, didSelect: resultItem)
    }
}

// MARK: MyTableAdapterDelegate Default Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter<ItemType, SectionType, HeaderType>, didSelect object: ItemType) {}
}
