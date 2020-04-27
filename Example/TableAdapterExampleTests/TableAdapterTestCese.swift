//
//  TableAdapterTestCese.swift
//  TableAdapterExampleTests
//
//  Created by Nikolai Timonin on 27.04.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import XCTest
import TableAdapter

class TableAdapterTestCase: XCTestCase {
    
    // MARK: Public methods
    
    func makeList(from: Int, to: Int, shuffled: Bool = true) -> [Int] {
        
        let result = Array<Int>(from..<to)
        
        if shuffled {
            
            return result.shuffled()
            
        } else {
            
            return result
        }
    }
    
    func check<T: Hashable>(old: [T], new: [T]) {
        
        let diff = DiffUtil<Int, Int, Any>.calculatePhDiff(form: old, to: new)
        
        let newDiffed = DiffUtil<Int, Int, Any>.applyDiff(diff, from: old) { new[$0] }
        
        let msg = """
        Original new and diffed new mismatch.

        Old:    \(old)
        New:    \(new)
        Diffed: \(newDiffed)
        
        Diff: \(diff)
        """
        
        XCTAssert(newDiffed == new, msg)
    }
}
