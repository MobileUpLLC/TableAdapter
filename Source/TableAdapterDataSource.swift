//
//  TableAdapterDataSource.swift
//  Pods
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import UIKit

public protocol TableAdapterDataSource: AnyObject {
    
    // MARK: Required
    
    func objects(for tableAdapter: TableAdapter) -> [Any]
    
    // MARK: Optional
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String
    
    func emptyStateViewForTableAdapter(_ adapter: TableAdapter) -> UIView?
}

public extension TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String {
        
        return "Cell"
    }
    
    func emptyStateViewForTableAdapter(_ adapter: TableAdapter) -> UIView? {
        
        return nil
    }
}
