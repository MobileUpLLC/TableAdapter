//
//  TitleHeaderFooterView.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 09.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class RedHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
}

// MARK: Configurable

extension RedHeaderFooterView: Configurable {
    
    func setup(with object: String) {
        
        titleLabel.text = object
    }
}
