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
    
    private lazy var adapter = ConfigCellTableAdapter<Float, Int, String>(tableView: tableView)
    
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
        
        tableView.frame = view.bounds
        
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height

        tableView.rowHeight = (tableView.frame.size.height - navBarHeight - statusBarHeight) / CGFloat(itemsCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update(items: sorter.currentItems, animated: false)
    }
    
    // MARK: Private methods
    
    private func update(items: [Float], animated: Bool) {
        
        let section = Section(id: 0, objects: items, header: "")
        
        adapter.update(with: [section], animated: animated)
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.register(ColorCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
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

// MARK: ColorCell

class ColorCell: UITableViewCell, Configurable {
    
    func setup(with object: Float) {
        
        backgroundColor = UIColor(hue: CGFloat(object), saturation: 1.0, brightness: 1.0, alpha: 1.0)
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
