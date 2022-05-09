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
    case locationName
    case elasticSearch
    case listName
    case userNameEmail
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
   // var textFieldDidBeginEditing:(()->())?
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
            case .name,.locationName,.listName,.elasticSearch,.userNameEmail:
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
        case .locationName:
          //  txtField.placeholder = LS.Placeholder.searchLocation
            txtField.keyboardType = .asciiCapable
        case .elasticSearch:
            txtField.placeholder = "Type to search..."
            txtField.keyboardType = .asciiCapable
        case .listName:
            txtField.placeholder = "Listname"
            txtField.keyboardType = .asciiCapable
        case .userNameEmail:
            txtField.placeholder = "Username/Email"
            txtField.keyboardType = .asciiCapable
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
        case .email,.userNameEmail:
            textField.text = textField.text?.lowercased()
        case .name,.locationName,.listName,.elasticSearch:
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
        case .email,.name,.userName,.locationName,.elasticSearch,.listName,.userNameEmail:
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
        case .userNameEmail:
            let alphaNumericCharacter = CharacterSet.alphanumerics
            let specialCharsAllows = CharacterSet(charactersIn: "._@")
            let allAllowedUsernameChars = alphaNumericCharacter.union(specialCharsAllows)
            let enteredCharacterSet = CharacterSet(charactersIn: newString)
            if !enteredCharacterSet.isSubset(of: allAllowedUsernameChars)
            {
                return false
            }
            if string == CommonStrings.whiteSpace || newString.contains(CommonStrings.whiteSpace) || string.isEmojiString()
            {
                return false
            }
            return true
        case .userName:
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
        case .listName:
            let lastText = textField.text
            let lastCharacter = lastText?.last
            if lastCharacter ?? Character("t") == " " && text == " "
            {
                return false
            }
            if text == "\n" || textField.text?.count == 75
            {
                return false
            }
            if CharacterSet.init(charactersIn: string).isSubset(of: CharacterSet.whitespaces)
            {
                return true
            }
            return true
        case .password:
            if newString.count > 16 || string == CommonStrings.whiteSpace || newString.contains(CommonStrings.whiteSpace) || string.isEmojiString()
            {
                return false
            }
            return true
        case .name:
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
        case .locationName:
            let alphabetSet = CharacterSet.letters
            let allowedSet = alphabetSet.union(CharacterSet(charactersIn: CommonStrings.whiteSpace)).union(CharacterSet.decimalDigits)
            let enteredSet = CharacterSet(charactersIn: newString)
            
            if currentText == CommonStrings.emptyString && string == CommonStrings.whiteSpace
            {
                return false
            }
            
            if newString.count > 30 || (string == CommonStrings.whiteSpace && lastEnteredCharacter == CommonStrings.whiteSpace) || string.isEmojiString()
            {
                return false
            }
            if !enteredSet.isSubset(of: allowedSet)
            {
                return false
            }
            
            lastEnteredCharacter = string
            return true
        case .elasticSearch:
            let alphabetSet = CharacterSet.letters
            let allowedSet = alphabetSet.union(CharacterSet(charactersIn: CommonStrings.whiteSpace)).union(CharacterSet.decimalDigits)
            let enteredSet = CharacterSet(charactersIn: newString)
            
            if currentText == CommonStrings.emptyString && string == CommonStrings.whiteSpace
            {
                return false
            }
            
            if newString.count > 50 || (string == CommonStrings.whiteSpace && lastEnteredCharacter == CommonStrings.whiteSpace) || string.isEmojiString()
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
        
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtFieldClearBtn.isHidden = true
        switch textFieldType
        {
        case .email:
            debugPrint("Valid email :\(CommonValidation.isValidEmail(textField.text ?? ""))")
        case .userName,.password,.name,.locationName,.listName,.elasticSearch,.userNameEmail:
            break
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
            break
           // txtFieldShowPasswordBtn.setImageForAllMode(image: AppImages.PasswordTF.showPassword)
        case false:
            break
            //txtFieldShowPasswordBtn.setImageForAllMode(image: AppImages.PasswordTF.hidePassword)
        }
    }
}



