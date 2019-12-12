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
            
            var nts = networks
            
            var configItems: [AnyDifferentiable] = ["wifi-config"]
            
            if let net = currentNetwork {
                
                configItems.append(net)
                
                nts.removeAll(where: { $0.equal(any: net) })
            }
            
            let config = DefaultSection(id: 0, objects: configItems)
            
            let network = DefaultSection(id: 1, objects: nts)
            
            sections = [config, network]
            
        } else {
            
            currentNetwork = nil
            
            let config = DefaultSection(id: 0, objects: ["wifi-config"])
            
            sections = [config]
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
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyDifferentiable) {
        
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
        
        textLabel?.text = "Wi-Fi"
        
        guard let wifiSwitch = accessoryView as? UISwitch else { return }
        
        wifiSwitch.isOn = sender.isWifiEnabled
        
        wifiSwitch.addTarget(
            sender,
            action: #selector(WiFiViewController.toggleWifi(_:)),
            for: .touchUpInside
        )
    }
}
