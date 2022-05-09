import Foundation

extension BaseVC
{
    func observeFor(_ type:Constants.NotificationObservers,selector:Selector)
    {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.init(rawValue: type.rawValue), object: nil)
    }
}
extension NotificationCenter
{
    static func postNotificationForObservers(_ type:Constants.NotificationObservers)
    {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: type.rawValue), object: nil)
    }
}
extension BaseTabBarVC
{
    func observeFor(_ type:Constants.NotificationObservers,selector:Selector)
    {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.init(rawValue: type.rawValue), object: nil)
    }
}

extension BaseNavVC
{
    func observeFor(_ type:Constants.NotificationObservers,selector:Selector)
    {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.init(rawValue: type.rawValue), object: nil)
    }
}
