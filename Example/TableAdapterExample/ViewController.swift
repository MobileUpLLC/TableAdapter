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

    // MARK: Private properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    enum Akk: String, AnyEquatable {
        case search = "Search"
        case filter = "Mixed objects"
    }
    
    var items: [Akk] = [
        .search,
        .filter
    ]
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.delegate = self

        adapter.update(with: items, animated: false)
    }
}

// MARK: TableAdapterDelegate

extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable) {
        
        guard let obj = object as? ViewController.Akk else { return }
        
        var viewController: UIViewController
        
        switch obj {

        case .search:
            viewController = SearchViewController()
            
        case .filter:
            viewController = MixedObjectsViewController()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Cell

class Cell: UITableViewCell {

    @IBOutlet private weak var mainLabel: UILabel!
}

extension Cell: Configurable {
    
    func setup(with object: ViewController.Akk) {
        
        mainLabel.text = "\(object.rawValue)"
    }
}
