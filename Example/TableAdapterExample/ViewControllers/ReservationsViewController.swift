//
//  ReservationsViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 10.01.2020.
//  Copyright © 2020 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class ReservationsViewController: UIViewController {
    
    // MARK: Private properties
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private let bannerCellIdentifier = "BannerCellIdentifier"
    
    private var firstSections: [Section] {
        
        let intSection = ObjectsSection(
            id: 0,
            objects: [1, 2, 3, 5],
            header: "Ints begin",
            footer: "Ints end"
        )
        
        let stringSection = ObjectsSection(
            id: 1,
            objects: ["bbb", "aaa"],
            header: "Strings begin",
            footer: "Strings end"
        )
        
        let boolSection = ObjectsSection(
            id: 2,
            objects: [true, false],
            header: "Bools begin",
            footer: "Bools end"
        )
        
        return [intSection, stringSection, boolSection]
    }
    
    private var secondSections: [Section] {
        
        let intSection = ObjectsSection(
            id: 0,
            objects: [1, 3, 4],
            header: "Ints begin",
            footer: "Ints end"
        )
        
        let stringSection = ObjectsSection(
            id: 1,
            objects: ["aaa", "bbb", "ccc"],
            header: "Strings begin",
            footer: "Strings end"
        )
        
        return [stringSection, intSection]
    }
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        setupTableAdapter()
        
        adapter.update(with: firstSections)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableAdapter() {
        
        adapter.reserveStaticCell(withIdentifier: bannerCellIdentifier, row: 2, section: 0)
        adapter.reserveStaticCell(withIdentifier: bannerCellIdentifier, row: 2, section: 1)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
        tableView.register(BannerCell.self, forCellReuseIdentifier: bannerCellIdentifier)
    }
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: .plain,
            target: self,
            action: #selector(ReservationsViewController.updateSections)
        )
    }
    
    @objc private func updateSections() {
        
        if adapter.currentSections.count == 2 {
            
            adapter.update(with: firstSections)
            
        } else {
            
            adapter.update(with: secondSections)
        }
    }
}

// MARK: BannerCell

class BannerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
