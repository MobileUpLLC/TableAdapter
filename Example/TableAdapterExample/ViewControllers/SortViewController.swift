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
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var adapter = TableAdapter(tableView: tableView, sender: self)
    
    private let sorter = SortUtil(items: [6, 5, 11, 8, 7, 12, 10, 9, 4, 3, 2, 1])
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavBar()
        
        adapter.update(with: sorter.currentItems, animated: false)
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
    
    private func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Run",
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
        
        adapter.update(with: sorter.currentItems, animated: true)
    }
    
    private func sort() {
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
            
            self.adapter.update(with: self.sorter.nextStepSorted())
            
            if self.sorter.isSorted {
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                timer.invalidate()
            }
        }
    }
}

// MARK: SortUtil

final class SortUtil<T: Comparable> {
    
    // MARK: Private properties
    
    private let originItems: [T]
    
    private var items: [T]
    private var currentIndex: Int
    
    // MARK: Public properties
    
    var currentItems: [T] {
        
        return items
    }
    
    var isSorted: Bool {
        
        return currentIndex >= items.count
    }
    
    // MARK: Public methods
    
    init(items: [T]) {
        
        self.items = items
        originItems = items
        currentIndex = 1
    }
    
    func refresh() {
        
        items = originItems
        currentIndex = 1
    }
    
    func nextStepSorted() -> [T] {
        
        let item = items[currentIndex]
        var index = currentIndex - 1
        
        while index >= 0 && item < items[index] {
            
            items[index + 1] = items[index]
            items[index] = item
            
            index -= 1
        }
        
        currentIndex += 1
        
        return items
    }
}
