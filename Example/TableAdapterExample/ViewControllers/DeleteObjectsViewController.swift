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
    
    private lazy var adapter = HeaderFooterTableAdapter<Int, Int>(tableView: tableView, delegate: self)
    
    private let items: [Int] = [1, 2, 3, 4, 5]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        let section = Section(id: 1, objects: items)
        
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

// MARK: TableAdapterDelegate

extension DeleteObjectsViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter<Int, Int>, didSelect object: Int) {
        
        var sections = adapter.currentSections
        
        sections[0].objects.removeAll(where: { $0 == object })
        
        adapter.update(with: sections)
    }
}
