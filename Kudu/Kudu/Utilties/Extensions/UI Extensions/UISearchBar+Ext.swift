

import UIKit

//UISearch bar extension
extension UISearchBar {

    func removeSearchIcon() {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.leftView = nil
        sc.leftViewMode = .never
    }

    func setTextFieldFont(font: UIFont) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.font = font
    }

    func setTextFieldTextColor(color: UIColor) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.textColor = color
    }
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }

    func setTextFieldBackgroundColor(color: UIColor) {
        guard let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField else {return}
        textFieldInsideSearchBar.backgroundColor = color
    }
}

extension UISearchBar {
    func setSearchTextField(height: CGFloat, radius: CGFloat = 12.0) {
        let image = UIImage.getImageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        if #available(iOS 13.0, *) {
            self.searchTextField.layer.cornerRadius = radius
            self.searchTextField.clipsToBounds = true
        } else {
            if let textField = self.textField {
                textField.layer.cornerRadius = radius
                textField.clipsToBounds = true
            }
        }
    }
}

extension UISearchBar {
    var textField: UITextField? {
        func findInView(_ view: UIView) -> UITextField? {
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    return textField
                }
                else if let v = findInView(subview) {
                    return v
                }
            }
            return nil
        }
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        else {
            return findInView(self)
        }
    }
}


extension UISearchBar {
    
    func setText(color: UIColor) { if let textField = self.getTextField() { textField.textColor = color } }
    func setPlaceholderText(color: UIColor) { self.getTextField()?.setPlaceholderText(color: color) }
    func setClearButton(color: UIColor) { self.getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = self.getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    
    func setAttributedPlaceholderText(placeHolderText: String = "Search" ,color: UIColor = AppColors.black, font: UIFont = AppFonts.themeFont.withSize(17.0)) {
        guard let textField = self.getTextField() else { return }
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.font: font,.foregroundColor: color])
    }

    
    func setSearchImage(color: UIColor, searchIcon: UIImage? = nil) {
        guard let imageView = self.getTextField()?.leftView as? UIImageView else { return }
        if let image = searchIcon {
//            imageView.tintColor = color
            imageView.size = CGSize(width: 32.0, height: 32.0)
            imageView.image = image
        } else {
            imageView.tintColor = color
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func changeFrameOfTecxtField(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let textfield = self.getTextField()
        textfield?.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}
