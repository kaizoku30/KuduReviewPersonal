//
//  AppUserDefaults.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import Foundation
import SwiftyJSON

class AppUserDefaults {
    
    static func jsonValue(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults for key \(key.rawValue)")
            
            return JSON.null
        }
        
        return JSON(value)
    }
    
    static func value(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> Any? {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults for key \(key.rawValue)")
            
            return nil
        }
        
        return value
    }
    
    static func value(forUniqueKey key: String,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> Any? {
        
        guard let value = UserDefaults.standard.object(forKey: key) else {
            
            debugPrint("No Value Found in UserDefaults for key \(key)")
            
            return nil
        }
        
        return value
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func saveWithUniqueKey(value : Any, forKey key : String) {
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forUniqueKey key : String) {
        
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}

extension AppUserDefaults {
    
    enum Key : String {
        case selectedLanguage
        case pendingAWSRequests
    }
    
}
