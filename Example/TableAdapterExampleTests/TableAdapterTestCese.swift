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
        
        let result = [Int](from..<to)
        
        if shuffled {
            
            return result.shuffled()
            
        } else {
            
            return result
        }
    }
    
    func check<T: Hashable>(old: [T], new: [T]) {
        
        do {
            
            let diff = try DiffUtil.calculateDiff(form: old, to: new)
            
            let newDiffed = DiffUtil.applyDiff(diff, from: old) { new[$0] }
            
            let msg = """
            Original new and diffed new mismatch.

            Old:    \(old)
            New:    \(new)
            Diffed: \(newDiffed)
            
            Diff: \(diff)
            """
            print(msg)
            
            XCTAssert(newDiffed == new, msg)
            
        } catch {
            
            XCTAssert(false, "During calculationd diff an error occured: \(error)")
        }
    }
}
