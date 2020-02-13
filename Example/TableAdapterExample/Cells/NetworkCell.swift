//
//  NetworkCell.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class NetworkCell: UITableViewCell {
    
    // MARK: Override methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = nil
        accessoryType = .detailButton
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configurable

extension NetworkCell: Configurable {
    
    func setup(with object: Item) {
        
        if case let Item.net(net) = object { textLabel?.text = net.name }
    }
}
