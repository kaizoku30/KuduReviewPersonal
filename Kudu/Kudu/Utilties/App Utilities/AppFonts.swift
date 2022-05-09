//
//  AppFonts.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import UIKit

enum AppFonts:String
{
    case themeFont = "PlayfairDisplay_Regular"
}

extension AppFonts
{
    func withSize(_ fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: self.rawValue, size: fontSize) {
            return font
        }
        else {
            printDebug("Font Not Found")
            return UIFont.systemFont(ofSize: fontSize)
        }
    }

    func withDefaultSize() -> UIFont {
        if let font = UIFont(name: self.rawValue, size: 15.0) {
            return font
        }
        else {
            printDebug("Font Not Found")
            return UIFont.systemFont(ofSize: 15.0)
        }
    }
}
