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
    
    associatedtype O: AnyEquatable
    
    associatedtype S: AnyEquatable
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, cellIdentifierFor object: O) -> String?
}

// MARK: AnyTableAdapterDataSource Implementation

public extension TableAdapterDataSource {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String? {
        
        tableAdapter(adapter as! TableAdapter<O, S>, cellIdentifierFor: object as! O)
    }
}

