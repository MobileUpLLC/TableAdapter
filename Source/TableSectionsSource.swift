//
//  TableSectionsSource.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

public protocol TableSectionsSource: AnyObject {
    
    // MARK: Optional
    
    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyEquatable) -> AnyEquatable?
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable?
}
