//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public protocol Section: AnyDifferentiable {
    
    var header: Any? { get }
    
    var footer: Any? { get }
    
    var rowObjects: [AnyDifferentiable] { get set }
}
