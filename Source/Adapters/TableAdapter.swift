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
        withIdentifier id : String,
        configItem        : Any?
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
        tableView              : UITableView,
        sender                 : AnyObject?                    = nil,
        cellIdentifierProvider : CellReuseIdentifierProvider?  = nil,
        cellDidSelectHandler   : CellDidSelectHandler?         = nil
    ) {
        super.init(
            tableView              : tableView,
            sender                 : sender,
            cellIdentifierProvider : cellIdentifierProvider
        )
        
        self.cellDidSelectHandler = cellDidSelectHandler
        
        tableView.delegate = self
    }

    public override init(
        tableView    : UITableView,
        cellProvider : BaseTableAdapter<Item, SectionId>.CellProvider?
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: - UITableViewDelegate

    // MARK: Section header & footer information
    
    open func tableView(
        _ tableView                    : UITableView,
        viewForHeaderInSection section : Int
    ) -> UIView? {

        return dequeueConfiguredHeaderFooterView(
            withIdentifier : getHeaderIdentifier(for : section),
            configItem     : sections[section].header
        )
    }

    open func tableView(
        _ tableView                    : UITableView,
        viewForFooterInSection section : Int
    ) -> UIView? {

        return dequeueConfiguredHeaderFooterView(
            withIdentifier : getFooterIdentifier(for : section),
            configItem     : sections[section].footer
        )
    }

    // MARK: Selection

    public func tableView(
        _ tableView                    : UITableView,
        shouldHighlightRowAt indexPath : IndexPath
    ) -> Bool {
        return true
    }

    public func tableView(
        _ tableView                 : UITableView,
        didHighlightRowAt indexPath : IndexPath
    ) { }

    public func tableView(
        _ tableView                   : UITableView,
        didUnhighlightRowAt indexPath : IndexPath
    ) { }

    open func tableView(
        _ tableView               : UITableView,
        willSelectRowAt indexPath : IndexPath
    ) -> IndexPath? {

        return indexPath
    }

    open func tableView(
        _ tableView                 : UITableView,
        willDeselectRowAt indexPath : IndexPath
    ) -> IndexPath? {

        return indexPath
    }
    
    open func tableView(
        _ tableView              : UITableView,
        didSelectRowAt indexPath : IndexPath
    ) {
        
        if let handler = cellDidSelectHandler {
            
            let item = getItem(for: indexPath)
            
            handler(tableView, indexPath, item)
        }
    }

    open func tableView(
        _ tableView                : UITableView,
        didDeselectRowAt indexPath : IndexPath
    ) { }

    // MARK: Editing

    open func tableView(
        _ tableView                    : UITableView,
        editingStyleForRowAt indexPath : IndexPath
    ) -> UITableViewCell.EditingStyle {

        return .none
    }

    open func tableView(
        _ tableView                                        : UITableView,
        titleForDeleteConfirmationButtonForRowAt indexPath : IndexPath
    ) -> String? {

        return nil
    }

    @available(iOS 11.0, *)
    open func tableView(
        _ tableView                                        : UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath : IndexPath
    ) -> UISwipeActionsConfiguration? {

        return nil
    }

    @available(iOS 11.0, *)
    open func tableView(
        _ tableView                                         : UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath : IndexPath
    ) -> UISwipeActionsConfiguration? {

        return nil
    }

    open func tableView(
        _ tableView                             : UITableView,
        shouldIndentWhileEditingRowAt indexPath : IndexPath
    ) -> Bool {

        return true
    }

    open func tableView(
        _ tableView                     : UITableView,
        willBeginEditingRowAt indexPath : IndexPath
    ) { }

    open func tableView(
        _ tableView                  : UITableView,
        didEndEditingRowAt indexPath : IndexPath?
    ) {

    }

    // MARK: Moving/reordering

    open func tableView(
        _ tableView                                      : UITableView,
        targetIndexPathForMoveFromRowAt sourceIndexPath  : IndexPath,
        toProposedIndexPath proposedDestinationIndexPath : IndexPath
    ) -> IndexPath {

        return proposedDestinationIndexPath
    }

    // MARK: Focus

    open func tableView(
        _ tableView             : UITableView,
        canFocusRowAt indexPath : IndexPath
    ) -> Bool {

        return true
    }

    open func tableView(
        _ tableView                 : UITableView,
        shouldUpdateFocusIn context : UITableViewFocusUpdateContext
    ) -> Bool {

        return true
    }

    open func tableView(
        _ tableView              : UITableView,
        didUpdateFocusIn context : UITableViewFocusUpdateContext,
        with coordinator         : UIFocusAnimationCoordinator
    ) {

    }

    open func indexPathForPreferredFocusedView(
        in tableView: UITableView
    ) -> IndexPath? {

        return nil
    }

    // MARK: Spring Loding

    @available(iOS 11.0, *)
    open func tableView(
        _ tableView                     : UITableView,
        shouldSpringLoadRowAt indexPath : IndexPath,
        with context                    : UISpringLoadedInteractionContext
    ) -> Bool {

        return true
    }

    // MARK: Multiple Selection

    open func tableView(
        _ tableView                                         : UITableView,
        shouldBeginMultipleSelectionInteractionAt indexPath : IndexPath
    ) -> Bool {

        return false
    }

    open func tableView(
        _ tableView                                      : UITableView,
        didBeginMultipleSelectionInteractionAt indexPath : IndexPath
    ) { }

    open func tableViewDidEndMultipleSelectionInteraction(
        _ tableView: UITableView
    ) { }

    // MARK: Menus

    @available(iOS 13.0, *)
    open func tableView(
        _ tableView                                : UITableView,
        contextMenuConfigurationForRowAt indexPath : IndexPath,
        point                                      : CGPoint
    ) -> UIContextMenuConfiguration? {

        return nil
    }

    @available(iOS 13.0, *)
    open func tableView(
        _ tableView                                                      : UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration : UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        return nil
    }

    @available(iOS 13.0, *)
    open func tableView(
        _ tableView                                                    : UITableView,
        previewForDismissingContextMenuWithConfiguration configuration : UIContextMenuConfiguration
    ) -> UITargetedPreview? {

        return nil
    }

    @available(iOS 13.0, *)
    open func tableView(
        _ tableView                                       : UITableView,
        willPerformPreviewActionForMenuWith configuration : UIContextMenuConfiguration,
        animator                                          : UIContextMenuInteractionCommitAnimating
    ) { }

    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) { }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }

    open func scrollViewWillEndDragging(
        _ scrollView          : UIScrollView,
        withVelocity velocity : CGPoint,
        targetContentOffset   : UnsafeMutablePointer<CGPoint>
    ) { }

    open func scrollViewDidEndDragging(
        _ scrollView              : UIScrollView,
        willDecelerate decelerate : Bool
    ) { }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) { }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { }

    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }

    open func scrollViewWillBeginZooming(
        _ scrollView : UIScrollView,
        with view    : UIView?
    ) { }

    open func scrollViewDidEndZooming(
        _ scrollView  : UIScrollView,
        with view     : UIView?,
        atScale scale : CGFloat
    ) { }

    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) { }

    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) { }
}
