//
//  AppConstant.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import Foundation
import UIKit

let BASE_URL = "https://private-ba0842-gary23.apiary-mock.com/"
let BASE_NOTES = "notes"
let APP_DELEGATE = (UIApplication.shared.delegate as! AppDelegate)
let KSCREEN_WIDTH : CGFloat = UIScreen.main.bounds.width
let KSCREEN_HEIGHT : CGFloat = UIScreen.main.bounds.height
let SHADOW_OPACITY : Double = 0.4

struct FONTS {
    static func FONT_SFUITEXT_LIGHT_WITHSIZE(size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Light", size: size)!
    }
    static func FONT_SFUITEXT_REGULAR_WITHSIZE(size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Medium", size: size)!
    }
    static func FONT_SFUITEXT_MEDIUM_WITHSIZE(size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: size)!
    }
    static func FONT_SFUITEXT_BOLD_WITHSIZE(size: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Bold", size: size)!
    }
}

struct COLORS {

    static let SHADOW_COLOR: UIColor  = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 0.3)
    static let BTN_BLUE_TITLE_COLOR: UIColor = UIColor.white
    static let BTN_BLUE_BG_COLOR: UIColor = UIColor(red: 68.0/255.0, green: 33.0/255.0, blue: 164.0/255.0, alpha: 1)
    static let LBL_DARK_COLOR: UIColor = UIColor(displayP3Red: 155.0/255.0, green: 158.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    static let LBL_LIGHT_COLOR: UIColor = UIColor(displayP3Red: 192.0/255.0, green: 193.0/255.0, blue: 195.0/255.0, alpha: 1.0)
    static let LBL_BLACK_COLORR: UIColor = UIColor.black
    static let LBL_TABLE_HEADER_COLOR: UIColor = UIColor(displayP3Red: 116.0/255.0, green: 121.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    static let NAV_BAR_TITLE_COLORR: UIColor = UIColor.black
    static let NAV_BG_COLOR: UIColor = UIColor.white
    static let PLACEHOLDER_COLOR: UIColor = UIColor(displayP3Red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
    static let snackBarColorSuccess  = UIColor.black
    static let snackBarColorFailure =   UIColor(red: 200.0/255.0, green: 09.0/255.0, blue: 09.0/255.0, alpha: 1.0)
    static let snackBarColorWarning = UIColor(red: 200.0/255.0, green: 162.0/255.0, blue: 09.0/255.0, alpha: 1.0)
    static let snackBarColorInfo = UIColor(red: 42.0/255.0, green: 120.0/255.0, blue: 149.0/255.0, alpha: 1.0)
}

enum Identifiers {
    struct Storyboard {
        static let MAIN = "Main"
    }
}

struct STORYBOARD {
    static let MAIN_STORYBOARD = UIStoryboard(name: Identifiers.Storyboard.MAIN, bundle: nil)
}
