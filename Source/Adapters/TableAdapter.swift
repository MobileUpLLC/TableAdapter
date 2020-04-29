//
//  BaseTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

open class TableAdapter<Item: Hashable, SecitonId: Hashable, Header: Any>
    : BaseTableAdapter<Item, SecitonId, Header> {

    // MARK: Types
    
    public typealias CellReuseIdentifierProvider = (IndexPath, Item) -> String?
    
    // MARK: Public properties
    
    public var cellIdentifierProvider: CellReuseIdentifierProvider?
    
    public weak var sender: AnyObject?
    
    public var defaultCellIdentifier = "Cell" {
        
        didSet {
            assert(
                defaultCellIdentifier.isEmpty == false,
                "Cell reuse identifier must not be empty string"
            )
        }
    }
    
    // MARK: Private methods
    
    private func dequeueConfiguredCell(
        for item: Item,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cellIdentifier = getCellIdetifier(for: item, at: indexPath)
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        )
        
        setupConfigurableView(cell, with: item)
        
        return cell
    }
    
    private func getCellIdetifier(for item: Item, at indexPath: IndexPath) -> String {
        
        return cellIdentifierProvider?(indexPath, item) ?? defaultCellIdentifier
    }
    
    // MARK: Public methods
    
    public init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        super.init(tableView: tableView, cellProvider: nil)
        
        self.cellProvider = { (table, indexPath, item) in
            
            return self.dequeueConfiguredCell(for: item, at: indexPath)
        }
        
        self.sender = sender
        self.cellIdentifierProvider = cellIdentifierProvider
    }
    
    public func setupConfigurableView(_ view: UIView, with object: Any) {
        
        if let view = view as? AnySenderConfigurable {
            
            view.anySetup(with: object, sender: sender)
            
        } else if let view = view as? AnyConfigurable {
            
            view.anySetup(with: object)
        }
    }
}
