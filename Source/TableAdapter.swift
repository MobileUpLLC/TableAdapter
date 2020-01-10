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
    
    private var reservations: Set<Reservation> = []
    
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
        
        var resultSections = sections
        
        reservations.forEach { (reservation) in
            
            resultSections[reservation.section].objects.remove(at: reservation.row)
        }
        
        return resultSections
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
        
        // Check reservations for that index path.
        if let reservation = getReseravation(for: indexPath.row, in: indexPath.section) {
            
            return reservation.cellId
        }
        
        // Shift row indices up to row reservations count.
        let reservationsBeforeIndexPath = reservations
            
            .filter { $0.section == indexPath.section && $0.row < indexPath.row }
        
        let shiftedRow = indexPath.row - reservationsBeforeIndexPath.count
        
        let resIndexPath = IndexPath(row: shiftedRow, section: indexPath.section)
        
        let object = getObject(for: resIndexPath)
        
        return dataSource?.tableAdapter(self, cellIdentifierFor: object) ?? defaultCellIdentifier
    }
    
    private func getReseravation(for row: Int, in section: Int) -> Reservation? {
        
        return reservations.first(where: { $0.section == section && $0.row == row })
    }
    
    private func insertReservations(to sections: [Section]) -> [Section] {
        
        var newSections = sections
        
        // Reservations must be sorted in order to preserve correct reservation positions.
        reservations.sorted().forEach { (reservation) in
                
            newSections[reservation.section].objects.insert(reservation, at: reservation.row)
        }
        
        return newSections
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
        
        do {
            
            let diff = try DiffUtil.calculateDiff(from: sections, to: newSections)
            
            updateTableView(with: diff)
            
        } catch DiffError.duplicates {
            
            print("Duplicates found during updating. Updates will be will be performed without animation")
            
            tableView.reloadData()
            
        } catch {
            
            tableView.reloadData()
        }
    }
    
    private func updateTableView(with diff: Diff) {
        
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
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        
        if tableView.delegate == nil {
            
            tableView.delegate = self
        }
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
        
        let newSections = insertReservations(to: sections)
        
        if animated {
            
            updateTableAnimated(with: newSections)
        
        } else {
            
            updateTable(with: newSections)
        }
    }
    
    public func reserveStaticCell(withIdentifier id: String, row: Int, section: Int = 0) {
        
        let reservation = Reservation(cellId: id, row: row, section: section)
        
        reservations.insert(reservation)
    }
    
    public func removeReservation(at row: Int, section: Int = 0) {
        
        guard let reservation = getReseravation(for: row, in: section) else { return }
        
        reservations.remove(reservation)
    }
    
    public func removeAllReservations() {
        
        reservations.removeAll()
    }
}

// MARK: UITableViewDataSource

extension TableAdapter: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].objects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section].header as? String
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return sections[section].footer as? String
    }
}

// MARK: UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.tableAdapter(self, didSelect: getObject(for: indexPath))
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.tableAdapter(self, didScroll: scrollView)
    }
}
