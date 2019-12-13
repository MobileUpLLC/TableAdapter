//
//  TableAdapterDataSource.swift
//  Pods
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import UIKit

public protocol TableAdapterDataSource: AnyObject {
    
    // MARK: Cell
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String?
    
    // MARK: HeaderFooter
    
    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyEquatable) -> AnyEquatable?
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable?
    
    func tableAdapter(_ adapter: TableAdapter, headerIdentifierFor section: Int) -> String?
    
    func tableAdapter(_ adapter: TableAdapter, footerIdentifierFor section: Int) -> String?
}

// MARK: Default implementation

public extension TableAdapterDataSource {
    
    // MARK: Cell
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String? {
        
        return nil
    }
    
    // MARK: HeaderFooter
    
    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyEquatable) -> AnyEquatable? {
        
        return nil
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable? {
        
        return nil
    }
    
    func tableAdapter(_ adapter: TableAdapter, headerIdentifierFor section: Int) -> String? {
        
        return nil
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerIdentifierFor section: Int) -> String? {
        
        return nil
    }
}
