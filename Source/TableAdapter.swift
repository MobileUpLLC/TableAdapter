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
    
    private var groups: [Group] = []
    
    var objects: [AnyEquatable] {
        
        return dataSource?.objects(for: self) ?? []
    }
    
    // MARK: Public properties
    
    public weak var dataSource: TableAdapterDataSource?
    
    public weak var sectionsSource: TableSectionsSource?
    
    public weak var delegate: TableAdapterDelegate?
    
    public var headerIdentifier = "Header" {
        
        didSet { assert(headerIdentifier.isEmpty == false, "Header reuse identifier must not be empty string") }
    }
    
    public var footerIdentifier = "Footer" {
        
        didSet { assert(headerIdentifier.isEmpty == false, "Footer reuse identifier must not be empty string") }
    }
    
    // MARK: Private methods
    
    private func dequeConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdetifier(for: indexPath), for: indexPath)
        
        if let cell = cell as? AnyConfigurableCell {
            
            let object = getObject(for: indexPath)
            
            cell.anySetup(with: object)
        }
        
        return cell
    }
    
    private func dequeConfiguredHeaderFooterView(withIdentifier id: String, object: Any?) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id)
        
        if let view = view as? AnyConfigurableCell, let object = object {
            
            view.anySetup(with: object)
        }
        
        return view
    }
    
    private func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        let object = getObject(for: indexPath)
        
        return dataSource?.tableAdapter(self, cellIdentifierFor: object) ?? "Cell"
    }
    
    private func getObject(for indexPath: IndexPath) -> AnyEquatable {
        
        return groups[indexPath.section].rowObjects[indexPath.row]
    }
    
    private func groupObjects() {
        
        for object in objects {
            
            let header = sectionsSource?.tableAdapter(self, headerObjectFor: object)
            let footer = sectionsSource?.tableAdapter(self, footerObjectFor: object)
            
            if
                groups.isEmpty == false
                && compare(lhs: groups.last?.header, rhs: header)
                && compare(lhs: groups.last?.footer, rhs: footer)
            {
                
                groups[groups.endIndex - 1].rowObjects.append(object)
                
            } else {
                
                let newGroup = Group(header: header, footer: footer, rowObjects: [object])
                groups.append(newGroup)
            }
        }
    }
    
    // nil nil -> equal
    // any nil -> not equal
    // nil any -> not euqal
    // any any -> check
    private func compare(lhs: AnyEquatable?, rhs: AnyEquatable?) -> Bool {
        
        if lhs == nil && rhs == nil {
            
            return true
            
        } else if lhs != nil && rhs == nil {
            
            return false
            
        } else if lhs == nil && rhs != nil {
            
            return false
            
        } else {
            
            return lhs!.equal(any: rhs!)
            
        }
    }
    
    // MARK: Public methods
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func update(animated: Bool = true) {
        
        groupObjects()
        
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension TableAdapter: UITableViewDataSource {
    
    // MARK: Data setup
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return groups.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups[section].rowObjects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: HeaderFooter setup
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return groups[section].header as? String
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return groups[section].footer as? String
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return dequeConfiguredHeaderFooterView(withIdentifier: headerIdentifier, object: groups[section].header)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return dequeConfiguredHeaderFooterView(withIdentifier: footerIdentifier, object: groups[section].footer)
    }
}

// MARK: UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.tableAdapter(self, didSelect: getObject(for: indexPath))
    }
}
