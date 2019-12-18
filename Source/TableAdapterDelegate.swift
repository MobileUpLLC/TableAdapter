//
//  TableAdapterDelegate.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import UIKit

public protocol TableAdapterDelegate: AnyObject {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable)
    
    func tableAdapter(_ adapter: TableAdapter, didScroll view: UIScrollView)
    
}

public extension TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didScroll view: UIScrollView) { }
}
