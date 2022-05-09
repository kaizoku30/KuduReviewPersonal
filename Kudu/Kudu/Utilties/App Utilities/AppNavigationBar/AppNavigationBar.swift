//
//  AppNavigationBar.swift
//  VIDA
//
//  Created by Admin on 17/01/22.
//

import UIKit

enum NavigationButtons {
    case vidaLogo
    case leftBackChevron
    case shareTxtButton
    case previewTxtButton
    case crossDismiss
    case experienceFilterHome
    case saveTxtButton
    case locSave
    case locPin
    case locLike
    case locShare
    case locUnlike
    case none
    case saveCoverImage
    case updateTextButton
}

class AppNavigationBar: UIView {

    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var fourthRightImgButton: AppButton!
    @IBOutlet weak var thirdRightImgButton: AppButton!
    @IBOutlet weak var secondRightImgButton: AppButton!
    @IBOutlet weak var firstRightImgButton: AppButton!
    @IBOutlet weak var firstLeftButtonContainerView: UIView!
    @IBOutlet weak var secondBtnContainerView: UIView!
    @IBOutlet weak var firstBtnContainerView: UIView!
    @IBOutlet weak var firstLeftButton: AppButton!
    @IBOutlet weak var firstRightButton: AppButton!
    @IBOutlet weak var secondRightButton: AppButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthFirstIcon: NSLayoutConstraint!
    
    var navigationItemPressed:((NavigationButtons)->())?
    
    var title:String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleFont:UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var buttons:[NavigationButtons] = [.vidaLogo] {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
        
     }
     
     required init?(coder adecoder: NSCoder) {
         super.init(coder: adecoder)
         commonInit()
     }
}

extension AppNavigationBar
{
    private func commonInit()
    {
        Bundle.main.loadNibNamed("AppNavigationBar", owner: self, options: nil)
        addSubview(mainContentView)
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //firstLeftButton.isUserInteractionEnabled = false
    }
    
    private func updateUI()
    {
        
        [firstRightImgButton,secondRightImgButton,thirdRightImgButton,fourthRightImgButton,firstRightButton,secondRightButton].forEach({$0?.isHidden = true})
        buttons.iteratorFunction({
            [weak self] (index) in
                
            guard let `self` = self else { return }
            
            switch index
            {
            case 0:
                self.setButton(type: self.buttons[0], buttonOutlet: self.firstLeftButton,container: firstLeftButtonContainerView)
            case self.buttons.count - 1 :
                self.setButton(type: self.buttons[self.buttons.count - 1], buttonOutlet: self.firstRightButton,container: firstBtnContainerView)
            case self.buttons.count - 2 :
                self.setButton(type: self.buttons[self.buttons.count - 2], buttonOutlet: self.secondRightButton,container: secondBtnContainerView)
            case self.buttons.count - 3 :
                self.setButton(type: self.buttons[self.buttons.count - 3], buttonOutlet: self.thirdRightImgButton)
            case self.buttons.count - 4 :
                self.setButton(type: self.buttons[self.buttons.count - 4], buttonOutlet: self.fourthRightImgButton)
            default:
                break
            }
        })
        
        
    }
    
