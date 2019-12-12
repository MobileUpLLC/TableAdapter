//
//  SortViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 12.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class SortViewController: UIViewController {
    
    // MARK: Private properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var adapter = TableAdapter(tableView: tableView, sender: self)
    
    private let items: [Int] = [1, 2, 3]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        adapter.update(with: items, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
        
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
    }
}
