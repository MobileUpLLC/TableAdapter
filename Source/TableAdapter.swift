//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

// MARK: TableAdapter

open class TableAdapter<ItemType: AnyEquatable, SectionType: AnyEquatable>: NSObject, UITableViewDataSource {
    
    // MARK: Types
    
    public typealias CellProvider = (UITableView, IndexPath, ItemType) -> UITableViewCell
    
    public typealias Sec = Section<ItemType, SectionType>
    
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

            let diff = try DiffUtil.calculateDiff(from: sections, to: newSections)

            updateTableView(with: diff)

        } catch DiffError.duplicates {

            print("Duplicates found during updating. Updates will be will be performed without animation")

            updateTable(with: newSections)

        } catch {

            updateTable(with: newSections)
        }
    }
    
    private func updateTableView(with diff: Diff<ItemType, SectionType>) {

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
        
        return sections[indexPath.section].objects[indexPath.row]
    }
    
    
    // MARK: UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].objects.count
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


// MARK: DSTableAdapter

open class DSTableAdapter<ItemType: AnyEquatable, SectionType: AnyEquatable>: TableAdapter<ItemType, SectionType> {

    // MARK: Types
    
    public typealias CellIdentifierProvider = (ItemType) -> String?
    
    // MARK: Private properties
    
    private var cellIdentifierProvider: CellIdentifierProvider?
    
    private weak var dataSource: AnyTableAdapterDataSource?
    
    // MARK: Public properties
    
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
            
            view.anySetup(with: object, sender: getSender())
            
        } else if let view = view as? AnyConfigurable {
            
            view.anySetup(with: object)
        }
    }
    
    private func getSender() -> AnyObject {
        
        return sender ?? self
    }
    
    // MARK: Public methods
    
    public convenience init<DataSource: TableAdapterDataSource>(
        tableView: UITableView,
        sender: AnyObject? = nil,
        dataSource: DataSource? = nil,
        cellIdentifierProvider: CellIdentifierProvider? = nil
    ) {
        self.init(tableView: tableView, sender: sender, cellIdentifierProvider: cellIdentifierProvider)
        
        self.dataSource = dataSource
    }
    
    public convenience init(
        tableView: UITableView,
        sender: AnyObject? = nil,
        cellIdentifierProvider: CellIdentifierProvider? = nil
    ) {
        self.init(tableView: tableView)
        
        self.sender = sender
        
        self.cellIdentifierProvider = cellIdentifierProvider
    }
    
    open func getCellIdetifier(for indexPath: IndexPath) -> String {
        
        let item = getItem(for: indexPath)
        
        if let cellId = dataSource?.tableAdapter(self, cellIdentifierFor: item) {
            
            return cellId
            
        } else if let cellId = cellIdentifierProvider?(item) {
            
            return cellId
            
        } else {
            
            return defaultCellIdentifier
        }
    }
    
    //    public func update(with objects: [AnyEquatable], animated: Bool = true) {
    //
    //        let newGroups = makeSections(from: objects)
    //
    //        update(with: newGroups, animated: animated)
    //    }
    
    //    private func makeSections(from objects: [AnyEquatable]) -> [Section] {
    //
    //        var result: [DefaultSection] = []
    //
    //        for object in objects {
    //
    //            let header = dataSource?.tableAdapter(self, headerObjectFor: object)
    //            let footer = dataSource?.tableAdapter(self, footerObjectFor: object)
    //
    //            let newSection = DefaultSection(objects: [object], headerObject: header, footerObject: footer)
    //
    //            if let lastSection = result.last, lastSection.equal(any: newSection) {
    //
    //                result[result.endIndex - 1].objects.append(object)
    //
    //            } else {
    //
    //                result.append(newSection)
    //            }
    //        }
    //
    //        return result
    //    }
}

// MARK: HeaderFooterTableAdapter

open class HeaderFooterTableAdapter<ItemType: AnyEquatable, SectionType: AnyEquatable>: DSTableAdapter<ItemType, SectionType>, UITableViewDelegate {
    
    // MARK: Private properties
    
    private weak var delegate: AnyTableAdapterDelegate?
    
    // MARK: Public properties
    
    public var defaultHeaderIdentifier = "Header" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Header reuse identifier must not be empty string") }
    }
    
    public var defaultFooterIdentifier = "Footer" {
        
        didSet { assert(defaultHeaderIdentifier.isEmpty == false, "Footer reuse identifier must not be empty string") }
    }
    
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

        return delegate?.tableAdapter(self, headerIdentifierFor: section) ?? defaultHeaderIdentifier
    }

    private func getFooterIdentifier(for section: Int) -> String {
        
        return delegate?.tableAdapter(self, footerIdentifierFor: section) ?? defaultFooterIdentifier
    }
    
    // MARK: Public methods
    
    
    public convenience init<Delegate: TableAdapterDelegate, DataSource: TableAdapterDataSource>(
        tableView: UITableView,
        sender: AnyObject? = nil,
        dataSource: DataSource? = nil,
        delegate: Delegate? = nil,
        cellIdentifierProvider: CellIdentifierProvider? = nil
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
        cellIdentifierProvider: CellIdentifierProvider? = nil
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

        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = getItem(for: indexPath)

        delegate?.tableAdapter(self, didSelect: item)
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
