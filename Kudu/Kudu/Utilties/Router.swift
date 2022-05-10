//
//  Router.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import UIKit

class Router: NSObject {
    
    static let shared = Router()
    var mainNavigation:BaseNavVC?
    var appWindow: UIWindow? {
        var window: UIWindow?
        window = SceneDelegate.shared?.window
        #if DEBUG
        if window.isNil {
            fatalError("UIWindow is not found!")
        }
        #endif
        return window
    }
    
    private override init()
    {
        //Private Init for Singleton Pattern
    }
}
