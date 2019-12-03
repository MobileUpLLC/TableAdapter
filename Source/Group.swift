//
//  Group.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 03.12.2019.
//

import Foundation

struct Group {
    
    // MARK: Public properties
    
    let header: AnyEquatable?
    
    let footer: AnyEquatable?
    
    var rowObjects: [AnyEquatable]
}
