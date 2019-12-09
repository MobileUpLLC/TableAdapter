//
//  MixedObjectsViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 06.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class MixedObjectsViewController: UIViewController {
    
    // MARK: Privete properties
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    let items: [AnyEquatable] = [
        1, 2, 3,
        "aaa", "bbb", "ccc",
        true, false,
        1.1, 2.2, 3.3
    ]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.register(MyCell.self, forCellReuseIdentifier: "Cell")
        
        adapter.sectionsSource = self
        adapter.update(with: items)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

// MARK: TableSectionsSource

extension MixedObjectsViewController: TableSectionsSource {

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
}
