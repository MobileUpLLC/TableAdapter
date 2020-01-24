//
//  TableAdapterDataSource.swift
//  Pods
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import UIKit

public protocol TableAdapterDataSource: AnyObject {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String?
}


public protocol MyTableAdapterDataSource: TableAdapterDataSource {
    
    associatedtype O: AnyEquatable
    
    associatedtype S: AnyEquatable
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, cellIdentifierFor object: O) -> String?
}

public extension MyTableAdapterDataSource {
    
    func tableAdapter(_ adapter: Any, cellIdentifierFor object: Any) -> String? {
        
        tableAdapter(adapter as! TableAdapter<O, S>, cellIdentifierFor: object as! O)
    }
}

