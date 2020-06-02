//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

/// BaseTableAdapter sets table view data source to itself.
/// Inherit adapter in order to extend functionality or handle other table view data source methods.
open class BaseTableAdapter<Item: Hashable, SectionId: Hashable>: NSObject, UITableViewDataSource {
    
    // MARK: Types
    
    public typealias CellProvider = (UITableView, IndexPath, Item) -> UITableViewCell

    public typealias CellReuseIdentifierProvider = (IndexPath, Item) -> String?
    
    public typealias SecionType = Section<Item, SectionId>
        
    // MARK: Public properties

    /// Current table.
    public let tableView: UITableView

    /// Current table sections.
    public private(set) var sections: [SecionType] = []

    /// Returns table view cell for item at index path.
    public var cellProvider: CellProvider?

    /// Returns cell reuse identifier for item at index path.
    public var cellIdentifierProvider: CellReuseIdentifierProvider?

    /// Animation type for sections and rows update.
    public var animationType: UITableView.RowAnimation = .fade

    /// Object to be sent in reusable cell, header or footer in case of adopting SenderConfigurable protocol.
    public weak var sender: AnyObject?

    /// Default cell reuse identifier in case of absence CellReuseIdentifierProvider.
    public var defaultCellIdentifier = "Cell"
    
    // MARK: Private methods
    
    private func reloadTable(with newSections: [SecionType]) {
        
        sections = newSections
        
        tableView.reloadData()
    }
    
    private func updateTable(with newSections: [SecionType]) {
        
        do {
            
            let diff = try SectionedDiffUtil.calculateSectionDiff(
                from : sections,
                to   : newSections
            )

            updateTable(with: diff)

        } catch {

            let msg = """
            Animated table update failed.
            Error: \(error)
            Please report this bug to developer.
            """
            
            print(msg)

            reloadTable(with: newSections)
        }
    }

    private func updateTable(with diff: Diff<Item, SectionId>) {

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
        for item     : Item,
        at indexPath : IndexPath
    ) -> UITableViewCell {

        let cellIdentifier = getCellIdetifier(for: item, at: indexPath)

        let cell = tableView.dequeueReusableCell(
            withIdentifier : cellIdentifier,
            for            : indexPath
        )

        setupConfigurableView(cell, with: item)

        return cell
    }

    private func getCellIdetifier(for item: Item, at indexPath: IndexPath) -> String {

        return cellIdentifierProvider?(indexPath, item) ?? defaultCellIdentifier
    }
    
    // MARK: Public methods

    /// Initialize adapter for table view with cell provider.
    /// - Parameters:
    ///   - tableView: Current table view.
    ///   - cellProvider: Returns UITableViewCell for Item at IndexPath.
    public init(tableView: UITableView, cellProvider: CellProvider?) {

        self.tableView = tableView
        
        self.cellProvider = cellProvider
        
        super.init()
        
        tableView.dataSource = self
    }

    /// Initialize adapter for table view with sender and cell reuse identifier provider.
    /// - Parameters:
    ///   - tableView: Current table view.
    ///   - sender: Object that will be send to cell, header or footer if SenderConfigurable protocol adopted.
    ///   - cellIdentifierProvider: Returns cell reuse identifier for Item at IndexPath.
    public init(
        tableView              : UITableView,
        sender                 : AnyObject?                    = nil,
        cellIdentifierProvider : CellReuseIdentifierProvider?  = nil
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

    /// Update current table view state with new sections.
    /// - Parameters:
    ///   - sections: New sections.
    ///   - animated: If true - performs update with animations based on auto diff.
    open func update(with sections: [SecionType], animated: Bool = true) {

        if animated {

            updateTable(with: sections)

        } else {

            reloadTable(with: sections)
        }
    }

    /// Setup reusable view with item.
    /// - Parameters:
    ///   - view: View that adopts either Configurable of SenderConfigurable protocol.
    ///   - item: Item.
    public func setupConfigurableView(_ view: UIView, with item: Any) {

        if let view = view as? AnySenderConfigurable {

            view.anySetup(with: item, sender: sender)

        } else if let view = view as? AnyConfigurable {

            view.anySetup(with: item)
        }
    }

    /// Get Item for IndexPath from current sections.
    /// - Parameter indexPath: Index path of item to return.
    /// - Returns: Item.
    public func getItem(for indexPath: IndexPath) -> Item {
        
        return sections[indexPath.section].items[indexPath.row]
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    open func tableView(
        _ tableView                   : UITableView,
        numberOfRowsInSection section : Int
    ) -> Int {
        
        return sections[section].items.count
    }
    
    open func tableView(
        _ tableView            : UITableView,
        cellForRowAt indexPath : IndexPath
    ) -> UITableViewCell {
        
        guard let provider = cellProvider else {

            let msg = """
            `CellProvider` closure not found. Provide it during initialization or later,
            but before updating adapter with sections.
            """

            assertionFailure(msg)

            return UITableViewCell()
        }

        let item = getItem(for: indexPath)
        
        return provider(tableView, indexPath, item)
    }
    
    open func tableView(
        _ tableView                     : UITableView,
        titleForHeaderInSection section : Int
    ) -> String? {

        return sections[section].header?.defaultItem
    }

    open func tableView(
        _ tableView                     : UITableView,
        titleForFooterInSection section : Int
    ) -> String? {

        return sections[section].footer?.defaultItem
    }

    open func tableView(
        _ tableView            : UITableView,
        canEditRowAt indexPath : IndexPath
    ) -> Bool {
        return true
    }

    open func tableView(
        _ tableView         : UITableView,
        commit editingStyle : UITableViewCell.EditingStyle,
        forRowAt indexPath  : IndexPath
    ) { }

    open func tableView(
        _ tableView            : UITableView,
        canMoveRowAt indexPath : IndexPath
    ) -> Bool {
        return true
    }

    open func tableView(
        _ tableView               : UITableView,
        moveRowAt sourceIndexPath : IndexPath,
        to destinationIndexPath   : IndexPath
    ) { }
}
