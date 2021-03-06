//
//  TableAdapterExampleTests.swift
//  TableAdapterExampleTests
//
//  Created by Nikolai Timonin on 24.04.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import XCTest

class CalculateDiffTests: DiffTestCase {
    
    // MARK: Private properties
    
    private let oldCount = 100
    private let dropCount = 50
    private let insertCount = 20
    
    // MARK: Public methods
    
    func testInsert() {
        
        let old = makeList(from: 0, to: oldCount)
        
        var new = old
        new.append(contentsOf: makeList(from: oldCount, to: oldCount + insertCount))
        new.shuffle()
        
        check(old: old, new: new)
    }
    
    func testDelete() {
        
        let old = makeList(from: 0, to: oldCount)
        
        let new = old.dropLast(dropCount).shuffled()
        
        check(old: old, new: new)
    }
    
    func testShuffle() {
        
        let old = makeList(from: 0, to: oldCount)
        
        let new = old.shuffled()
        
        check(old: old, new: new)
    }
    
    func testMixed() {
        
        for _ in 0..<100 {
            
            let old = makeList(from: 0, to: oldCount)
            
            var new = old.dropLast(dropCount).shuffled()
            
            let add = makeList(from: oldCount, to: oldCount + insertCount)
            new.append(contentsOf: add)
            new.shuffle()
            
            check(old: old, new: new)
        }        
    }
    
    func testDuplicates() {
        
        let old = [1, 1, 4, 5]
        let new = [1, 1]
        
        check(old: old, new: new)
    }
}
