//
//  EditNotesViewController.swift
//  DIARY APP
//
//  Created by Krupa Detroja on 21/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
protocol EditNotesViewControllerDelegate {
    func callBackEditSuccessfully()
}

class EditNotesViewController: UIViewController {
    
    // MARK: - InitiateController Controller
    class func initiateController() -> EditNotesViewController {
        let controller  = STORYBOARD.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "EditNotesViewController") as! EditNotesViewController
        return controller
    }
    
    // MARK: - Outlets
    @IBOutlet weak var lblDairyTitle: UILabel!
    @IBOutlet weak var txtDairyTitle: UITextField!
    @IBOutlet weak var lblDairyContent: UILabel!
    @IBOutlet weak var txtDairyContent: UITextView!
    @IBOutlet weak var btnUpdate: CustomButton!
    @IBOutlet weak var constraintTxtDairtContentHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var objNotes : NotesObjectClass? = nil
    var delegate:EditNotesViewControllerDelegate?
    
    // MARK: - View Life Cycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitUI()
        self.setInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    // MARK: - Private Function
    private func setInitUI() {
        self.setColor()
        self.setFont()
        self.lblDairyTitle.text = "LOC_DIARY_TITLE".localized
        self.lblDairyContent.text = "LOC_DIARY_CONTENT".localized
    }
    private func setFont() {
        self.lblDairyTitle.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 12.0)
        self.lblDairyContent.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 12.0)
        self.txtDairyTitle.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 15.0)
        self.txtDairyContent.font = FONTS.FONT_SFUITEXT_REGULAR_WITHSIZE(size: 15.0)
    }
    private func setColor() {
        self.lblDairyTitle.textColor =  COLORS.LBL_DARK_COLOR
        self.lblDairyContent.textColor =  COLORS.LBL_DARK_COLOR
        self.txtDairyTitle.textColor =  COLORS.LBL_BLACK_COLORR
        self.txtDairyContent.textColor =  COLORS.LBL_BLACK_COLORR
    }
    
    private func setInitData() {
        self.txtDairyContent.text =  objNotes?.notesContent
        self.txtDairyTitle.text = objNotes?.notesTitle
        setDiaryContentHeight()
    }
    private func setNavigationBar() {
        self.setupNavigationBar(vc: self, isHide: false)
        self.setBackButton(vc: self)
        self.title = objNotes?.notesTitle
    }
    private func setDiaryContentHeight() {
        txtDairyTitle.sizeToFit()
        let newSize = txtDairyContent.sizeThatFits(CGSize(width: KSCREEN_WIDTH - 48 , height: CGFloat.greatestFiniteMagnitude))
        
        constraintTxtDairtContentHeight.constant = newSize.height
    }
    // MARK: - UIButton Action Function
    @IBAction func btnUpdate_Clicked(sender: UIButton) {
        self.view.endEditing(true)
        if (self.txtDairyTitle.text?.trimString().isEmpty)! {
            self.showSnackBarAlert(message: "Please enter the diary title", type: .Failure)
        } else if (self.txtDairyContent.text?.trimString().isEmpty)! {
            self.showSnackBarAlert(message: "Please enter the diary content", type: .Failure)
        } else {
            self.showLoader()
            let newNote = NotesObjectClass(notesId: objNotes!.notesId, notesTitle: self.txtDairyTitle.text!, notesContent: self.txtDairyContent.text!,strDate: objNotes!.strDate, date: objNotes!.date)
            RealmDb.shared.updateNotes(objNotes: newNote)
            if(self.delegate != nil) {
                self.delegate?.callBackEditSuccessfully()
            }
            self.showSnackBarAlert(message: "Updated successfully.", type: .Success,duration: .short)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideloader()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EditNotesViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        setDiaryContentHeight()
    }
}
