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
    
    private lazy var adapter = TableAdapter(tableView: tableView, sender: self)
    
    private var currentNetwork: Network?
    
    private let wifiSwitchCellIdentifier = "WifiSettings"
    
    private let networkCellIdentifier = "Network"
    
    private let wifiItem = "Wi-Fi"
    
    // MARK: Public properties
    
    var isWifiEnabled = true
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTableAdapter()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableAdapter() {
        
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(WiFiSwitchCell.self, forCellReuseIdentifier: wifiSwitchCellIdentifier)
        tableView.register(NetworkCell.self, forCellReuseIdentifier: networkCellIdentifier)
    }
    
    private func updateUI() {
        
        let sections: [Section]
        
        if isWifiEnabled {
            
            var networkItems = networks
            
            var configItems: [AnyEquatable] = [wifiItem]
            
            if let net = currentNetwork {
                
                configItems.append(net)
                
                networkItems.removeAll(where: { $0 == net })
            }
            
            sections = [
                
                ObjectsSection(id: 0, objects: configItems),
                ObjectsSection(id: 1, objects: networkItems)
            ]
            
        } else {
            
            sections = [ObjectsSection(id: 0, objects: [wifiItem])]
        }
        
        adapter.update(with: sections, animated: true)
    }
    
    // MARK: Public methods
    
    @objc func toggleWifi(_ wifiSwitch: UISwitch) {
        
        isWifiEnabled = wifiSwitch.isOn
        
        updateUI()
    }
}

// MARK: TableAdapterDataSource

extension WiFiViewController: TableAdapterDataSource {
    
    func tableAdapter(_ adapter: TableAdapter, cellIdentifierFor object: Any) -> String? {
        
        switch object {
            
        case is String:
            return wifiSwitchCellIdentifier
            
        case is Network:
            return networkCellIdentifier
            
        default:
            assertionFailure("Undefind cell identifier for \(object)")
            
            return nil
        }
        
    }
}

// MARK: TableAdapterDelegate

extension WiFiViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable) {
        
        guard let net = object as? Network else { return }
        
        currentNetwork = net
        
        updateUI()
    }
}

// MARK: NetworkCell

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
    
    func setup(with object: Network) {
        
        textLabel?.text = object.name
    }
}

// MARK: WiFiSwitchCell

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
    
    func setup(with object: String, sender: WiFiViewController) {
        
        textLabel?.text = object
        
        guard let wifiSwitch = accessoryView as? UISwitch else { return }
        
        wifiSwitch.isOn = sender.isWifiEnabled
        
        wifiSwitch.addTarget(
            sender,
            action: #selector(WiFiViewController.toggleWifi(_:)),
            for: .touchUpInside
        )
    }
}
