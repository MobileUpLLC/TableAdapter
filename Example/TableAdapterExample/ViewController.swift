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
    
    var items: [AnyEquatable] = [1, 2, 3, "aaa", "bbb", "ccc", 10.1, 11.1, 12.1]
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.animationType = .fade
        
        adapter.dataSource = self
        adapter.delegate = self
        adapter.sectionsSource = self

        adapter.update(animated: false)
    }
}

// MARK: TableAdapterDataSource

extension ViewController: TableAdapterDataSource {

    func objects(for tableAdapter: TableAdapter) -> [AnyEquatable] {
        
        return items
    }
}

// MARK: TableSectionsSource

extension ViewController: TableSectionsSource {

    func tableAdapter(_ adapter: TableAdapter, headerObjectFor object: AnyEquatable) -> AnyEquatable? {

        switch object {

        case is String:
            return "Strings"

        case is Int:
            return "Ints"
            
        case is Bool:
            return "Bools"

        default:
            return "Any"
        }
    }

//    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable? {
//
//        switch object {
//
//        case is String:
//            return "Strings End"
//
//        case is Int:
//            return "Ints End"
//
//        default:
//            return nil
//        }
//    }
}

// MARK: TableAdapterDelegate

extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: Any) {
        
        if items.count == 6 {
            
            items = [1, 2, 3, "aaa", "bbb", "ccc", 10.1, 11.1, 12.1]
            
        } else {
            
            items = [1, 3, 10.1, 13.1, 11.1, 12.1]
        }
        
        adapter.update(animated: true)
    }
}

// MARK: Cell

class Cell: UITableViewCell {

    @IBOutlet private weak var mainLabel: UILabel!
}

extension Cell: Configurable {
    
    func setup(with object: Any) {
        
        mainLabel.text = "\(object)"
    }
}
