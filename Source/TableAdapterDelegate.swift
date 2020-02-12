//
//  TableAdapterDelegate.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import UIKit

public protocol AnyTableAdapterDelegate: AnyObject {
    
    func tableAdapter(_ adapter: Any, didSelect object: Any)
    
    func tableAdapter(_ adapter: Any, headerIdentifierFor section: Int) -> String?
    
    func tableAdapter(_ adapter: Any, footerIdentifierFor section: Int) -> String?
}

public protocol TableAdapterDelegate: AnyTableAdapterDelegate {
    
    associatedtype ItemType: AnyEquatable
    associatedtype SectionType: AnyEquatable
    associatedtype HeaderType: Any
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        didSelect object: ItemType
    )
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        headerIdentifierFor section: Int
    ) -> String?
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        footerIdentifierFor section: Int
    ) -> String?
}

// MARK: AnyTableAdapterDelegate Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: Any, didSelect object: Any) {
        
        tableAdapter(
            adapter as! TableAdapter<ItemType, SectionType, HeaderType>,
            didSelect: object as! ItemType
        )
    }
    
    func tableAdapter(_ adapter: Any, headerIdentifierFor section: Int) -> String? {
        
        tableAdapter(
            adapter as! TableAdapter<ItemType, SectionType, HeaderType>,
            headerIdentifierFor: section
        )
    }
    
    func tableAdapter(_ adapter: Any, footerIdentifierFor section: Int) -> String? {
        
        tableAdapter(
            adapter as! TableAdapter<ItemType, SectionType, HeaderType>,
            footerIdentifierFor: section
        )
    }
}

// MARK: MyTableAdapterDelegate Default Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        didSelect object: ItemType
    ) {}
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        headerIdentifierFor section: Int
    ) -> String? {
        
        return nil
    }
    
    func tableAdapter(
        _ adapter: TableAdapter<ItemType, SectionType, HeaderType>,
        footerIdentifierFor section: Int
    ) -> String? {
        
        return nil
    }
}
