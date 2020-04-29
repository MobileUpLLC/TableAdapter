//
//  Entry.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import Foundation

enum Entry<T: Hashable> {
    
    // Pointer to item SymbolTable entry.
    case stPointer(p: T)
    
    // Item position in oppposite file. For N it's position in O, and back.
    case oppositePosition(p: Int)
}
