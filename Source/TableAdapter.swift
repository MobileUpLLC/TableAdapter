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
    
    private var sections: [Section] = []
    
    // MARK: Public properties
    
    public weak var sender: AnyObject?
    
    public weak var dataSource: TableAdapterDataSource?
    
    public weak var delegate: TableAdapterDelegate?
    
    public var defaultHeaderIdentifier = "Header" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Header reuse identifier must not be empty string") }
    }
    
    public var defaultFooterIdentifier = "Footer" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Footer reuse identifier must not be empty string") }
    }
    
    public var defaultCellIdentifier = "Cell" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Cell reuse identifier must not be empty string") }
    }
    
    public var currentSections: [Section] {
        
        return sections
    }
    
    public var animationType: UITableView.RowAnimation = .fade
    
    // MARK: Private methods
    
    private func dequeueConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdetifier(for: indexPath), for: indexPath)
        
        setup(cell, with: getObject(for: indexPath))
        
        return cell
    }
    
    private func dequeueConfiguredHeaderFooterView(withIdentifier id: String, object: Any?) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) else {
            
            return nil
        }
        
        if let object = object {
            
            setup(view, with: object)
        }
        
        return view
    }
    
    private func setup(_ view: UIView, with object: Any) {
        
        if let view = view as? AnySenderConfigurable {
            
            view.anySetup(with: object, sender: getSender())
            
        } else if let view = view as? AnyConfigurable {
            
            view.anySetup(with: object)
        }
    }
    
    private func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        return dataSource?.tableAdapter(self, cellIdentifierFor: getObject(for: indexPath)) ?? defaultCellIdentifier
    }
    
    private func getHeaderIdentifier(for section: Int) -> String {
        
        return dataSource?.tableAdapter(self, headerIdentifierFor: section) ?? defaultHeaderIdentifier
    }
    
    private func getFooterIdentifier(for section: Int) -> String {
        
        return dataSource?.tableAdapter(self, footerIdentifierFor: section) ?? defaultHeaderIdentifier
    }
    
    private func getObject(for indexPath: IndexPath) -> AnyEquatable {
        
        return sections[indexPath.section].objects[indexPath.row]
    }
    
    private func makeSections(from objects: [AnyEquatable]) -> [Section] {
        
        var result: [DefaultSection] = []
        
        for object in objects {
            
            let header = dataSource?.tableAdapter(self, headerObjectFor: object)
            let footer = dataSource?.tableAdapter(self, footerObjectFor: object)
            
            let newSection = DefaultSection(objects: [object], headerObject: header, footerObject: footer)
            
            if let lastSection = result.last, lastSection.equal(any: newSection) {
                
                result[result.endIndex - 1].objects.append(object)
                
            } else {
                
                result.append(newSection)
            }
        }
        
        return result
    }
    
    private func getSender() -> AnyObject {
        
        return sender ?? self
    }
    
    private func updateTable(with newSections: [Section]) {
        
        sections = newSections
        
        tableView.reloadData()
    }
    
    private func updateTableAnimated(with newSections: [Section]) {
            
        let oldSection = sections
        
        sections = newSections
        
        do {
            
            let diff = try DiffUtil.calculateSectionsDiff(from: oldSection, to: newSections)
            
            updateTableView(with: diff)
            
        } catch DiffError.duplicates {
            
            print("Duplicates found during updating. Updates will be will be performed without animation")
            
            tableView.reloadData()
            
        } catch DiffError.moveSection {
            
            print("Moving sections is not dupported for now. Updates will be will be performed without animation")
            
            tableView.reloadData()
            
        } catch {
            
            tableView.reloadData()
        }
    }
    
    private func updateTableView(with diff: Diff) {
        
        tableView.beginUpdates()
        performBatchUpdates(with: diff)
        tableView.endUpdates()
    }
    
    private func performBatchUpdates(with diff: Diff) {
        
        tableView.insertSections(diff.sections.inserts, with: animationType)
        tableView.deleteSections(diff.sections.deletes, with: animationType)
        
        tableView.deleteRows(at: diff.rows.deletes, with: animationType)
        tableView.insertRows(at: diff.rows.inserts, with: animationType)
        diff.rows.moves.forEach { tableView.moveRow(at: $0.from, to: $0.to) }
    }
    
    // MARK: Public methods
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public convenience init(tableView: UITableView, sender: AnyObject?) {
        
        self.init(tableView: tableView)
        
        self.sender = sender
    }
    
    public func update(with objects: [AnyEquatable], animated: Bool = true) {
        
        let newGroups = makeSections(from: objects)
        
        update(with: newGroups, animated: animated)
    }
    
    public func update(with sections: [Section], animated: Bool = true) {
        
        if animated {
            
            updateTableAnimated(with: sections)
        
        } else {
            
            updateTable(with: sections)
        }
    }
    
    public func reserveCell(with id: String, at indexPath: IndexPath) {
        
        assertionFailure("Not implemented yet")
    }
}

// MARK: UITableViewDataSource

extension TableAdapter: UITableViewDataSource {
    
    // MARK: Data setup
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].objects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: HeaderFooter setup
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section].header as? String
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return sections[section].footer as? String
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(
            
            withIdentifier: getHeaderIdentifier(for: section),
            object: sections[section].header
        )
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(
            
            withIdentifier: getFooterIdentifier(for: section),
            object: sections[section].footer
        )
    }
}

// MARK: UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.tableAdapter(self, didSelect: getObject(for: indexPath))
    }
}
