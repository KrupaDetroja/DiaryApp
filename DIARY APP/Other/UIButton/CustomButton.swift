//
//  CustomButton.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialRipple

class CustomButton: UIButton {
    var rippleTouchController: MDCRippleTouchController?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = COLORS.BTN_BLUE_BG_COLOR
        self.titleLabel?.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 12.0)
        self.setTitleColor(COLORS.BTN_BLUE_TITLE_COLOR, for: .normal)
        self.cornerRadius = 5.0
        
        rippleTouchController = MDCRippleTouchController(view: self)
        rippleTouchController?.rippleView.rippleColor = UIColor.white.withAlphaComponent(0.3)
        rippleTouchController?.rippleView.cornerRadius = 5.0
    }

}
