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
    
    private lazy var adapter = TableAdapter(tableView: tableView)
    
    private var filter: String?
    
    private lazy var words: [String] = {
        
        let str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        var unique = Set<String>()
        var words = [String]()
        
        let range = str.startIndex ..< str.endIndex
        str.enumerateSubstrings(in: range, options: .byWords) { (substring, _, _, _) in
            guard let substring = substring else { return }
            if !unique.contains(substring) {
                unique.insert(substring)
                words.append(substring)
            }
        }
        
        return words
    }()
    
    // MARK: Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        
        adapter.update(with: words, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.isActive = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filter = searchController.searchBar.text
        
        guard let filter = filter, filter.isEmpty == false else {
            
            return adapter.update(with: words, animated: true)
        }
        
        let akk = words.filter { $0.lowercased().contains(filter.lowercased()) }
        
        adapter.update(with: akk, animated: true)
    }
}

class MyCell: UITableViewCell, Configurable {
    
    public func setup(with object: Any) {
        
        textLabel?.text = "\(object)"
    }
}
