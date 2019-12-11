//
//  Example.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

struct Example {
    
    let name: String
    
    let controller: UIViewController.Type
}

extension Example: AnyDifferentiable {
    
    var id: AnyEquatable {
        
        return name
    }
    
    func equal(any: AnyEquatable?) -> Bool {
        
        guard let any = any as? Example else {
            
            return false
        }
        
        return name == any.name
    }
}
