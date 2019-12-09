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
    
    private let items: [AnyEquatable] = [
        1, 2, 3,
        "aaa", "bbb", "ccc",
        true, false,
        1.1, 2.2, 3.3
    ]
    
    let segments: [String: Any.Type?] = [
        "Int": Int.self,
        "String": String.self,
        "Bool": Bool.self,
        "Any": nil
    ]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        
        view.addSubview(tableView)
        tableView.register(MyCell.self, forCellReuseIdentifier: "Cell")
        
        adapter.sectionsSource = self
        adapter.update(with: items)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupSegmentedControl() {
        
        let control = UISegmentedControl(items: segments.keys.sorted())
        control.addTarget(
            self,
            action: #selector(MixedObjectsViewController.segmentedControlValueChanged(_:)),
            for: .valueChanged
        )
        
        navigationItem.titleView = control
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        let selectedTypeName = segments.keys.sorted()[sender.selectedSegmentIndex]
        
        var newItems: [AnyEquatable]
        
        if let selectedType = segments[selectedTypeName], selectedType != nil {
            
            newItems = items.filter { type(of: $0) == selectedType }
            
        } else {
            
            newItems = items
        }
        
        adapter.update(with: newItems, animated: true)
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
