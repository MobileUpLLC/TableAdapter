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
    
    associatedtype O: AnyEquatable
    associatedtype S: AnyEquatable
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, didSelect object: O)
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, headerIdentifierFor section: Int) -> String?
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, footerIdentifierFor section: Int) -> String?
    
}

// MARK: AnyTableAdapterDelegate Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: Any, didSelect object: Any) {
        
        tableAdapter(adapter as! TableAdapter<O, S>, didSelect: object as! O)
    }
    
    func tableAdapter(_ adapter: Any, headerIdentifierFor section: Int) -> String? {
        
        tableAdapter(adapter as! TableAdapter<O, S>, headerIdentifierFor: section)
    }
    
    func tableAdapter(_ adapter: Any, footerIdentifierFor section: Int) -> String? {
        
        tableAdapter(adapter as! TableAdapter<O, S>, footerIdentifierFor: section)
    }
}

// MARK: MyTableAdapterDelegate Default Implementation

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, didSelect object: O) {}
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, headerIdentifierFor section: Int) -> String? {
        
        return nil
    }
    
    func tableAdapter(_ adapter: TableAdapter<O, S>, footerIdentifierFor section: Int) -> String? {
        
        return nil
    }
}
