//
//  TableAdapterDataSource.swift
//  Pods
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import UIKit

public protocol TableAdapterDataSource: AnyObject {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String
}

public extension TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String {
        
        return adapter.defaultCellIdentifier
    }
}
