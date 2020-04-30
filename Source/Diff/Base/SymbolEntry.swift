//
//  SymbolEntry.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import Foundation

struct SymbolEntry {
    
    /// Number of item copies in Old file.
    var oc: Int
    
    /// Number of item copies in New file.
    var nc: Int
    
    /// Item position in Old file.
    var olno: Int?
    
    var isMutualUnqueLine: Bool {
        
        return oc == 1 && oc == nc
    }
}
