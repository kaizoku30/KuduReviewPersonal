import Foundation
import UIKit

// MARK: - Table View Extension
extension UITableView {
    
    ///Variable to set automatic height of tableview
    var automaticHeight: CGFloat {
        return UITableView.automaticDimension
    }

    /// Returns cell for the given item
    /// - Parameter item: Any type of item is accepted
    /// - Returns: UITableViewCell will be return
    func cell(forItem item: Any) -> UITableViewCell? {
        if let indexPath = self.indexPath(forItem: item) {
            return self.cellForRow(at: indexPath)
        }
        return nil
    }

    /// Returns the indexpath for the given item
    /// - Parameter item: Any type of item is accepted
    /// - Returns: IndexPath of the cell will be return
    func indexPath(forItem item: Any) -> IndexPath? {
        let itemPosition: CGPoint = (item as AnyObject).convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }

    /// Registers the given cell
    /// - Parameter cellType: UITableViewCell type for registration
    func registerClass(cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.defaultReuseIdentifier)
    }

    /// dequeues a reusable cell for the given indexpath
    /// - Parameter indexPath: indexpath for dequeue reusable cell
    /// - Returns: T type of cell will be return
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier). Ensure you have registered the cell." )
        }
        return cell
    }
    
    /// Method to get indexpath for table cells in selection section
    /// - Parameters:
    ///   - inSection: Int value for which section to be used
    ///   - exceptRows: Int array value for except row
    /// - Returns: IndexPath array will be returned
    func indexPathForCells(inSection: Int, exceptRows: [Int] = []) -> [IndexPath] {
        let rows = self.numberOfRows(inSection: inSection)
        var indices: [IndexPath] = []
        for row in 0..<rows {
            if exceptRows.contains(row) { continue }
            indices.append([inSection, row])
        }
        return indices
    }
    
    /// Method to scroll to last cell
    /// - Parameter animated: Bool value which determine whether animated or not
    func scrollToLastCell(animated: Bool = true) {
           let lastSectionIndex = self.numberOfSections - 1 // last section
           let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 2 // last row
        self.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
       }
    
    ///Register Table View Cell Nib
    func registerCell(with identifier: UITableViewCell.Type) {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil),
                      forCellReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Table View Cell with identifierString
    func registerCell(with identifierString: String) {
        self.register(UINib(nibName: "\(identifierString)", bundle: nil),
                      forCellReuseIdentifier: "\(identifierString)")
    }

    ///Register Header Footer View Nib
    func registerHeaderFooter(with identifier: UITableViewHeaderFooterView.Type) {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: "\(identifier.self)")
    }
    
    ///Register Header Footer View Nib
    func registerHeaderFooterClass(with identifier: UITableViewHeaderFooterView.Type) {
        self.register(identifier.self, forHeaderFooterViewReuseIdentifier: identifier.className)
    }

    ///Dequeue Table View Cell
    func dequeueCell <T: UITableViewCell> (with identifier: T.Type, indexPath: IndexPath? = nil) -> T {
        if let index = indexPath {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)", for: index) as! T
        } else {
            return self.dequeueReusableCell(withIdentifier: "\(identifier.self)") as! T
        }
    }

    ///Dequeue Header Footer View
    func dequeueHeaderFooter <T: UITableViewHeaderFooterView> (with identifier: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(identifier.self)") as! T
    }
    
    ///Method to reload tableview without animation
    func reloadRowsWithoutAnimation(indexPaths: [IndexPath]) {
        UIView.performWithoutAnimation {
            self.reloadRows(at: indexPaths, with: .none)
        }
    }
    
    /// Method to show bottom loader
    /// - Parameters:
    ///   - delegate: RetryButtonDelegate by which retry button action will be called
    ///   - isNetworkConnected: Is connected to network
//    func showBottomLoader(delegate: RetryButtonDelegate? = nil, isNetworkConnected: Bool = true) {
//        if CommonFunctions.isConnectedToNetwork() && isNetworkConnected {
//            guard !(self.tableFooterView?.isKind(of: UIActivityIndicatorView.self) ?? false) else { return }
//            let spinner: UIActivityIndicatorView
//            if #available(iOS 13.0, *) {
//                spinner = UIActivityIndicatorView(style: .medium)
//            } else {
//                spinner = UIActivityIndicatorView(style: .gray)
//            }
//            spinner.isHidden = false
//            spinner.color = AppColors.themeColor
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
//            self.tableFooterView = spinner
//        }else {
//            guard !(self.tableFooterView?.isKind(of: RetryButton.self) ?? false) else { return }
//            let retryButton = RetryButton.init(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
//            retryButton.delegate = delegate
//            self.tableFooterView = retryButton
//        }
//        self.tableFooterView?.isHidden = false
//    }
    
    ///Method to hide bottom loader
    func hideBottomLoader() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
}

extension UITableView {
    
    /// This returns the last indexpath of the tableview.
    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)

        return IndexPath(row: row, section: section)
    }
}

extension UITableView {
    
    func setEmptyMessageWithFrame(_ message: String, frame: CGRect) {
        self.restore()
        let messageLabel = UILabel(frame: frame)
        messageLabel.text = message
        messageLabel.textColor = AppColors.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = AppFonts.themeFont.withSize(20.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.bringSubviewToFront(messageLabel)
        self.separatorStyle = .none
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = AppColors.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = AppFonts.themeFont.withSize(20.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
    func hideTableViewWithAlpha() {
        self.alpha = 0.0
        self.isUserInteractionEnabled = false
    }
    
    func animateTableViewWithAlpha() {
        UIView.animate(withDuration: 0.33) {
            self.alpha = 1.0
        } completion: { (_) in
            self.isUserInteractionEnabled = true
        }
    }

}

extension UIResponder {
    /**
     * Returns the next responder in the responder chain cast to the given type, or
     * if nil, recurses the chain until the next responder is nil or castable.
     */
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}

extension UITableView {
    
    ///Variable-height UITableView tableHeaderView with autolayout
    func layoutTableHeaderView() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        headerView.addConstraints(temporaryWidthConstraints)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        self.tableHeaderView = headerView
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func layoutTableFooterView() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[footerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["footerView": headerView])
        headerView.addConstraints(temporaryWidthConstraints)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        self.tableHeaderView = headerView
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension UITableView {
    ///Method to set header size to autolayout
    func sizeHeaderToFit() {
        if let headerView = self.tableHeaderView {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            self.tableHeaderView = headerView
        }
    }
    
    ///Method to set footer size to autolayout
    func sizeFooterToFit() {
        if let footerView = self.tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = footerView.frame
            frame.size.height = height
            footerView.frame = frame
            
            self.tableFooterView = footerView
        }
    }
    
    ///Method to update header size to autolayout
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }

    ///Method to update footer size to autolayout
    func updateFooterViewHeight() {
        if let footer = self.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            footer.frame.size.height = newSize.height
        }
    }
    
    func relaodDataWithAnimation(duration: TimeInterval = 0.33, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: self, duration: duration, options: options, animations: { () -> Void in
            self.reloadData()
        }, completion: nil)
    }
}
