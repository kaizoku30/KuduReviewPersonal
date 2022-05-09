import UIKit

class BaseTabBarVC: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    func tabBarController(_ tabBarCçntroller: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
////        if viewController is PlaceholderVC {
////            let navVC = ExperienceEditorNavigationController(rootViewController: AddExperienceVC.instantiate(fromAppStoryboard: .Experience))
////            navVC.modalPresentationStyle = .fullScreen
////            self.present(navVC, animated: true)
////                return false
////            } else {
////                return true
////            }
//    }
}
