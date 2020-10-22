//
//  NoTrainerAvailableView.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import Lottie

protocol EmptyDataDelegate:class{
    func actionRefresh()
}

class NoDataAvailableView: UIView {
    @IBOutlet weak var vwMainBg: UIView! {
        didSet {
            vwMainBg.layer.cornerRadius = 5
            vwMainBg.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnRefresh: CustomButton!
    @IBOutlet weak var vwAnimation: UIView!
    @IBOutlet weak var lblMessage: UILabel!

    weak var delegate : EmptyDataDelegate?
    var animationView : AnimationView!

    
    override func awakeFromNib(){
        super.awakeFromNib()
         self.setSuccessAnimation()
        self.lblMessage.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 14.0)
        self.lblMessage.textColor = COLORS.LBL_DARK_COLOR
    }
    override func layoutSubviews() {
       animationView.frame = CGRect(x: 0, y: 0, width: vwAnimation.width, height: vwAnimation.height)

    }
    func setSuccessAnimation(){
        let jsonName = "jsonData"
        let  animation = Animation.named(jsonName)
        
        // Load animation to AnimationView
        animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: vwAnimation.width, height: vwAnimation.height)
        animationView.backgroundColor = .clear
        // Add animationView as subview
        vwAnimation.addSubview(animationView)
        
        animationView.loopMode = .loop
        // Play the animation
        animationView.play()
        
    }
     @IBAction func refreshButton_clicked(_ sender: UIButton) {
        if(self.delegate != nil){
            self.delegate?.actionRefresh()
        }
    }
}
