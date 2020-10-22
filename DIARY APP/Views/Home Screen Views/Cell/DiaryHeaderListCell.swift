//
//  DiaryHeaderListCell.swift
//  DIARY APP
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit

class DiaryHeaderListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        lblHeaderTitle.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 14.0)
        lblHeaderTitle.textColor = COLORS.LBL_TABLE_HEADER_COLOR
    }
}
