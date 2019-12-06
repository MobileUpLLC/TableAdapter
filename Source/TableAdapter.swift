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
    
    public var animationType: UITableView.RowAnimation = .fade
    
    // MARK: Private methods
    
    private func dequeueConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdetifier(for: indexPath), for: indexPath)
        
        if let cell = cell as? AnyConfigurable {
            
            cell.anySetup(with: getObject(for: indexPath))
        }
        
        return cell
    }
    
    private func dequeueConfiguredHeaderFooterView(withIdentifier id: String, object: Any?) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id)
        
        if let view = view as? AnyConfigurable, let object = object {
            
            view.anySetup(with: object)
        }
        
        return view
    }
    
    private func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        return dataSource?.tableAdapter(self, cellIdentifierFor: getObject(for: indexPath)) ?? "Cell"
    }
    
    private func getObject(for indexPath: IndexPath) -> AnyEquatable {
        
        return groups[indexPath.section].rowObjects[indexPath.row]
    }
    
    private func makeGroups(from objects: [AnyEquatable]) -> [Group] {
        
        var result: [Group] = []
        
        for object in objects {
            
            let header = sectionsSource?.tableAdapter(self, headerObjectFor: object)
            let footer = sectionsSource?.tableAdapter(self, footerObjectFor: object)
            
            let newGroup = Group(header: header, footer: footer, rowObjects: [object])
            
            if let lastGroup = result.last, lastGroup == newGroup {
                
                result[result.endIndex - 1].rowObjects.append(object)
                
            } else {
                
                result.append(newGroup)
            }
        }
        
        return result
    }
    
    private func updateTable() {
        
        groups = makeGroups(from: objects)
        
        tableView.reloadData()
    }
    
    private func updateTableAnimated() {

        let oldGroups = groups
        groups = makeGroups(from: objects)
        
        let diff = DiffUtil.calculateGroupsDiff(from: oldGroups, to: groups)
        
        print(diff)

        tableView.beginUpdates()

        tableView.insertSections(diff.sectionsDiff.inserts, with: animationType)
//        diff.sectionsDiff.moves.forEach { tableView.moveSection($0.from, toSection: $0.to) }
        tableView.deleteSections(diff.sectionsDiff.deletes, with: animationType)
//        tableView.reloadSections(diff.sectionsDiff.reloads, with: animationType)
        
        tableView.insertRows(at: diff.rowsDiff.inserts, with: animationType)
        diff.rowsDiff.moves.forEach { tableView.moveRow(at: $0.from, to: $0.to) }
        tableView.deleteRows(at: diff.rowsDiff.deletes, with: animationType)

        tableView.endUpdates()
    }
    
    // MARK: Public methods
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func update(animated: Bool = true) {
        
        if animated {
            
            updateTableAnimated()
        
        } else {
            
            updateTable()
        }
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
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: HeaderFooter setup
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return groups[section].header as? String
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return groups[section].footer as? String
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(withIdentifier: headerIdentifier, object: groups[section].header)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(withIdentifier: footerIdentifier, object: groups[section].footer)
    }
}

// MARK: UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.tableAdapter(self, didSelect: getObject(for: indexPath))
    }
}
