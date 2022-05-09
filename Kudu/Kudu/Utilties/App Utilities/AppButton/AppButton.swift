//
//  AppBottomActionBtn.swift
//  VIDA
//
//  Created by Admin on 05/01/22.
//

import UIKit
import NVActivityIndicatorView

class AppButton: UIButton {

    var handleBtnTap:(()->())?
    private var enabledBgColor:UIColor = .clear
    private var enabledFontColor:UIColor = .clear
    private var activityIndicator:NVActivityIndicatorView?
    var isButtonHighlighted:Bool = false
    
    // MARK: Initializers
    //=====================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    // MARK: Life Cycle Functions
    //==============================
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayouts()
    }
    
    
    

    

}

extension AppButton
{
    private func setupSubviews() {
        self.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        enabledFontColor = self.titleLabel?.textColor ?? .clear
        enabledBgColor = self.backgroundColor ?? .clear
        activityIndicator = NVActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 25, height: 25) , type: .lineSpinFadeLoader, color: .white)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator!)
        activityIndicator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator?.stopAnimating()
    }
    
    private func setupLayouts() {
        //Set corner radius update here dynamically if needed
    }
}

extension AppButton
{
    func configureBtnUI(textColor:UIColor,bgColor:UIColor,opacity:CGFloat = 1.0)
    {
        self.backgroundColor = bgColor
        self.setTitleColorForAllMode(color: textColor)
        self.alpha = opacity
    }
    
    func enableBtn()
    {
        self.isUserInteractionEnabled = true
        self.backgroundColor = enabledBgColor
        self.setTitleColorForAllMode(color: enabledFontColor)
        self.alpha = 1.0
    }
    
    func disableBtn(_ opacity:CGFloat = 0.75,disabledBgColor:UIColor = .gray,disabledTxtColor:UIColor = .white)
    {
        self.configureBtnUI(textColor: disabledTxtColor, bgColor: disabledBgColor, opacity: opacity)
        self.isUserInteractionEnabled = false
    }
    
    func highlightButton(){
        self.isButtonHighlighted = true
        self.layer.borderWidth = 0
        self.backgroundColor = .yellow
    }
    
    func removeHighlightOnButton(){
        self.isButtonHighlighted = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .white
    }
}

extension AppButton
{
    @objc private func buttonAction(sender: UIButton!) {
       // debugPrint("AppActionButton tapped")
        handleBtnTap?()
    }
}

extension AppButton
{
    func startBtnLoader(color:UIColor = .white)
    {
        self.activityIndicator?.color = color
        self.activityIndicator?.startAnimating()
        self.setTitleColorForAllMode(color: .clear)
        self.isUserInteractionEnabled = false
    }
    
    func stopBtnLoader()
    {
        self.activityIndicator?.stopAnimating()
        self.setTitleColorForAllMode(color: enabledFontColor)
        self.isUserInteractionEnabled = true
    }
}
