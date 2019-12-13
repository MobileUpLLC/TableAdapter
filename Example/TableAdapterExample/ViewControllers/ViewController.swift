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
    
    private let items: [Example] = [
        
        Example(name: "Search", controller: SearchViewController.self),
        Example(name: "Mixed objects", controller: MixedObjectsViewController.self),
        Example(name: "Wi-Fi", controller: WiFiViewController.self),
        Example(name: "Delete objects", controller: DeleteObjectsViewController.self),
        Example(name: "HeaderFooter", controller: HeaderFooterViewController.self),
        Example(name: "Sort", controller: SortViewController.self)
    ]
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableAdapter()

        adapter.update(with: items, animated: false)
    }
    
    // MARK: Private methods
    
    private func setupTableAdapter() {
        
        adapter.delegate = self
    }
    
    private func open(_ example: Example) {
        
        let controller = example.controller.init()
        controller.title = example.name
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: TableAdapterDelegate

extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyEquatable) {
        
        guard let example = object as? Example else { return }
        
        open(example)
    }
}

// MARK: Cell

class Cell: UITableViewCell {

    @IBOutlet private weak var mainLabel: UILabel!
}

extension Cell: Configurable {

    func setup(with object: Example) {

        mainLabel.text = "\(object.name)"
    }
}
