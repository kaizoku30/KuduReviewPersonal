
import UIKit

extension UITableViewCell {
    
    /// Variable to get default reuseIdentifier
    public static var defaultReuseIdentifier: String {
        return "\(self)"
    }
    
    /// Variable to get parent table view
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }
    
    /// Variable to get indexpath of cell
    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
    
    static func getEmptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
}
