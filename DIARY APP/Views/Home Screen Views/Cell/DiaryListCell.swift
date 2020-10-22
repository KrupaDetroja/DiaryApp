//
//  DiaryListCell.swift
//  DIARY APP
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialRipple

class DiaryListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblDiaryTitle: UILabel!
    @IBOutlet weak var lblDiaryDetail: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var vwMainBG: UIView!
    
    // MARK: - Variables
    var handleDeleted: () -> Void = {}
    var handleEdit: () -> Void = {}
    var rippleEdit: MDCRippleTouchController?
    var rippleDelete: MDCRippleTouchController?
    
    // MARK: - Outlets
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Set UI
    func setupCellData(obj : NotesObjectClass) {
        self.lblDiaryTitle.text = obj.notesTitle
        self.lblDiaryDetail.text = obj.notesContent
        self.lblTime.text = obj.date.timeAgoSinceNow()
    }
    
    private func setupUI() {
        self.btnDelete.cornerRadius = self.btnDelete.height / 2
        lblDiaryTitle.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 15.0)
        lblDiaryDetail.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 14.0)
        lblTime.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 14.0)
        btnEdit.titleLabel?.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 12.0)
        lblDiaryTitle.textColor = COLORS.LBL_BLACK_COLORR
        lblDiaryDetail.textColor = COLORS.LBL_TABLE_HEADER_COLOR
        lblTime.textColor = COLORS.LBL_LIGHT_COLOR
        btnEdit.setTitleColor(UIColor(displayP3Red: 68.0/255.0, green: 33.0/255.0, blue: 164.0/255.0, alpha: 1.0), for: .normal)
        btnDelete.backgroundColor = UIColor(displayP3Red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        rippleEdit = MDCRippleTouchController(view: btnEdit)
        rippleEdit?.rippleView.rippleColor = UIColor.black.withAlphaComponent(0.2)
        rippleDelete?.rippleView.cornerRadius = 5.0
        rippleDelete = MDCRippleTouchController(view: btnDelete)
        rippleDelete?.rippleView.rippleColor = UIColor.black.withAlphaComponent(0.2)
        rippleDelete?.rippleView.cornerRadius = self.btnDelete.height / 2
    }
    
    @IBAction func btnDelete_Clicked(sender: UIButton) {
        self.handleDeleted()
    }
    
    @IBAction func btnEdit_Clicked(sender: UIButton) {
        self.handleEdit()
    }
}
