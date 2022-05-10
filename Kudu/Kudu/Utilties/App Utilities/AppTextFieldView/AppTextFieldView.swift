//
//  AppTextFieldView.swift
//  VIDA
//
//  Created by Admin on 05/01/22.
//

import UIKit
import IQKeyboardManagerSwift

enum AppTextFieldType {
    case email
    case userName
    case password
    case name
}

enum AppTextFieldUIType {
    case plain
    case roundedWithBorder
}

class AppTextFieldView: UIView {
    
    
    @IBOutlet weak var txtFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldClearBtn: AppButton!
    @IBOutlet weak var txtFieldShowPasswordBtn: AppButton!
    
    var currentText:String {
        txtField.text ?? ""
    }
    
    var placeholderText:String {
        didSet {
            txtField.placeholder = placeholderText
        }
    }

    var textFieldClearBtnPressed:(()->())?
    var textFieldDidChangeCharacters:((String?)->())?
    var textFieldFinishedEditing:((String?)->())?
    
    var disableTextField:Bool? = nil {
        didSet {
            setTextFieldEnabled()
        }
    }
    
    var font:UIFont? {
        didSet {
            self.txtField.font = font
        }
    }
    var textFieldType:AppTextFieldType {
        didSet
        {
            configureTF()
        }
    }
    var textFieldUI:AppTextFieldUIType {
        didSet {
            configureTF()
        }
    }
    var validInputEntered:Bool {
        get {
            switch textFieldType {
            case .email:
                return CommonValidation.isValidEmail(txtField.text ?? "")
            case .password:
                return CommonValidation.isValidPassword(currentText)
            case .userName:
                return CommonValidation.isValidUsername(currentText)
            case .name:
                return true
            }
        }
    }
    private var lastEnteredCharacter = ""
    
    override init(frame: CGRect) {
         placeholderText = ""
         textFieldType = .email
         textFieldUI = .plain
         super.init(frame: frame)
         commonInit()
        
     }
     
     required init?(coder adecoder: NSCoder) {
         placeholderText = ""
         textFieldType = .email
         textFieldUI = .plain
         super.init(coder: adecoder)
         commonInit()
     }

}

extension AppTextFieldView
{
    private func commonInit()
    {
        Bundle.main.loadNibNamed("AppTextFieldView", owner: self, options: nil)
        addSubview(mainContentView)
        mainContentView.frame = self.bounds
        mainContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        txtField.delegate = self
        txtField.textContentType = UITextContentType(rawValue: "")
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        txtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtField.spellCheckingType = .no
        txtField.tintColor = AppColors.darkGray
        configureTF()
        
    }
    
