
import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import MobileCoreServices

// UIViewController extension
extension UIViewController{
    
    //UIViewController extension for Image picker
    typealias ImagePickerDelegateController = (UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    
//    func checkAndOpenCamera(delegate controller: ImagePickerDelegateController, mediaType: [String] = [kUTTypeImage as String]) {
//
//        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        switch authStatus {
//
//        case .authorized:
//
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = controller
//            imagePicker.mediaTypes = mediaType
//            imagePicker.videoMaximumDuration = 15
//            let sourceType = UIImagePickerController.SourceType.camera
//            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//                imagePicker.sourceType = sourceType
//                imagePicker.allowsEditing = false
//
//                if imagePicker.sourceType == .camera {
//                    imagePicker.showsCameraControls = true
//                }
//                controller.present(imagePicker, animated: true, completion: nil)
//
//            } else {
//                let cameraNotAvailableText = LS.cameraNotAvailable
//                Router.shared.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: LS.alert, alertMessage: cameraNotAvailableText, leftButtonTitle: "", rightButtonTitle: LS.ok)
//            }
//
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
//
//                if granted {
//
//                    DispatchQueue.main.async {
//                        let imagePicker = UIImagePickerController()
//                        imagePicker.delegate = controller
//                        imagePicker.mediaTypes = mediaType
//                        imagePicker.videoMaximumDuration = 15
//
//                        let sourceType = UIImagePickerController.SourceType.camera
//                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//                            imagePicker.sourceType = sourceType
//                            if imagePicker.sourceType == .camera {
//                                imagePicker.allowsEditing = false
//                                imagePicker.showsCameraControls = true
//                            }
//                            controller.present(imagePicker, animated: true, completion: nil)
//
//                        } else {
//                            let cameraNotAvailableText = LS.cameraNotAvailable
//                            Router.shared.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: LS.alert, alertMessage: cameraNotAvailableText, leftButtonTitle: "", rightButtonTitle: LS.ok)
//                        }
//                    }
//                }
//            })
//
//        case .restricted:
//            Router.shared.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: LS.alert, alertMessage: LS.restrictedFromUsingCamera, leftButtonTitle: "", rightButtonTitle: LS.ok, completion: {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
//                }
//            }, dismissCompletion: nil)
//
//
//        case .denied:
//            Router.shared.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: LS.alert, alertMessage: LS.changePrivacySettingAndAllowAccessToCamera, leftButtonTitle: "", rightButtonTitle: LS.ok, completion: {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
//                }
//            }, dismissCompletion: nil)
//
//        @unknown default:
//            fatalError("invalid state")
//        }
//    }
    
//    func checkAndOpenLibrary(delegate controller: ImagePickerDelegateController, mediaType: [String] = [kUTTypeImage as String]) {
//
//        let authStatus = PHPhotoLibrary.authorizationStatus()
//        switch authStatus {
//
//        case .notDetermined:
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = controller
//            imagePicker.mediaTypes = mediaType
//            let sourceType = UIImagePickerController.SourceType.photoLibrary
//            imagePicker.sourceType = sourceType
//            imagePicker.allowsEditing = false
//            imagePicker.videoMaximumDuration = 15
//
//            controller.present(imagePicker, animated: true, completion: nil)
//
//        case .restricted, .denied:
////            Router.shared.showAppAlertWithCompletion(vc: self, alertType: .singleButton, alertTitle: LS.alert, alertMessage: authStatus == .denied ? LS.changePrivacySettingAndAllowAccessToLibrary : LS.restrictedFromUsingLibrary, leftButtonTitle: "", rightButtonTitle: LS.ok, completion: {
////                if #available(iOS 10.0, *) {
////                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
////                } else {
////                    // Fallback on earlier versions
////                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
////                }
////            }, dismissCompletion: nil)
//
//        case .authorized:
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = controller
//            let sourceType = UIImagePickerController.SourceType.photoLibrary
//            imagePicker.sourceType = sourceType
//            imagePicker.allowsEditing = false
//            imagePicker.mediaTypes = mediaType
//            imagePicker.videoMaximumDuration = 15
//
//            controller.present(imagePicker, animated: true, completion: nil)
//        default:
//            debugPrint("invalid state")
//        }
//    }
//
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController: UIViewController, containerView: UIView? = nil) {
        let mainView: UIView = containerView ?? self.view
        self.addChild(childViewController)
        childViewController.view.frame = mainView.bounds
        mainView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParent: Void {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title: String? = nil, leftButton: [UIBarButtonItem]? = nil, rightButtons: [UIBarButtonItem]? = nil, tintColor: UIColor? = nil, barTintColor: UIColor? = nil, titleTextAttributes: [NSAttributedString.Key: Any]? = nil) {
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor {
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor {
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton {
            self.navigationItem.leftBarButtonItems = button
        }
        if let rightBtns = rightButtons {
            self.navigationItem.rightBarButtonItems = rightBtns
        }
        if let ttle = title {
            self.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes {
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    
    
    /// Start Loader
    func startNYLoader() {
        debugPrint("Add a loader")
        //startAnimating(CGSize(width: 50, height: 50), type: NVActivityIndicatorType.ballRotateChase, color: AppColors.themeColor, backgroundColor: AppColors.clear)
    }
    
//    func showActionSheet(title: String = CommonStrings.emptyString,
//                         msg: String,
//                         cancelTitle: String = LS.cancel.localized,
//                         arrAction: [UIAlertAction]) {
//        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
//        alert.title = nil
//        alert.message = nil
//        for i in 0...arrAction.count - 1 {
//            let action = arrAction[i]
//            action.setValue(AppColors.black , forKey: CommonStrings.titleTextColor)
//            alert.addAction(action)
//        }
//        let cancelAction = UIAlertAction(title: LS.cancel.localized, style: .cancel) { (_) in
//            debugPrint("Dismissed")
//        }
//        alert.addAction(cancelAction)
//        cancelAction.setValue(AppColors.themeColor , forKey: CommonStrings.titleTextColor)
//        self.present(alert, animated: true, completion: {
//            debugPrint("completion block")
//        })
//    }
}

extension UIViewController {
//    @discardableResult
//    func addStatusBarBackgroundView(backgroundColor: UIColor = .white) -> UIView {
//        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIDevice.width, height: UIDevice.topSafeArea))
//        let bgView = UIView.init(frame: rect)
//        bgView.backgroundColor = backgroundColor
//        self.view?.addSubview(bgView)
//        return bgView
//    }
}

//MARK:- Add photos from Photos or Camera.
extension UIViewController{
    
//    func reloadScreen() {
//        for tableView in self.view.getAllTableViews() {
//            (tableView as? UITableView)?.reloadData()
//        }
//        for collectionView in self.view.getAllCollectionViews() {
//            (collectionView as? UICollectionView)?.reloadData()
//        }
//        for child in self.children {
//            child.reloadScreen()
//        }
//        self.view.setNeedsLayout()
//    }
}

extension UIViewController {
    
//    func openCamerAndLibraryAlert(controller: ImagePickerDelegateController, mediaType: [String] = [kUTTypeImage as String]) {
//        let openCamera = UIAlertAction(title: LS.openCamera, style: .default) { [weak self] (button) in
//            guard let `self` = self else { return }
//            self.checkAndOpenCamera(delegate: controller, mediaType: [kUTTypeImage as String])
//        }
//        let chooseFromGallery = UIAlertAction(title: LS.chooseFromGallery, style: .default) { [weak self] (button) in
//            guard let `self` = self else { return }
//            self.checkAndOpenLibrary(delegate: controller, mediaType: mediaType)
//        }
//        openCamera.setValue(AppColors.normalTextColor , forKey: CommonStrings.titleTextColor)
//        chooseFromGallery.setValue(AppColors.normalTextColor , forKey: CommonStrings.titleTextColor)
//        Router.shared.appActionSheet(vc: self, title: LS.addImage, actions: [openCamera, chooseFromGallery], cancelButtonTitle: LS.cancel.localized.capitalizedFirst, cancelButtonColor: AppColors.themeColor)
//    }
}
