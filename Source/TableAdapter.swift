//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

public protocol TableSectionsSource: AnyObject {
    
    // MARK: Optional
    
    func tableAdapter(_ adapter: TableAdapter, sectionViewIdentifierFor object: Any) -> String
    
    func tableAdapter(_ adapter: TableAdapter, sectionObjectFor object: Any) -> Any
}

public extension TableSectionsSource {
    
    
}

open class TableAdapter {
    
    // MARK: Private properties
    
    private let tableView: UITableView?
    
    // MARK: Public properties
    
    public weak var dataSource: TableAdapterDataSource?
    
    public weak var sectionsSource: TableSectionsSource?
    
    // MARK: Private methods
    
    // MARK: Public methods
    
    public init(tableView: UITableView? = nil) {
        
        self.tableView = tableView
    }
    
    public func update(animated: Bool = true) {
        
    }
}
