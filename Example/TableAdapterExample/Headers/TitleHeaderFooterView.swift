//
//  TitleHeaderFooterView.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 09.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class TitleHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

// MARK: Configurable

extension TitleHeaderFooterView: Configurable {
    
    func setup(with object: String) {
        
        titleLabel.text = object + "qwe"
        
        backgroundView = nil
    }
}
