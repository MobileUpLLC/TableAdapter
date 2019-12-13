//
//  RightTitleHeaderFooterView.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class BlueHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
}

// MARK: Configurable

extension BlueHeaderFooterView: Configurable {
    
    func setup(with object: String) {
        
        titleLabel.text = object
    }
}
