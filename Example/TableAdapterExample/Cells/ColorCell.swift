//
//  ColorCell.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import Foundation
import TableAdapter

class ColorCell: UITableViewCell, Configurable {
    
    func setup(with object: Float) {
        
        backgroundColor = UIColor(
            hue        : CGFloat(object),
            saturation : 1.0,
            brightness : 1.0,
            alpha      : 1.0
        )
    }
}
