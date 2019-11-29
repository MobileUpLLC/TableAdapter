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
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        adapter.dataSource = self
    }
}

// MARK: TableAdapterDataSource

extension ViewController: TableAdapterDataSource {

    func objects(for tableAdapter: TableAdapter) -> [Any] {
        
        return ["1", "2", "3"]
    }
}

// MARK: Cell

class Cell: UITableViewCell {

    @IBOutlet private weak var mainLabel: UILabel!
}

extension Cell: ConfigurableCell {
    
    func setup(with object: String) {
        
        mainLabel.text = object
    }
}
