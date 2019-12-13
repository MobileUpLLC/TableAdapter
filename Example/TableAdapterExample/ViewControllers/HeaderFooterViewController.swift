//
//  HeaderFooterViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 12.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class HeaderFooterViewController: UIViewController {

    // MARK: Private properties
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private let items: [AnyEquatable] = [
        1, 2, 3,
        "aaa", "bbb", "ccc",
        true, false,
        1.1, 2.2, 3.3
    ]
    
    private let redHeaderFooterIdentifier = "RedHeaderFooterIdentifier"
    private let blueHeaderFooterIdentifier = "BlueHeaderFooterIdentifier"
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTableAdapter()
        
        adapter.update(with: items)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableAdapter() {
        
        adapter.dataSource = self
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
        
        tableView.register(
            UINib(nibName: "TitleHeaderFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: redHeaderFooterIdentifier
        )

        tableView.register(
            UINib(nibName: "RightTitleHeaderFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: blueHeaderFooterIdentifier
        )
    }
}

// MARK: TableSectionsSource

extension HeaderFooterViewController: TableAdapterDataSource {

    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyEquatable) -> AnyEquatable? {

        switch object {

        case is String:
            return "Strings start"

        case is Int:
            return "Ints start"
            
        case is Bool:
            return "Bools start"

        default:
            return "Any start"
        }
    }

    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable? {

        switch object {

        case is String:
            return "Strings end"

        case is Int:
            return "Ints end"
            
        case is Bool:
            return "Bools end"

        default:
            return "Any end"
        }
    }
    
    func tableAdapter(_ adapter: TableAdapter, headerIdentifierFor section: Int) -> String? {
        
        return (section % 2 == 0) ? redHeaderFooterIdentifier : blueHeaderFooterIdentifier
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerIdentifierFor section: Int) -> String? {
        
        return (section % 2 == 0) ? redHeaderFooterIdentifier : blueHeaderFooterIdentifier
    }
}
