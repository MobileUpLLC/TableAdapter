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
    
    // MARK: Private properties
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private let items: [AnyDifferentiable] = [
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
        
        setupTableView()
        setupSegmentedControl()
        
        adapter.update(with: items)
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
    
    private func setupSegmentedControl() {
        
        let control = UISegmentedControl(items: segments.keys.sorted())
        control.selectedSegmentIndex = 0
        control.addTarget(
            self,
            action: #selector(MixedObjectsViewController.segmentedControlValueChanged(_:)),
            for: .valueChanged
        )
        
        navigationItem.titleView = control
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        let selectedTypeName = segments.keys.sorted()[sender.selectedSegmentIndex]
        
        var newItems: [AnyDifferentiable]
        
        if let selectedType = segments[selectedTypeName], selectedType != nil {
            
            newItems = items.filter { type(of: $0) == selectedType }
            
        } else {
            
            newItems = items
        }
        
        adapter.update(with: newItems, animated: true)
    }
}

// MARK: AnyObjectCell

class AnyObjectCell: UITableViewCell, Configurable {
    
    public func setup(with object: Any) {
        
        textLabel?.text = "\(object)"
    }
}
