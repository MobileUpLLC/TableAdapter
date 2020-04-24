//
//  AnyObjectCell.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

class AnyObjectCell: UITableViewCell, Configurable {
    
    public func setup(with object: Any) {
        
        textLabel?.text = "\(object)"
    }
}
