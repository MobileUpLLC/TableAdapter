//
//  PrimitiveItemCell.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

class PrimitiveItemCell: UITableViewCell, Configurable {
    
    public func setup(with object: PrimitiveItem) {
        
        textLabel?.text = "\(object.value)"
    }
}
