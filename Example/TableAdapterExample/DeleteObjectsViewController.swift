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
    
    private lazy var adapter = TableAdapter(tableView: tableView, sender: self)
    
    private let items: [AnyDifferentiable] = [
        "String",
        10001,
        100.1,
        true
    ]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupTableAdapter()
        
        adapter.update(with: items, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableAdapter() {
        
        adapter.delegate = self
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
    }
}

// MARK: TableAdapterDelegate

extension DeleteObjectsViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: AnyDifferentiable) {
        
        var sections = adapter.currentGroups
        
        sections[0].rowObjects.removeAll(where: { $0.id.equal(any: object.id) })
        
        adapter.update(with: sections)
    }
}
