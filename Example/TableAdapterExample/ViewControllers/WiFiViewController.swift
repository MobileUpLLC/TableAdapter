//
//  WiFiViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 10.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class WiFiViewController: UIViewController {
        
    // MARK: Private properties
    
    private let networks: [Network] = [
        
        Network(name: "MobileUp"),
        Network(name: "Not found"),
        Network(name: "Winter is coming"),
        Network(name: "Outer space"),
        Network(name: "QWERTY"),
        Network(name: "Home"),
        Network(name: "Ocean Eyes"),
        Network(name: "99"),
        Network(name: "Cody Bear"),
        Network(name: "Infinity")
    ]
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var adapter = SupplementaryTableAdapter<Item, Int, String>(
        tableView: tableView,
        sender: self
    ) { [unowned self] (indexPath, item) -> String? in
        
        switch item {
           
        case .net(_):
            return self.networkCellIdentifier
            
        case .config(_):
            return self.wifiSwitchCellIdentifier
        }
    }
    
    private var currentNetwork: Network?
    
    private let wifiSwitchCellIdentifier = "WifiSettings"
    
    private let networkCellIdentifier = "Network"
    
    // MARK: Public properties
    
    var isWifiEnabled = true
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.cellDidSelectHandler = { [weak self] (table, indexPath, item) in
            
            table.deselectRow(at: indexPath, animated: true)
            
            if case let Item.net(net) = item {
                
                self?.currentNetwork = net
                
                self?.updateUI()
            }
        }
        
        setupTableView()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(WiFiSwitchCell.self, forCellReuseIdentifier: wifiSwitchCellIdentifier)
        tableView.register(NetworkCell.self, forCellReuseIdentifier: networkCellIdentifier)
    }
    
    private func updateUI() {
        
        let sections: [Section<Item, Int, String>]
        
        var configItems: [Item] = [.config("Wi-Fi")]
        
        if isWifiEnabled {
            
            var networkItems = networks
            
            if let net = currentNetwork {
                
                configItems.append(.net(net))
                
                networkItems.removeAll(where: { $0 == net })
            }
            
            let nets: [Item] = networkItems.map { .net($0) }
            
            sections = [
                Section<Item, Int, String>(id: 0, items: configItems, header: "Current network"),
                Section<Item, Int, String>(id: 1, items: nets, header: "Available networks"),
            ]
            
        } else {
            
            sections = [
                Section<Item, Int, String>(id: 0, items: configItems, header: "Current network")
            ]
        }
        
        adapter.update(with: sections, animated: true)
    }
    
    // MARK: Public methods
    
    @objc func toggleWifi(_ wifiSwitch: UISwitch) {
        
        isWifiEnabled = wifiSwitch.isOn
        
        updateUI()
    }
}
