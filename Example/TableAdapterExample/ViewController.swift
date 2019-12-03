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
        
        adapter.dataSource = self
        adapter.delegate = self
        adapter.sectionsSource = self
        
        adapter.update()
    }
}

// MARK: TableAdapterDataSource

extension ViewController: TableAdapterDataSource {

    func objects(for tableAdapter: TableAdapter) -> [AnyEquatable] {
        
        var items: [AnyEquatable] = ["1", "2", "3", "4", "5"]
        
        items += [true, true, false]
        
        items += ["aaa", "bbb"]
        
        items += [123, 456, 789]
        
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
            
        default:
            return "Any"
        }
    }
    
    func tableAdapter(_ adapter: TableAdapter, footerObjectFor object: AnyEquatable) -> AnyEquatable? {
        
        switch object {
            
        case is String:
            return "Strings End"
            
        case is Int:
            return "Ints End"
            
        default:
            return "Any End"
        }
    }
}

// MARK: TableAdapterDelegate

extension ViewController: TableAdapterDelegate {
    
    func tableAdapter(_ adapter: TableAdapter, didSelect object: Any) {
        
        print(object)
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
