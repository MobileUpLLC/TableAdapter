//
//  SupplementaryTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

open class SupplementaryTableAdapter<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>: ConfigCellTableAdapter<ItemType, SectionType, HeaderType>, UITableViewDelegate {
    
    // MARK: Types
    
    public typealias CellDidSelectedHandler = (UITableView, IndexPath, ItemType) -> Void
    
    // MARK: Private properties
    
    private weak var delegate: AnyTableAdapterDelegate?
    
    // MARK: Public properties
    
    public var defaultHeaderIdentifier = "Header" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Header reuse identifier must not be empty string") }
    }
    
    public var defaultFooterIdentifier = "Footer" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Footer reuse identifier must not be empty string") }
    }
    
    public var cellDidSelectedHandler: CellDidSelectedHandler?
    
    // MARK: Private methods
    
    private func dequeueConfiguredHeaderFooterView(withIdentifier id: String, object: Any?) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: id) else {
            
            return nil
        }
        
        if let object = object {
            
            setupConfigurableView(view, with: object)
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
    
    public override init(tableView: UITableView) {
        
        super.init(tableView: tableView)
        
        tableView.delegate = self
    }
    
    public convenience init<Delegate: TableAdapterDelegate, DataSource: TableAdapterDataSource>(
        tableView: UITableView,
        sender: AnyObject? = nil,
        dataSource: DataSource? = nil,
        delegate: Delegate? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        self.init(
            tableView: tableView,
            sender: sender,
            dataSource: dataSource,
            cellIdentifierProvider: cellIdentifierProvider
        )
        
        if tableView.delegate == nil {
            
            tableView.delegate = self
        }
        
        self.delegate = delegate
    }
    
    public convenience init<Delegate: TableAdapterDelegate>(
        tableView: UITableView,
        sender: AnyObject? = nil,
        delegate: Delegate? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        self.init(
            tableView: tableView,
            sender: sender,
            cellIdentifierProvider: cellIdentifierProvider
        )
        
        if tableView.delegate == nil {
            
            tableView.delegate = self
        }
        
        self.delegate = delegate
    }
    
    
    // MARK: UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return dequeueConfiguredHeaderFooterView(

            withIdentifier: getHeaderIdentifier(for: section),
            object: sections[section].header
        )
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return dequeueConfiguredHeaderFooterView(

            withIdentifier: getFooterIdentifier(for: section),
            object: sections[section].footer
        )
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = getItem(for: indexPath)
        
        if let handler = cellDidSelectedHandler {
            
            handler(tableView, indexPath, item)
            
        } else {
            
            delegate?.tableAdapter(self, didSelect: item)
        }
    }
}
