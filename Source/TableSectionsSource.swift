//
//  TableSectionsSource.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

public protocol TableSectionsSource: AnyObject {
    
    // MARK: Optional
    
    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyDifferentiable) -> AnyDifferentiable?
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyDifferentiable) -> AnyDifferentiable?
}

public extension TableSectionsSource {
    
    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyDifferentiable) -> AnyDifferentiable? {
        
        return nil
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyDifferentiable) -> AnyDifferentiable? {
        
        return nil
    }
}
