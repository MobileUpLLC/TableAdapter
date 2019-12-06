//
//  TableAdapterDelegate.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 02.12.2019.
//

import Foundation

public protocol TableAdapterDelegate: AnyObject {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable)
}
