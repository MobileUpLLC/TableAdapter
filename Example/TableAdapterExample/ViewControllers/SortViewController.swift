//
//  SortViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 12.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class SortViewController: UIViewController {
    
    // MARK: Private properties
    
    private let tableView = UITableView()
    
    private lazy var adapter = TableAdapter<Float, Int>(tableView: tableView)
    
    private let itemsCount = 50
    
    private lazy var hues: [Float] = (0..<itemsCount).map { Float($0) / Float(itemsCount) }.shuffled()
    
    private lazy var sorter = SortUtil(items: hues)
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update(items: sorter.currentItems, animated: false)
    }
    
    // MARK: Private methods
    
    private func update(items: [Float], animated: Bool) {
        
        let section = Section(id: 0, items: items, header: "")
        
        adapter.update(with: [section], animated: animated)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.register(ColorCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
    }

    private func updateTableView() {
        
        tableView.frame = view.bounds

        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        tableView.rowHeight = (tableView.frame.size.height - navBarHeight - statusBarHeight) / CGFloat(itemsCount)
    }
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: #selector(SortViewController.runSort)
        )
    }
    
    @objc private func runSort() {
        
        refreshItems()
        
        sort()
    }
    
    private func refreshItems() {
        
        if sorter.isSorted {
            
            sorter.refresh()
        }
        
        update(items: sorter.currentItems, animated: true)
    }
    
    private func sort() {
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            
            self.update(items: self.sorter.nextStepSorted(), animated: true)
            
            if self.sorter.isSorted {
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                timer.invalidate()
            }
        }
    }
}
