//
//  WiFiSwitchCell.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 13.02.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class WiFiSwitchCell: UITableViewCell {
    
    // MARK: Override methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryView = UISwitch()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SenderConfigurable

extension WiFiSwitchCell: SenderConfigurable {
    
    func setup(with object: Item, sender: WiFiViewController) {
        
        guard let wifiSwitch = accessoryView as? UISwitch else { return }
        
        if case let Item.config(str) = object { textLabel?.text = str }
        
        wifiSwitch.isOn = sender.isWifiEnabled
        
        wifiSwitch.addTarget(
            sender,
            action: #selector(WiFiViewController.toggleWifi(_:)),
            for: .touchUpInside
        )
    }
}
