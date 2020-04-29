//
//  BaseTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

open class ConfigCellTableAdapter<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>: TableAdapter<ItemType, SectionType, HeaderType> {

    // MARK: Types
    
    public typealias CellReuseIdentifierProvider = (IndexPath, ItemType) -> String?
    
    // MARK: Public properties
    
    public var cellIdentifierProvider: CellReuseIdentifierProvider?
    
    public weak var sender: AnyObject?
    
    public var defaultCellIdentifier = "Cell" {
        
        didSet { assert(defaultCellIdentifier.isEmpty == false, "Cell reuse identifier must not be empty string") }
    }

    // MARK: Override methods
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: Private methods
    
    private func dequeueConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellObject = getItem(for: indexPath)
        
        let cellIdentifier = getCellIdetifier(for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        setupConfigurableView(cell, with: cellObject)
        
        return cell
    }
    
    public func setupConfigurableView(_ view: UIView, with object: Any) {
        
        if let view = view as? AnySenderConfigurable {
            
            view.anySetup(with: object, sender: sender)
            
        } else if let view = view as? AnyConfigurable {
            
            view.anySetup(with: object)
        }
    }
    
    // MARK: Public methods
    
    public convenience init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        self.init(tableView: tableView)
        
        self.sender = sender
        
        self.cellIdentifierProvider = cellIdentifierProvider
    }
    
    open func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        let item = getItem(for: indexPath)
        
        if let cellId = cellIdentifierProvider?(indexPath, item) {
        
            return cellId
        
        } else {
            
            return defaultCellIdentifier
        }
    }
}
