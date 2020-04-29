//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

open class TableAdapter<
        ItemType: Hashable,
        SectionType: Hashable,
        HeaderType: Any
    >: NSObject, UITableViewDataSource {
    
    // MARK: Types
    
    public typealias CellProvider = (UITableView, IndexPath, ItemType) -> UITableViewCell
    
    public typealias Sec = Section<ItemType, SectionType, HeaderType>
        
    // MARK: Public properties
    
    public private(set) var sections: [Sec] = []
    
    public var cellProvider: CellProvider?
    
    public let tableView: UITableView
    
    public var animationType: UITableView.RowAnimation = .fade
    
    // MARK: Private methods
    
    private func reloadTable(with newSections: [Sec]) {
        
        sections = newSections
        
        tableView.reloadData()
    }
    
    private func updateTable(with newSections: [Sec]) {
        
        do {
            
            let diff = try SectionedDiffUtil.calculateSectionDiff(from: sections, to: newSections)

            updateTable(with: diff)

        } catch {
            
            print("Animated table update failed. Error: \(error)")

            updateTable(with: newSections)
        }
    }
    
    private func updateTable(with diff: Diff<ItemType, SectionType, HeaderType>) {
        
        tableView.makeBatchUpdates {
            
            sections = diff.intermediateData

            tableView.insertSections(diff.sections.inserts, with: animationType)
            tableView.deleteSections(diff.sections.deletes, with: animationType)
            diff.sections.moves.forEach { tableView.moveSection($0.from, toSection: $0.to) }
        }
        
        tableView.makeBatchUpdates {
            
            sections = diff.resultData

            tableView.deleteRows(at: diff.rows.deletes, with: animationType)
            tableView.insertRows(at: diff.rows.inserts, with: animationType)
            diff.rows.moves.forEach { tableView.moveRow(at: $0.from, to: $0.to) }
        }
    }
    
    // MARK: Public methods
    
    public convenience init(tableView: UITableView, cellProvider: @escaping CellProvider) {
        
        self.init(tableView: tableView)
        
        self.cellProvider = cellProvider
    }
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
    }

    open func update(with sections: [Sec], animated: Bool = true) {
        
        if animated {
            
            updateTable(with: sections)
        
        } else {
            
            reloadTable(with: sections)
        }
    }
    
    public func getItem(for indexPath: IndexPath) -> ItemType {
        
        return sections[indexPath.section].items[indexPath.row]
    }
    
    // MARK: UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = getItem(for: indexPath)
        
        return cellProvider?(tableView, indexPath, item) ?? UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section].header as? String
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return sections[section].footer as? String
    }
}