    private func setButton(type:NavigationButtons,buttonOutlet:AppButton, container:UIView? = nil)
    {
        widthFirstIcon.constant = 40
        buttonOutlet.isHidden = false
        buttonOutlet.alpha = 1
        buttonOutlet.layer.cornerRadius = 0
        container?.gestureRecognizers?.forEach({
            container?.removeGestureRecognizer($0)
        })
        switch type {
         
        case .locSave:
            buttonOutlet.isHidden = true
            fourthRightImgButton.alpha = 1
            fourthRightImgButton.isHidden = false
            fourthRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.locSave)
            }
          //  fourthRightImgButton.setImageForAllMode(image: AppImages.LocDetailNav.save)
            fourthRightImgButton.cornerRadius = 20
            //fourthRightImgButton.backgroundColor = AppColors.roundButtonBgColor
        case .locPin:
            buttonOutlet.isHidden = true
            thirdRightImgButton.alpha = 1
            thirdRightImgButton.isHidden = false
            thirdRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.locPin)
            }
         //   thirdRightImgButton.setImageForAllMode(image: AppImages.LocDetailNav.pin)
            thirdRightImgButton.cornerRadius = 20
          //  thirdRightImgButton.backgroundColor = AppColors.roundButtonBgColor
        case .locShare:
            buttonOutlet.isHidden = true
            firstRightImgButton.alpha = 1
            firstRightImgButton.isHidden = false
            firstRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.locShare)
            }
         //   firstRightImgButton.setImageForAllMode(image: AppImages.LocDetailNav.share)
            firstRightImgButton.cornerRadius = 20
         //   firstRightImgButton.backgroundColor = AppColors.roundButtonBgColor
            
        case .locUnlike:
            buttonOutlet.isHidden = true
            secondRightImgButton.alpha = 1
            secondRightImgButton.isHidden = false
            secondRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.locUnlike)
            }
          //  secondRightImgButton.setImageForAllMode(image: AppImages.LocDetailNav.unlike)
            secondRightImgButton.cornerRadius = 20
        //    secondRightImgButton.backgroundColor = AppColors.roundButtonBgColor
            
        case .locLike:
            buttonOutlet.isHidden = true
            figmaShadowForRoundNavButtons(toView: secondRightImgButton)
            secondRightImgButton.alpha = 1
            secondRightImgButton.isHidden = false
            secondRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.locLike)
            }
        //    secondRightImgButton.setImageForAllMode(image: AppImages.Home.like)
            secondRightImgButton.cornerRadius = 20
        //    secondRightImgButton.backgroundColor = AppColors.roundButtonBgColor
            
        case .experienceFilterHome:
            buttonOutlet.isHidden = true
            figmaShadowForRoundNavButtons(toView: firstRightImgButton)
            firstRightImgButton.alpha = 1
            firstRightImgButton.isHidden = false
            firstRightImgButton.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.experienceFilterHome)
            }
            firstRightImgButton.backgroundColor = .white
        //    firstRightImgButton.setImageForAllMode(image: AppImages.NavBarImages.filterHomeNav)
        case .vidaLogo:
            buttonOutlet.setTitleForAllMode(title: "")
         //   buttonOutlet.setImageForAllMode(image: AppImages.NavBarImages.vidLogoNavLarge)
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.vidaLogo)
            }
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vidaLogoPressed)))
        case .leftBackChevron:
            buttonOutlet.setTitleForAllMode(title: "")
         //   buttonOutlet.setImageForAllMode(image: AppImages.MainImages.leftBackChevron)
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.leftBackChevron)
            }
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftChevronPressed)))
        case .none:
            widthFirstIcon.constant = 0
            buttonOutlet.isHidden = true
        case .crossDismiss:
            buttonOutlet.setTitleForAllMode(title: "")
          //  buttonOutlet.setImageForAllMode(image: AppImages.MainImages.blackCross)
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.crossDismiss)
            }
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(crossDismissPressed)))
        case .previewTxtButton:
            buttonOutlet.setImageForAllMode(image: nil)
            buttonOutlet.setTitleForAllMode(title: "Preview")
            buttonOutlet.backgroundColor = .clear
        //    buttonOutlet.setTitleColorForAllMode(color: AppColors.themeBlackTextColor)
            
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previewTextPressed)))
            
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.previewTxtButton)
            }
        case .shareTxtButton:
            buttonOutlet.setImageForAllMode(image: nil)
            buttonOutlet.setTitleForAllMode(title: CommonStrings.whiteSpacex4 + "Share" + CommonStrings.whiteSpacex4)
         //   buttonOutlet.backgroundColor = AppColors.selectedLightGreen
            buttonOutlet.layer.cornerRadius = buttonOutlet.height/2
         //   buttonOutlet.setTitleColorForAllMode(color: AppColors.themeBlackTextColor)
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareTextPressed)))
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.shareTxtButton)
            }
        case .updateTextButton:
            buttonOutlet.setImageForAllMode(image: nil)
            buttonOutlet.setTitleForAllMode(title: CommonStrings.whiteSpacex4 + "Update" + CommonStrings.whiteSpacex4)
      //      buttonOutlet.backgroundColor = AppColors.selectedLightGreen
            buttonOutlet.layer.cornerRadius = buttonOutlet.height/2
        //    buttonOutlet.setTitleColorForAllMode(color: AppColors.themeBlackTextColor)
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareTextPressed)))
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.shareTxtButton)
            }
            
        case .saveTxtButton:
            buttonOutlet.setImageForAllMode(image: nil)
            buttonOutlet.setTitleForAllMode(title: CommonStrings.whiteSpacex4 + "Save" + CommonStrings.whiteSpacex4)
          //  buttonOutlet.backgroundColor = AppColors.selectedLightGreen
            buttonOutlet.layer.cornerRadius = buttonOutlet.height/2
        //    buttonOutlet.setTitleColorForAllMode(color: AppColors.themeBlackTextColor)
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveTextPressed)))
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.saveTxtButton)
            }
            
        case .saveCoverImage:
            buttonOutlet.setImageForAllMode(image: nil)
            buttonOutlet.setTitleForAllMode(title: CommonStrings.whiteSpacex4 + "Save" + CommonStrings.whiteSpacex4)
         //   buttonOutlet.backgroundColor = AppColors.selectedLightGreen
            buttonOutlet.layer.cornerRadius = buttonOutlet.height/2
      //      buttonOutlet.setTitleColorForAllMode(color: AppColors.themeBlackTextColor)
            container?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveCoverImagePressed)))
            buttonOutlet.handleBtnTap = {
                [weak self] in
                self?.navigationItemPressed?(.saveCoverImage)
            }
        
        }
    }
}

extension AppNavigationBar{
    
    @objc func previewTextPressed(){
        self.navigationItemPressed?(.previewTxtButton)
    }
    
    @objc func shareTextPressed(){
        self.navigationItemPressed?(.shareTxtButton)
    }
    
    @objc func saveTextPressed(){
        self.navigationItemPressed?(.saveTxtButton)
    }
    
    @objc func vidaLogoPressed()
    {
        self.navigationItemPressed?(.vidaLogo)
    }
    
    @objc func crossDismissPressed()
    {
        self.navigationItemPressed?(.crossDismiss)
    }
    
    @objc func leftChevronPressed()
    {
        self.navigationItemPressed?(.leftBackChevron)
    }
    
    @objc func saveCoverImagePressed()
    {
        self.navigationItemPressed?(.saveCoverImage)
    }
}

extension AppNavigationBar
{
    func figmaShadowForRoundNavButtons(toView imageView:UIView)
    {
        imageView.layer.shadowRadius = 20
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).cgPath
        imageView.layer.masksToBounds = false
    }
}
