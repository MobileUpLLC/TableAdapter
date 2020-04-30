//
//  UITableView.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 29.04.2020.
//

import UIKit

extension UITableView {
    
    func makeBatchUpdates(_ updates: () -> Void) {
        
        if #available(iOS 11.0, *) {
            
            performBatchUpdates(updates)
            
        } else {
            
            beginUpdates()
            updates()
            endUpdates()
        }
    }
}
