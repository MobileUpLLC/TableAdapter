//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

open class TableAdapter: NSObject {
    
    // MARK: Private properties
    
    private let tableView: UITableView
    
    // MARK: Public properties
    
    public weak var dataSource: TableAdapterDataSource?
    
    public weak var sectionsSource: TableSectionsSource?
    
    // MARK: Private methods
    
    private func getConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let cell = cell as? AnyConfigurableCell {
            
            let object = getObject(for: indexPath)
            
            cell.anySetup(with: object)
        }
        
        return cell
    }
    
    private func getObject(for indexPath: IndexPath) -> Any {
        
        return dataSource!.objects(for: self)[indexPath.row]
    }
    
    // MARK: Public methods
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
    }
    
    public func update(animated: Bool = true) {
        
    }
}

extension TableAdapter: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource?.objects(for: self).count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getConfiguredCell(forRowAt: indexPath)
    }
}
