//
//  File.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import Foundation

public struct IndexPathDiff {
    
    var inserts : [IndexPath]
    var moves   : [Move<IndexPath>]
    var deletes : [IndexPath]
}
