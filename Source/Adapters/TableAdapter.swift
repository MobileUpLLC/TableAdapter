//
//  SupplementaryTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

open class TableAdapter<Item: Hashable, SectionId: Hashable>:
    BaseTableAdapter<Item, SectionId>, UITableViewDelegate {
    
    // MARK: Types
    
    public typealias CellDidSelectHandler = (UITableView, IndexPath, Item) -> Void
    
    // MARK: Public properties
    
    public var cellDidSelectHandler: CellDidSelectHandler?
    
    public var defaultHeaderIdentifier = "Header"
    public var defaultFooterIdentifier = "Footer"
    
    // MARK: Private methods
    
    private func dequeueConfiguredHeaderFooterView(
        withIdentifier id: String,
        configItem: Any?
    ) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) else {
            
            return nil
        }
        
        if let item = configItem {
            
            setupConfigurableView(view, with: item)
        }
        
        return view
    }
        
    private func getHeaderIdentifier(for section: Int) -> String {
        
        return sections[section].headerIdentifier ?? defaultHeaderIdentifier
    }

    private func getFooterIdentifier(for section: Int) -> String {
        
        return sections[section].footerIdentifier ?? defaultFooterIdentifier
    }
    
    // MARK: Public methods
    
    public init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil,
        cellDidSelectHandler: CellDidSelectHandler? = nil
    ) {
        super.init(
            tableView: tableView,
            sender: sender,
            cellIdentifierProvider: cellIdentifierProvider
        )
        
        self.cellDidSelectHandler = cellDidSelectHandler
        
        tableView.delegate = self
    }
    
    // MARK: UITableViewDelegate
    
    open func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        return dequeueConfiguredHeaderFooterView(
            withIdentifier: getHeaderIdentifier(for: section),
            configItem: sections[section].header
        )
    }

    open func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {

        return dequeueConfiguredHeaderFooterView(
            withIdentifier: getFooterIdentifier(for: section),
            configItem: sections[section].footer
        )
    }
    
    open func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        if let handler = cellDidSelectHandler {
            
            let item = getItem(for: indexPath)
            
            handler(tableView, indexPath, item)
        }
    }
}
