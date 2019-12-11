//
//  ViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class ViewController: UIViewController {
    
    // MARK: Types
    
    enum Example: String, AnyDifferentiable {
        
        var id: AnyEquatable { return rawValue }
        
        case search = "Search"
        case filter = "Mixed objects"
        case wifi = "Wi-Fi"
    }

    // MARK: Private properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private let items: [Example] = [
        .search,
        .filter,
        .wifi
    ]
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.delegate = self
        adapter.sender = self

        adapter.update(with: items, animated: false)
    }
    
    // MARK: Private methods
    
    private func open(_ viewController: UIViewController) {
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: TableAdapterDelegate

extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyDifferentiable) {
        
        guard let selectedObject = object as? ViewController.Example else { return }
        
        switch selectedObject {

        case .search:
            open(SearchViewController())
            
        case .filter:
            open(MixedObjectsViewController())
            
        case .wifi:
            open(WiFiViewController())
        }
    }
}

// MARK: Cell

class Cell: UITableViewCell {

    @IBOutlet private weak var mainLabel: UILabel!
}

extension Cell: Configurable {

    func setup(with object: ViewController.Example) {

        mainLabel.text = "\(object.rawValue)"
    }
}
