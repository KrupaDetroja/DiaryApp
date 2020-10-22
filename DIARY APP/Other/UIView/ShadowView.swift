//
//  CellShadowView.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.cornerRadius = 5.0
        self.shadowColor = COLORS.SHADOW_COLOR
        self.shadowOffset = CGSize(width: 0, height:4)
        self.shadowOpacity = 0.5
        self.shadowRadius = 8
        
    }

}
