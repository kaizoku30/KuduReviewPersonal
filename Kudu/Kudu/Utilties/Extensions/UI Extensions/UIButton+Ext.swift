

import UIKit
import Kingfisher

// UIButton Extension
extension UIButton {
    
    func setImage_kf(imageString: String, placeHolderImage: UIImage?, loader: Bool = true, completionHandler: ((Bool) -> ())? = nil) {
        guard let url = URL.init(string: imageString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: imageString)
        if loader {
//            self.kf.indicatorType = .activity
//            self.kf.indicator?.view.tintColor = AppColors.themeColor
//            (self.kf.indicator?.view as? UIActivityIndicatorView)?.color = AppColors.themeColor
        }
        
        self.kf.setImage(with: resource, for: .normal, placeholder: placeHolderImage, options: nil, progressBlock: { (prog1, prog2) in
            printDebug("\(prog1), \(prog2)")
        }) { (result) in
            switch result {
            case .success(_):
                completionHandler?(true)
            case .failure(let error):
                if error.isInvalidResponseStatusCode {
                    completionHandler?(false)
                }
            }

        }
    }
    
    func cancelImageDownloading() {
        self.kf.cancelImageDownloadTask()
    }
    
    static func cacheImage(url: String) {
        guard let imageUrl = URL(string: url) else {return}
        
        if ImageCache.default.retrieveImageInMemoryCache(forKey: imageUrl.absoluteString) == nil {
            
            ImageDownloader.default.downloadImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: { (result) in
                switch result {
                case .success(let value):
                    printDebug("Image Downloaded: \(String(describing: value.url))")
                    ImageCache.default.store(value.image, forKey: imageUrl.absoluteString)
                case .failure(let error):
                    printDebug("Error: \(error)")
                }
            })
        } else {
            printDebug("image is already cached")
        }
    }
    
    static func saveImage(image: UIImage, url: String) {
        if ImageCache.default.retrieveImageInMemoryCache(forKey: url) == nil {
            ImageCache.default.store(image, forKey: url)
            printDebug("image cached successfully")
        }
    }
    
}

extension UIButton {
    
    /// Method to add right image with offset
    ///
    /// - Parameter image: UIImage to set in button image.
    /// - Parameter offset: CGFloat space beetwen image and title.
    func addRightImage(image: UIImage?, offset: CGFloat) {
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
    
    /// Method to add left image on button
    ///
    /// - Parameter image: UIImage to set in button image.
    func adjustLeftImage(image: UIImage) {
        self.tintColor = .white
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (self.center.x/4)-10, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .center
    }
    
    
    ///  Method to add shadow on button
    /// - Parameter cornerRadius: CGFloat corner radius to apply on view.
    /// - Parameter color: UIColor to set in button title color.
    /// - Parameter offset: CGSize shadow size.
    /// - Parameter opacity: Float opacity of radius.
    /// - Parameter shadowRadius: CGFloat radius of shadow.
    func addShadowOnButton(cornerRadius: CGFloat? = nil, color: UIColor = AppColors.gray, offset: CGSize = CGSize.init(width: 1.0, height: 1.0), opacity: Float = 1.0, shadowRadius: CGFloat = 7.0) {
        let _cornerRadius = cornerRadius.isNil ? self.frame.height/2 : (cornerRadius ?? CGFloat.zero)
        self.addShadow(cornerRadius: _cornerRadius, color: color, offset: offset, opacity: opacity, shadowRadius: shadowRadius)
    }
    
    /// Method to revere position Of the title and image
    ///
    func reverePositionOfTitleAndImage() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    /// Method to sets the styled title to use for the normal, highlighted and selected state.
    ///
    /// - Parameter title: NSAttributedString to set in button title.
    ///
    func setAttributedTitleAllMode(title: NSAttributedString?) {
        self.setAttributedTitle(title, for: .normal)
        self.setAttributedTitle(title, for: .highlighted)
        self.setAttributedTitle(title, for: .selected)
    }
    
    /// Method to sets the title to use for the normal, highlighted and selected state.
    ///
    /// - Parameter title: String to set in button title.
    ///
    func setTitleForAllMode(title: String?) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .selected)
        self.setTitle(title, for: .focused)
        self.setTitle(title, for: .application)
//        self.setTitle(title, for: .disabled)
    }
    
    /// Method to set the title color to use for the normal, highlighted and selected state
    ///
    /// - Parameter color: UIColor to set in button title color.
    ///
    func setTitleColorForAllMode(color: UIColor?) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
        self.setTitleColor(color, for: .selected)
        self.setTitleColor(color, for: .focused)
        self.setTitleColor(color, for: .application)
//        self.setTitleColor(color, for: .disabled)
    }
    
    /// Method to set the image to use for the normal, highlighted and selected state.
    ///
    /// - Parameter image: UIImage to set in button image.
    ///
    func setImageForAllMode(image: UIImage?) {
        self.setImage(image, for: .normal)
        self.setImage(image, for: .highlighted)
        self.setImage(image, for: .selected)
        self.setImage(image, for: .focused)
        self.setImage(image, for: .application)
//        self.setImage(image, for: .disabled)
    }
    
    func setFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }
}

