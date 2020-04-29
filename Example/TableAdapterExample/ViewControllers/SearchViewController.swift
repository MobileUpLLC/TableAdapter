//
//  SearchViewController.swift
//  TableAdapterExample
//
//  Created by Nikolai Timonin on 06.12.2019.
//  Copyright © 2019 MobileUp LLC. All rights reserved.
//

import UIKit
import TableAdapter

class SearchViewController: UIViewController {
    
    // MARK: Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView()
    
    private lazy var adapter = ConfigCellTableAdapter<String, Int, String>(tableView: tableView)
    
    private lazy var seas: [String] = seasRaw.components(separatedBy: CharacterSet.newlines)
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        
        update(with: seas, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(AnyObjectCell.self, forCellReuseIdentifier: adapter.defaultCellIdentifier)
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
    }
    
    private func update(with items: [String], animated: Bool) {
        
        let section = Section<String, Int, String>(id: 0, items: items)
        
        adapter.update(with: [section], animated: animated)
    }
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, filter.isEmpty == false else {
            
            return update(with: seas, animated: true)
        }
        
        let filteredWords = seas.filter { $0.lowercased().contains(filter.lowercased()) }
        
        update(with: filteredWords, animated: true)
    }
}
