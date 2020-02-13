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
    
    private lazy var adapter = SupplementaryTableAdapter<PrimitiveItem, Int, String>(tableView: tableView)
    
    private var sections: [Section<PrimitiveItem, Int, String>] = {
        
        let ints = [1, 2, 3].map { PrimitiveItem(type: .integer, value: $0) }
        let sectionInts = Section(id: 0, objects: ints, header: "Ints begin", footer: "Ints end")
        
        let strings = ["foo", "bar"].map { PrimitiveItem(type: .string, value: $0) }
        let sectionStrings = Section(id: 1, objects: strings, header: "Strings begin", footer: "Strings end")
        
        let bools = [true, false].map { PrimitiveItem(type: .bool, value: $0) }
        let sectionBools = Section(id: 2, objects: bools, header: "Bools begin", footer: "Bools end")
        
        let floats = [1.1, 2.2, 3.3].map { PrimitiveItem(type: .float, value: $0) }
        let sectionFloats = Section(id: 3, objects: floats, header: "Floats begin", footer: "Floats end")
        
        return [sectionInts, sectionStrings, sectionBools, sectionFloats]
    }()
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
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
}
