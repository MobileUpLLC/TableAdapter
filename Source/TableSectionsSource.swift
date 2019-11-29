//
//  TableSectionsSource.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

public protocol TableSectionsSource: AnyObject {
    
    // MARK: Optional
    
    func tableAdapter(_ adapter: TableAdapter, sectionViewIdentifierFor object: Any) -> String
    
    func tableAdapter(_ adapter: TableAdapter, sectionObjectFor object: Any) -> Any
}

public extension TableSectionsSource {
    
    
}
