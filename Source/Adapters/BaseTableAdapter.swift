//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

open class BaseTableAdapter<Item: Hashable, SectionId: Hashable, Header: Any>: NSObject, UITableViewDataSource {
    
    // MARK: Types
    
    public typealias CellProvider = (UITableView, IndexPath, Item) -> UITableViewCell

    public typealias CellReuseIdentifierProvider = (IndexPath, Item) -> String?
    
    public typealias SecionType = Section<Item, SectionId, Header>
        
    // MARK: Public properties

    public let tableView: UITableView

    public private(set) var sections: [SecionType] = []

    public var cellProvider: CellProvider?

    public var cellIdentifierProvider: CellReuseIdentifierProvider?

    public var animationType: UITableView.RowAnimation = .fade

    public weak var sender: AnyObject?

    public var defaultCellIdentifier = "Cell"
    
    // MARK: Private methods
    
    private func reloadTable(with newSections: [SecionType]) {
        
        sections = newSections
        
        tableView.reloadData()
    }
    
    private func updateTable(with newSections: [SecionType]) {
        
        do {
            
            let diff = try SectionedDiffUtil.calculateSectionDiff(
                from: sections,
                to: newSections
            )

            updateTable(with: diff)

        } catch {
            
            print("Animated table update failed. Error: \(error)")

            reloadTable(with: newSections)
        }
    }

    private func updateTable(with diff: Diff<Item, SectionId, Header>) {

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
    
    public init(tableView: UITableView, cellProvider: CellProvider?) {
        
        self.tableView = tableView
        
        self.cellProvider = cellProvider
        
        super.init()
        
        tableView.dataSource = self
    }

    public init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {

        self.tableView = tableView

        super.init()

        self.cellProvider = { (table, indexPath, item) in

            return self.dequeueConfiguredCell(for: item, at: indexPath)
        }

        self.sender = sender

        self.cellIdentifierProvider = cellIdentifierProvider

        tableView.dataSource = self
    }

    public func setupConfigurableView(_ view: UIView, with object: Any) {

        if let view = view as? AnySenderConfigurable {

            view.anySetup(with: object, sender: sender)

        } else if let view = view as? AnyConfigurable {

            view.anySetup(with: object)
        }
    }

    open func update(with sections: [SecionType], animated: Bool = true) {
        
        if animated {
            
            updateTable(with: sections)
        
        } else {
            
            reloadTable(with: sections)
        }
    }
    
    public func getItem(for indexPath: IndexPath) -> Item {
        
        return sections[indexPath.section].items[indexPath.row]
    }
    
    // MARK: UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    open func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return sections[section].items.count
    }
    
    open func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let provider = cellProvider else {
            
            assertionFailure("CellProvider not found")
            
            return UITableViewCell()
        }
        
        let item = getItem(for: indexPath)
        
        return provider(tableView, indexPath, item)
    }
    
    open func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {

        return sections[section].header as? String
    }

    open func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {

        return sections[section].footer as? String
    }
}
