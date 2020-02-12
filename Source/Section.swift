//
//  Section.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//

import Foundation

public protocol OldSection: Hashable {
    
    associatedtype ItemType: Hashable
    associatedtype SectionType: Hashable
    associatedtype HeaderType: Any
    associatedtype FooterType: Any
    
    var id: SectionType { get set }
    var objects: [ItemType] { get set }
    
    var header: HeaderType? { get set }
    var footer: FooterType? { get set }
}