    func setTextFieldEnabled()
    {
        if self.disableTextField ?? false
        {
            self.isUserInteractionEnabled = false
            self.backgroundColor = AppColors.gray
            txtField.attributedPlaceholder = NSAttributedString(
                string: txtField.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
        else
        {
            self.isUserInteractionEnabled = true
            self.backgroundColor = .clear
            txtField.attributedPlaceholder = NSAttributedString(
                string: txtField.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    func configureTF()
    {
        switch textFieldType
        {
        case .email:
            
            //txtField.placeholder = LS.Placeholder.email
            txtField.keyboardType = .emailAddress
            
        case.userName:
           // txtField.placeholder = LS.Placeholder.username
            txtField.keyboardType = .asciiCapable
        case .password:
         //   txtField.placeholder = LS.Placeholder.password
            txtField.keyboardType = .asciiCapable
            txtField.isSecureTextEntry = true
            txtFieldShowPasswordBtn.isHidden = false
        case .name:
         //   txtField.placeholder = LS.Placeholder.name
            txtField.keyboardType = .alphabet
        }
        switch textFieldUI
        {
        case .plain:
            break
        case .roundedWithBorder:
            setUpRoundedTFWithBorder()
        }
    }
    
    func setUpRoundedTFWithBorder()
    {
        txtFieldTopConstraint.constant = 10
        txtFieldLeftConstraint.constant = 10
        txtFieldBottomConstraint.constant = 10
        self.layer.borderColor = AppColors.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layoutIfNeeded()
    }
    
}

extension AppTextFieldView:UITextFieldDelegate
{
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textFieldType
        {
        case .email:
            textField.text = textField.text?.lowercased()
        case .name:
            if currentText.contains(".")
            {
                textField.text = currentText.replacingOccurrences(of: ".", with: "")
            }
        case .userName:
            textField.text = textField.text?.lowercased()
        case .password:
            break
        }
        
        textFieldDidChangeCharacters?(textField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        debugPrint("Textfield selected")
        CommonFunctions.hideToast()
        switch textFieldType
        {
        case .email,.name,.userName:
            txtFieldClearBtn.isHidden = false
        case .password:
            break
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        switch textFieldType
        {
        case .email:
            return string != CommonStrings.whiteSpace && !newString.contains(CommonStrings.whiteSpace) && !string.isEmojiString()
        case .userName:
            return self.validateUserNameTextField(newString, string)
        case .password:
            if newString.count > 16 || string == CommonStrings.whiteSpace || newString.contains(CommonStrings.whiteSpace) || string.isEmojiString()
            {
                return false
            }
            return true
        case .name:
            return self.validateNameTextField(newString, string)
        }
    }
    
    private func validateUserNameTextField(_ newString:String,_ string:String)->Bool
    {
        let alphaNumericCharacter = CharacterSet.alphanumerics
        let specialCharsAllows = CharacterSet(charactersIn: "._")
        let allAllowedUsernameChars = alphaNumericCharacter.union(specialCharsAllows)
        let enteredCharacterSet = CharacterSet(charactersIn: newString)
        if !enteredCharacterSet.isSubset(of: allAllowedUsernameChars)
        {
            return false
        }
        if newString.count > 15 || string == CommonStrings.whiteSpace || newString.contains(CommonStrings.whiteSpace) || string.isEmojiString()
        {
            return false
        }
        return true
    }
    
    private func validateNameTextField(_ newString:String,_ string:String)->Bool
    {
        let alphabetSet = CharacterSet.letters
        let allowedSet = alphabetSet.union(CharacterSet(charactersIn: CommonStrings.whiteSpace))
        let enteredSet = CharacterSet(charactersIn: newString)
        
        if currentText == CommonStrings.emptyString && string == CommonStrings.whiteSpace
        {
            return false
        }
        
        if newString.count > 20 || (string == CommonStrings.whiteSpace && lastEnteredCharacter == CommonStrings.whiteSpace) || string.isEmojiString()
        {
            return false
        }
        if !enteredSet.isSubset(of: allowedSet)
        {
            return false
        }
        lastEnteredCharacter = string
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtFieldClearBtn.isHidden = true
        switch textFieldType
        {
        case .email:
            debugPrint("Valid email :\(CommonValidation.isValidEmail(textField.text ?? ""))")
        case .userName,.password,.name:
            debugPrint("Valid?")
        }
        textFieldFinishedEditing?(textField.text)
    }
}


extension AppTextFieldView
{
    @IBAction func clearBtnPressed(_ sender: Any) {
        txtField.resignFirstResponder()
        txtField.text = ""
        textFieldDidChangeCharacters?(txtField.text)
    }
    
    func resetShowPasswordBtnState()
    {
        if self.textFieldType == .password
        {
            txtField.isSecureTextEntry = true
           // txtFieldShowPasswordBtn.setImageForAllMode(image: AppImages.PasswordTF.showPassword)
        }
        
    }
    
    @IBAction func showPasswordBtnTapped(_ sender: Any) {
        txtField.isSecureTextEntry = !txtField.isSecureTextEntry
        switch txtField.isSecureTextEntry
        {
        case true:
            debugPrint("show password")
           // txtFieldShowPasswordBtn.setImageForAllMode(image: AppImages.PasswordTF.showPassword)
        case false:
            debugPrint("hide password")
            //txtFieldShowPasswordBtn.setImageForAllMode(image: AppImages.PasswordTF.hidePassword)
        }
    }
}



