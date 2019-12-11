//
//  TableAdapter.swift
//  Pods-TableAdapterExample
//
//  Created by Nikolai Timonin on 28.11.2019.
//

import UIKit

open class TableAdapter: NSObject {
    
    // MARK: Types
    
    enum Event {
        
        case move, insert, delete, update
    }
    
    // MARK: Private properties
    
    private let tableView: UITableView
    
    private var groups: [SectionGroup] = []
    
    // MARK: Public properties
    
    public weak var sender: AnyObject?
    
    public weak var dataSource: TableAdapterDataSource?
    
    public weak var sectionsSource: TableSectionsSource?
    
    public weak var delegate: TableAdapterDelegate?
    
    public var headerIdentifier = "Header" {
        
        didSet { assert(headerIdentifier.isEmpty == false, "Header reuse identifier must not be empty string") }
    }
    
    public var footerIdentifier = "Footer" {
        
        didSet { assert(headerIdentifier.isEmpty == false, "Footer reuse identifier must not be empty string") }
    }
    
    public var currentGroups: [SectionGroup] {
        
        return groups
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
        
        return dataSource?.tableAdapter(self, cellIdentifierFor: getObject(for: indexPath)) ?? "Cell"
    }
    
    private func getObject(for indexPath: IndexPath) -> AnyDifferentiable {
        
        return groups[indexPath.section].rowObjects[indexPath.row]
    }
    
    private func makeGroups(from objects: [AnyDifferentiable]) -> [SectionGroup] {
        
        var result: [Group] = []
        
        for object in objects {
            
            let header = sectionsSource?.tableAdapter(self, headerObjectFor: object)
            let footer = sectionsSource?.tableAdapter(self, footerObjectFor: object)
            
            let newGroup = Group(header: header, footer: footer, rowObjects: [object])
            
            if let lastGroup = result.last, lastGroup.id.equal(any: newGroup.id) {
                
                result[result.endIndex - 1].rowObjects.append(object)
                
            } else {
                
                result.append(newGroup)
            }
        }
        
        return result
    }
    
    private func getSender() -> AnyObject {
        
        return sender ?? self
    }
    
    private func updateTable(with newGroups: [SectionGroup]) {
        
        groups = newGroups
        
        tableView.reloadData()
    }
    
    private func updateTableAnimated(with newGroups: [SectionGroup]) {

        let oldGroups = groups
        groups = newGroups
        
        for g in groups {
            
            if checkAreDuplicateObjectExist(objects: g.rowObjects) {
                
                tableView.reloadData()
                
                return
            }
        }
        
        for g in oldGroups {
            
            if checkAreDuplicateObjectExist(objects: g.rowObjects) {
                
                tableView.reloadData()
                
                return
            }
        }
        
        let color = tableView.separatorColor

        tableView.separatorColor = .clear

        tableView.beginUpdates()

        updateSections(with: oldGroups)

        updateRows(with: oldGroups)

        tableView.endUpdates()

        tableView.separatorColor = color
        
//        let diff = DiffUtil.calculateGroupsDiff(from: oldGroups, to: groups)
//
//        print(diff)
//
//        tableView.beginUpdates()
//
//        tableView.insertSections(diff.sectionsDiff.inserts, with: animationType)
////        diff.sectionsDiff.moves.forEach { tableView.moveSection($0.from, toSection: $0.to) }
//        tableView.deleteSections(diff.sectionsDiff.deletes, with: animationType)
////        tableView.reloadSections(diff.sectionsDiff.reloads, with: animationType)
//
//        tableView.insertRows(at: diff.rowsDiff.inserts, with: animationType)
//        diff.rowsDiff.moves.forEach { tableView.moveRow(at: $0.from, to: $0.to) }
//        tableView.deleteRows(at: diff.rowsDiff.deletes, with: animationType)
//
//        tableView.endUpdates()
    }
    
    
    private func updateSections(with oldGroups: [SectionGroup]) {
        
        var groupsToDelete: [SectionGroup] = oldGroups
        
        for (newIndex, newGroup) in groups.enumerated() {
            
            guard let index = oldGroups.firstIndex(where: { newGroup.id.equal(any: $0.id) }) else {
                
                changeSection(at: newIndex, for: .insert)
                
                continue
            }
            
            if index != newIndex {
                
                changeSection(at: newIndex, for: .move)
            }
            
            if let deleteIndex = groupsToDelete.firstIndex(where: { newGroup.id.equal(any: $0.id) }) {
                
                groupsToDelete.remove(at: deleteIndex)
            }
        }
        
        for section in groupsToDelete {
            
            guard let index = oldGroups.firstIndex(where: { section.id.equal(any: $0.id) })  else { continue }
            
            changeSection(at: index, for: .delete)
        }
    }
    
