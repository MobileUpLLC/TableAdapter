//
//  SortUtil.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import Foundation

final class SortUtil<T: Comparable> {
    
    // MARK: Private properties
    
    private let originItems : [T]
    private var items       : [T]

    private var currentIndex: Int
    
    // MARK: Public properties
    
    var currentItems: [T] {
        
        return items
    }
    
    var isSorted: Bool {
        
        return currentIndex >= items.count
    }
    
    // MARK: Public methods
    
    init(items: [T]) {
        
        self.items = items
        originItems = items
        currentIndex = 1
    }
    
    func refresh() {
        
        items = originItems
        currentIndex = 1
    }
    
    func nextStepSorted() -> [T] {
        
        let item = items[currentIndex]
        var index = currentIndex - 1
        
        while index >= 0 && item < items[index] {
            
            items[index + 1] = items[index]
            items[index] = item
            
            index -= 1
        }
        
        currentIndex += 1
        
        return items
    }
}
