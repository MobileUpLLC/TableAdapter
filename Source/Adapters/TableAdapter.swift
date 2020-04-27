//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

open class TableAdapter<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>: NSObject, UITableViewDataSource {
    
    // MARK: Types
    
    public typealias CellProvider = (UITableView, IndexPath, ItemType) -> UITableViewCell
    
    public typealias Sec = Section<ItemType, SectionType, HeaderType>
    
    // MARK: Private properties
    
    private(set) var sections: [Sec] = []
    
    private var cellProvider: CellProvider?
    
    // MARK: Public properties
    
    public let tableView: UITableView
    
    public var animationType: UITableView.RowAnimation = .fade
    
    open var currentSections: [Sec] {
        
        return sections
    }
    
    // MARK: Private methods
    
    private func updateTable(with newSections: [Sec]) {
        
        sections = newSections
        
        tableView.reloadData()
    }
    
    private func updateTableAnimated(with newSections: [Sec]) {
        
        do {

            let diff = try SectionedDiffUtil.calculateSectionDiff(from: sections, to: newSections)

            updateTableView(with: diff)

        } catch DiffError.duplicates {

            print("Duplicates found during updating. Updates will be will be performed without animation")

            updateTable(with: newSections)

        } catch {

            updateTable(with: newSections)
        }
    }
    
    private func updateTableView(with diff: Diff<ItemType, SectionType, HeaderType>) {

        sections = diff.intermediateData

        tableView.beginUpdates()
        tableView.insertSections(diff.sections.inserts, with: animationType)
        tableView.deleteSections(diff.sections.deletes, with: animationType)
        diff.sections.moves.forEach { tableView.moveSection($0.from, toSection: $0.to) }
        tableView.endUpdates()

        sections = diff.resultData

        tableView.beginUpdates()
        tableView.deleteRows(at: diff.rows.deletes, with: animationType)
        tableView.insertRows(at: diff.rows.inserts, with: animationType)
        diff.rows.moves.forEach { tableView.moveRow(at: $0.from, to: $0.to) }
        tableView.endUpdates()
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
            
            updateTableAnimated(with: sections)
        
        } else {
            
            updateTable(with: sections)
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