    private func updateRows(with oldGroups: [SectionGroup]) {
        
        var objectsToDelete: [SectionGroup] = oldGroups
        
        for (newSection, newGroup) in groups.enumerated() {
            
            for (newRow, newObject) in newGroup.rowObjects.enumerated() {
                
                let newIndexPath = IndexPath(row: newRow, section: newSection)
                
                guard let oldIndexPath = getIndexPath(for: newObject, in: oldGroups) else {
                    
                    changeRow(at: newIndexPath, for: .insert)
                    
                    continue
                }
                
                if oldIndexPath == newIndexPath {
                    
                    let oldObject = oldGroups[oldIndexPath.section].rowObjects[oldIndexPath.row]

                    if newObject.equal(any: oldObject) == false {

                        changeRow(from: oldIndexPath, at: newIndexPath, for: .update)
                    } else {
                        updateRow(at: oldIndexPath, with: newObject)
                    }
                }
                
                if oldIndexPath != newIndexPath {
                    
                    changeRow(from: oldIndexPath, at: newIndexPath, for: .move)
                    
                    updateRow(at: oldIndexPath, with: newObject)
                }
                
                if let indexPath = getIndexPath(for: newObject, in: objectsToDelete) {
                    
                    objectsToDelete[indexPath.section].rowObjects.remove(at: indexPath.row)
                }
            }
        }
        
        for (_,objects) in objectsToDelete.enumerated() {
            
            for (_,object) in objects.rowObjects.enumerated() {
                
                if let indexPath = getIndexPath(for: object, in: oldGroups) {
                    
                    changeRow(from: indexPath, for: .delete)
                }
            }
        }
    }
    
    private func updateRow(at indexPath: IndexPath, with newObject: AnyDifferentiable) {
        
        (tableView.cellForRow(at: indexPath) as? AnyConfigurable)?.anySetup(with: newObject)
    }
    
    private func getIndexPath(for object: AnyDifferentiable, in groups: [SectionGroup]) -> IndexPath? {
        
        for (groupIdx, group) in groups.enumerated() {
            
            if let objectIdx = group.rowObjects.firstIndex(where: { object.id.equal(any: $0.id) }) {
                
                return IndexPath(row: objectIdx, section: groupIdx)
            }
        }
        
        return nil
    }
    
    private func checkAreDuplicateObjectExist(objects: [AnyDifferentiable]) -> Bool {
        
        let objects = objects.enumerated()
        
        for (index,object) in objects {
            
            for (secondIndex, secondObject) in objects {
                
                if object.id.equal(any: secondObject.id) && index != secondIndex {
                    
                    print("Error: there are duplicated ids \(object.id)")
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    private func changeRow(from oldIndex: IndexPath? = nil, at index: IndexPath? = nil, for type: Event) {
        
        switch type {
        case .insert : tableView.insertRows(at: [index!], with: animationType)
        case .update : tableView.reloadRows(at: [oldIndex!], with: animationType)
        case .delete : tableView.deleteRows(at: [oldIndex!], with: animationType)
        case .move   : tableView.moveRow(at: oldIndex!, to: index!)
        }
    }
    
    private func changeSection(at index: Int, for type: Event) {
        
        switch type {
        case .insert : tableView.insertSections([index], with: animationType)
        case .delete : tableView.deleteSections([index], with: animationType)
        case .update : tableView.reloadSections([index], with: animationType)
        default      : break
        }
    }
    
    // MARK: Public methods
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    public func update(with objects: [AnyDifferentiable], animated: Bool = true) {
        
        let newGroups = makeGroups(from: objects)
        
        update(withG: newGroups, animated: animated)
    }
    
    public func update(withG groups: [SectionGroup], animated: Bool = true) {
        
        if animated {
            
            updateTableAnimated(with: groups)
        
        } else {
            
            updateTable(with: groups)
        }
    }
}

// MARK: UITableViewDataSource

extension TableAdapter: UITableViewDataSource {
    
    // MARK: Data setup
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return groups.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups[section].rowObjects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueConfiguredCell(forRowAt: indexPath)
    }
    
    // MARK: HeaderFooter setup
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return groups[section].header as? String
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

        return groups[section].footer as? String
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(withIdentifier: headerIdentifier, object: groups[section].header)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return dequeueConfiguredHeaderFooterView(withIdentifier: footerIdentifier, object: groups[section].footer)
    }
}

// MARK: UITableViewDelegate

extension TableAdapter: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.tableAdapter(self, didSelect: getObject(for: indexPath))
    }
}
