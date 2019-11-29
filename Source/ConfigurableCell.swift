//
//  ConfigurableCell.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.11.2019.
//

import Foundation

public protocol ConfigurableCell {
    
    associatedtype T
    
    func setup(with object: T)
}
