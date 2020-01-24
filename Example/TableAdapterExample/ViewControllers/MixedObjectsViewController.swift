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
    
    private lazy var adapter = DSTableAdapter<PrimitiveItem, Int>(tableView: tableView)
    
    private var items: [PrimitiveItem] = {
        
        let ints = [1, 2, 3].map { PrimitiveItem(type: .integer, value: $0) }
        let strings = ["foo", "bar"].map { PrimitiveItem(type: .string, value: $0) }
        let bools = [true, false].map { PrimitiveItem(type: .bool, value: $0) }
        let floats = [1.1, 2.2, 3.3].map { PrimitiveItem(type: .float, value: $0) }
        
        return ints + strings + bools + floats
    }()
    
    let segments: [String: PrimitiveItem.ItemType?] = [
        "Int": .integer,
        "String": .string,
        "Bool": .bool,
        "Any": nil
    ]
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSegmentedControl()

        update(items: items, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func update(items: [PrimitiveItem], animated: Bool) {
        
        let section = Section(id: 0, objects: items)
        
        adapter.update(with: [section], animated: animated)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(PrimitiveItemCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
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
        
        var newItems: [PrimitiveItem]
        
        if let selectedType = segments[selectedTypeName], selectedType != nil {
            
            newItems = items.filter { $0.type == selectedType }
            
        } else {
            
            newItems = items
        }
        
        update(items: newItems, animated: true)
    }
}

// MARK: PrimitiveItemCell

class PrimitiveItemCell: UITableViewCell, Configurable {
    
    public func setup(with object: PrimitiveItem) {
        
        textLabel?.text = "\(object.value)"
    }
}
