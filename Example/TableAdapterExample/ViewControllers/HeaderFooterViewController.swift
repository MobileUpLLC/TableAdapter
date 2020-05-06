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
    
    private lazy var adapter = TableAdapter<PrimitiveItem, Int>(tableView: tableView)
    
    private var sections: [Section<PrimitiveItem, Int>] = {
        
        let ints = [1, 2, 3, 1, 1, 1].map { PrimitiveItem(type: .integer, value: $0) }
        let sectionInts = Section(id: 0, items: ints, header: "Ints begin", footer: "Ints end")
        
        let strings = ["foo", "bar"].map { PrimitiveItem(type: .string, value: $0) }
        let sectionStrings = Section(id: 1, items: strings, header: "Strings begin", footer: "Strings end")
        
        let bools = [true, false, false].map { PrimitiveItem(type: .bool, value: $0) }
        let sectionBools = Section(id: 2, items: bools, header: "Bools begin", footer: "Bools end")
        
        let floats = [1.1, 2.2, 3.3].map { PrimitiveItem(type: .float, value: $0) }
        let sectionFloats = Section(id: 3, items: floats, header: "Floats begin", footer: "Floats end")
        
        return [sectionInts, sectionStrings, sectionBools, sectionFloats]
    }()
    
    private var sections2: [Section<PrimitiveItem, Int>] = {
        
        let ints = [4, 1, 5, 2, 1, 6].map { PrimitiveItem(type: .integer, value: $0) }
        let sectionInts = Section(
            id: 0,
            items: ints,
            header: "Ints begin",
            footer: "Ints end",
            headerIdentifier: "Footer",
            footerIdentifier: "Header"
        )
        
        let strings = ["foo", "bar", "zoo", "bar"].map { PrimitiveItem(type: .string, value: $0) }
        let sectionStrings = Section(id: 1, items: strings, header: "Strings begin", footer: "Strings end")
        
        let floats = [2.2, 3.3, 4.4].map { PrimitiveItem(type: .float, value: $0) }
        let sectionFloats = Section(id: 3, items: floats, header: "Floats begin", footer: "Floats end")
        
        return [sectionFloats, sectionInts, sectionStrings]
    }()
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavBar()
        
        adapter.update(with: sections)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(PrimitiveItemCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
        
        tableView.register(
            UINib(nibName: "RedHeaderFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: adapter.defaultHeaderIdentifier
        )

        tableView.register(
            UINib(nibName: "BlueHeaderFooterView", bundle: nil),
            forHeaderFooterViewReuseIdentifier: adapter.defaultFooterIdentifier
        )
    }
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: .plain,
            target: self,
            action: #selector(HeaderFooterViewController.updateSections)
        )
    }
    
    @objc private func updateSections() {
        
        if adapter.sections.count == 3 {
            
            adapter.update(with: sections)
            
        } else {
            
            adapter.update(with: sections2)
        }
    }
}
