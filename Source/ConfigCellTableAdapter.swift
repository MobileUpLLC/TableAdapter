//
//  BaseTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

open class ConfigCellTableAdapter<ItemType: Hashable, SectionType: Hashable, HeaderType: Any>: TableAdapter<ItemType, SectionType, HeaderType> {

    // MARK: Types
    
    public typealias CellReuseIdentifierProvider = (IndexPath, ItemType) -> String?
    
    // MARK: Private properties
    
    private weak var dataSource: AnyTableAdapterDataSource?
    
    // MARK: Public properties
    
    public var cellIdentifierProvider: CellReuseIdentifierProvider?
    
    public weak var sender: AnyObject?
    
    public var defaultCellIdentifier = "Cell" {
        
        didSet { assert(defaultCellIdentifier.isEmpty == false, "Cell reuse identifier must not be empty string") }
    }

    // MARK: Override methods
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: Private methods
    
    private func dequeueConfiguredCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellObject = getItem(for: indexPath)
        
        let cellIdentifier = getCellIdetifier(for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        setupConfigurableView(cell, with: cellObject)
        
        return cell
    }
    
    public func setupConfigurableView(_ view: UIView, with object: Any) {
        
        if let view = view as? AnySenderConfigurable {
            
            view.anySetup(with: object, sender: sender)
            
        } else if let view = view as? AnyConfigurable {
            
            view.anySetup(with: object)
        }
    }
    
    // MARK: Public methods
    
    public convenience init<DataSource: TableAdapterDataSource>(
        tableView: UITableView,
        sender: AnyObject? = nil,
        dataSource: DataSource? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        self.init(tableView: tableView, sender: sender, cellIdentifierProvider: cellIdentifierProvider)
        
        self.dataSource = dataSource
    }
    
    public convenience init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellReuseIdentifierProvider? = nil
    ) {
        self.init(tableView: tableView)
        
        self.sender = sender
        
        self.cellIdentifierProvider = cellIdentifierProvider
    }
    
    open func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        let item = getItem(for: indexPath)
        
        if let cellId = cellIdentifierProvider?(indexPath, item) {
        
            return cellId
        
        } else if let cellId = dataSource?.tableAdapter(self, cellIdentifierFor: item) {
            
            return cellId
              
        } else {
            
            return defaultCellIdentifier
        }
    }
}


// MARK: ReservationsTableAdapter

//open class ReservationsTableAdapter<T: AnyEquatable>: HeaderFooterTableAdapter<T> {
//
//    // MARK: Private properties
//
//    private var reservations: Set<Reservation> = []
//
//    override open var currentSections: [Section<T>] {
//
//        var resultSections = sections
//
//        reservations.forEach { (reservation) in
//
//            resultSections[reservation.section].objects.remove(at: reservation.row)
//        }
//
//        return resultSections
//    }
//
//    // MARK: Override methods
//
//    override open func getCellIdetifier(for indexPath: IndexPath) -> String {
//
//        // Check reservations for that index path.
//        if let reservation = getReseravation(for: indexPath.row, in: indexPath.section) {
//
//            return reservation.cellId
//        }
//
//        let shiftedIndexPath = shiftConsideringReservations(indexPath)
//
//        return super.getCellIdetifier(for: shiftedIndexPath)
//    }
//
//    override open func update(with sections: [Section<T>], animated: Bool = true) {
//
//        let newSections = insertReservations(to: sections)
//
//        super.update(with: newSections, animated: animated)
//    }
//
//    // MARK: Private methods
//
//    private func shiftConsideringReservations(_ indexPath: IndexPath) -> IndexPath {
//        let reservationsBeforeIndexPath = reservations
//
//            .filter { $0.section == indexPath.section && $0.row < indexPath.row }
//
//        let shiftedRow = indexPath.row - reservationsBeforeIndexPath.count
//
//        return IndexPath(row: shiftedRow, section: indexPath.section)
//    }
//
//
//    // MARK: Public methods
//
//    public func reserveStaticCell(withIdentifier id: String, row: Int, section: Int = 0) {
//
//        let reservation = Reservation(cellId: id, row: row, section: section)
//
//        reservations.insert(reservation)
//    }
//
//    public func removeReservation(at row: Int, section: Int = 0) {
//
//        guard let reservation = getReseravation(for: row, in: section) else { return }
//
//        reservations.remove(reservation)
//    }
//
//    public func removeAllReservations() {
//
//        reservations.removeAll()
//    }
//
//    func getReseravation(for row: Int, in section: Int) -> Reservation? {
//
//        return reservations.first(where: { $0.section == section && $0.row == row })
//    }
//
//    private func insertReservations(to sections: [Section<T>]) -> [Section<T>] {
//
//        var newSections = sections
//
//        // Reservations must be sorted in order to preserve correct reservation positions.
//                reservations.sorted().forEach { (reservation) in
//
////                    newSections[reservation.section].objects.insert(reservation, at: reservation.row)
//                }
//
//        return newSections
//    }
//}
