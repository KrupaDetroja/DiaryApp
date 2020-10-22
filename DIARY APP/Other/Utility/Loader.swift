
//
//  NSObject+Activity.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension NSObject {
    
    func showLoader() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        if appDelegate?.showLoader == true {
            UIApplication.shared.beginIgnoringInteractionEvents()
            let progress = MBProgressHUD.showAdded(to: (appDelegate?.window)!, animated: true)
            UIApplication.shared.endIgnoringInteractionEvents()
            progress.label.text = ""
        }
    }
    
    func hideloader() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        if appDelegate?.showLoader == true {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            MBProgressHUD.hide(for: (appDelegate?.window)!, animated: true)
        }
    }
    
}
