//
//  CustomNavigationBar.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit

extension UIViewController {
    
    open func setupNavigationBar(vc : UIViewController, isHide : Bool){
        vc.navigationController?.setNavigationBarHidden(isHide, animated: false)
    }
    
    open func setBackButton(vc : UIViewController) {
        let btnFilter = UIButton.init(type: .custom)
        btnFilter.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnFilter.setImage(UIImage(named: "nav_back_icon"), for: .normal)
        let barButtonRight = UIBarButtonItem(customView: btnFilter)
        btnFilter.addTarget(self, action: #selector(self.actionBack(sender:)), for: .touchUpInside)

        vc.navigationItem.leftBarButtonItem = barButtonRight
    }
  
    @IBAction func actionBack(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
