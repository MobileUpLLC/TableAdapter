//
//  ReservationsTableAdapter.swift
//  TableAdapter
//
//  Created by Nikolai Timonin on 13.02.2020.
//

import Foundation

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
