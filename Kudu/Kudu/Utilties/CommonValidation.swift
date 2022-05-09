//
//  CommonValidation.swift
//  Kudu
//
//  Created by Admin on 05/05/22.
//

import Foundation

final class CommonValidation {
    static func isValidName(_ name:String) -> Bool
    {
        let alphabetSet = CharacterSet.letters
        let allowedSet = alphabetSet.union(CharacterSet(charactersIn: CommonStrings.whiteSpace))
        let enteredSet = CharacterSet(charactersIn: name)
        
        if !enteredSet.isSubset(of: allowedSet)
        {
            return false
        }
        
        if name.count < 3 || name.count > 20
        {
            return false
        }
        
        return true
    }
    
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUsername(_ userName:String)->Bool
    {
        let lowecaseLetter = CharacterSet.lowercaseLetters
        let numbers = CharacterSet.decimalDigits
        let specialCharsAllows = CharacterSet(charactersIn: "._")
        let allAllowedUsernameChars = lowecaseLetter.union(specialCharsAllows.union(numbers))
        let enteredCharacterSet = CharacterSet(charactersIn: userName)
        if !enteredCharacterSet.isSubset(of: allAllowedUsernameChars) || userName.count < 3 || userName.count > 15 || userName.contains(CommonStrings.whiteSpace)
        {
            return false
        }
        
        return true
    }
    
    static func isValidPassword(_ password:String)->Bool
    {
        let enteredCharacterSet = CharacterSet(charactersIn: password)
        
        if password.count < 8 || password.count > 16
        {
            return false
        }
        
        let capsCharSet = CharacterSet.uppercaseLetters
        
        let lowerCaseCharSet = CharacterSet.lowercaseLetters
        
        let numbers = CharacterSet(charactersIn: "1234567890")
        
        let specialChars = CharacterSet(charactersIn: ".*[!&^%$#@()/]+.*")
        
        
        if enteredCharacterSet.intersection(capsCharSet).isEmpty
        {
            return false
        }
        
        if enteredCharacterSet.intersection(lowerCaseCharSet).isEmpty
        {
            return false
        }
        
        if enteredCharacterSet.intersection(numbers).isEmpty
        {
            return false
        }
        
        if enteredCharacterSet.intersection(specialChars).isEmpty
        {
            return false
        }
        
        return true
    }
}
