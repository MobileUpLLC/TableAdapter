//
//  DeleteObjectsViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 11.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class DeleteObjectsViewController: UIViewController {
    
    // MARK: Private properties
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var adapter = ExtendedTableAdapter<Int, Int, String>(tableView: tableView)
    
    private let items: [Int] = [1, 1, 2, 3, 4, 5]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        adapter.cellDidSelectHandler = { (table, indexPath, item) in
            
            var sections = self.adapter.sections
            
            sections[indexPath.section].items.remove(at: indexPath.row)
            
            self.adapter.update(with: sections)
        }
        
        let section = Section(id: 1, items: items, header: "")
        
        adapter.update(with: [section], animated: false)
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
