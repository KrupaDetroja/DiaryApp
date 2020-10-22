//
//  HomeScreenViewController.swift
//  DIARY APP
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import RealmSwift

class HomeScreenViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblDiaryList: UITableView!
    @IBOutlet weak var vwNodataFound: UIView!
    
    // MARK: - Variables
    var arrNotes : [Note] = []
    var notesList: Results<NotesObjectClass>! = nil
    var arrNotesFilter : [NotesObjectClass] = []
    var arrNoteDates = [Date]()
    var isPullToRefresh : Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitUI()
        notesList = RealmDb.shared.getNotesCodes()
        if (notesList.count < 1) {
            self.APIForgetNotesList()
        } else {
            self.loadNotes()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
}

extension HomeScreenViewController {
    
    // MARK: - Private Function
    private func setupNoDataView() {
        vwNodataFound.isHidden = true
        vwNodataFound.subviews.forEach { $0.removeFromSuperview() }
        let noDataView = Bundle.main.loadNibNamed("NoDataAvailableView", owner: self, options: nil)?.first as? NoDataAvailableView
        noDataView!.delegate = self
        vwNodataFound.addSubview(noDataView!)
        vwNodataFound.isHidden = false
        noDataView?.lblMessage.text = "No notes found"
        noDataView!.translatesAutoresizingMaskIntoConstraints = false
        noDataView!.topAnchor.constraint(equalTo: vwNodataFound.topAnchor, constant: 0).isActive = true
        noDataView!.leadingAnchor.constraint(equalTo: vwNodataFound.leadingAnchor, constant: 0).isActive = true
        noDataView!.trailingAnchor.constraint(equalTo: vwNodataFound.trailingAnchor, constant: 0).isActive = true
        noDataView!.bottomAnchor.constraint(equalTo: vwNodataFound.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setInitUI() {
        vwNodataFound.isHidden = true
        self.pullToRefreshView()
        tblDiaryList.estimatedRowHeight = 44.0
        tblDiaryList.rowHeight = UITableView.automaticDimension
    }
    
    private func setNavigationBar() {
        self.setupNavigationBar(vc: self, isHide: false)
        self.title = "LOC_MY_DIARY".localized
    }
    
    private func reloadTblDiaryList() {
        if (tblDiaryList.delegate == nil) {
            tblDiaryList.delegate = self
        }
        if (tblDiaryList.dataSource == nil) {
            tblDiaryList.dataSource = self
        }
        tblDiaryList.reloadData()
        if(notesList == nil) {
            setupNoDataView()
        } else if(notesList.count < 1) {
            setupNoDataView()
        } else {
            if (vwNodataFound != nil) {
                vwNodataFound.isHidden = true
            }
        }
    }
    
    func pullToRefreshView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        tblDiaryList.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.isPullToRefresh = true
            self?.APIForgetNotesList()
            }, loadingView: loadingView)
        tblDiaryList.dg_setPullToRefreshFillColor(UIColor.black)
        tblDiaryList.dg_setPullToRefreshBackgroundColor(tblDiaryList.backgroundColor!)
    }
    
    func loadNotes() {
        if (notesList != nil) {
            arrNoteDates.removeAll()
            arrNotesFilter.removeAll()
            arrNotesFilter = notesList.sorted(by: {$0.date.timeIntervalSince1970 >  $1.date.timeIntervalSince1970})
            for obj in arrNotesFilter {
                arrNoteDates.append(getDate(convertToDate: obj.date)!)
            }
            arrNoteDates = self.uniq(source:arrNoteDates)
            arrNoteDates = arrNoteDates.sorted(by: {$0.timeIntervalSince1970 > $1.timeIntervalSince1970})
        }
        reloadTblDiaryList()
    }
    
    // MARK: - InitiateController Controller
    class func initiateController() -> HomeScreenViewController {
        guard let controller: HomeScreenViewController  = STORYBOARD.MAIN_STORYBOARD.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController else {
            return HomeScreenViewController()
        }
        return controller
    }
    
    func deleteNotes(indexPath : IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        let firstView: UIView? = alertController.view.subviews.first
        let secView: UIView? = firstView?.subviews.first
        secView?.backgroundColor = UIColor(red: CGFloat(0.996), green: CGFloat(0.996), blue: CGFloat(0.980), alpha: CGFloat(1.00))
        secView?.layer.cornerRadius = 3.0
        alertController.view.tintColor = UIColor(red: CGFloat(0.49), green: CGFloat(0.03), blue: CGFloat(0.31), alpha: CGFloat(1.0))
        let actionOk = UIAlertAction(title: "Yes", style: .default, handler: { [self](_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
            let arrayNotes = self.arrNotesFilter.filter({getDate(convertToDate: $0.date)! == self.arrNoteDates[indexPath.section]})
            RealmDb.shared.deleteNotes(objNotes: arrayNotes[indexPath.row])
            self.showSnackBarAlert(message: "Note deleted successfully.", type: .Success,duration: .middle)
            self.loadNotes()
        })
        let actionNo = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(actionOk)
        alertController.addAction(actionNo)
        DispatchQueue.main.async(execute: {() -> Void in
            if !(self.presentedViewController is (UIAlertController)) {
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func editNotes(indexPath : IndexPath) {
        let arrayNotes = self.arrNotesFilter.filter({getDate(convertToDate: $0.date)! == self.arrNoteDates[indexPath.section]})
        let editNotesVC = EditNotesViewController.initiateController()
        editNotesVC.objNotes = arrayNotes[indexPath.row]
        editNotesVC.delegate = self
        self.navigationController?.pushViewController(editNotesVC, animated: true)
    }
}

extension HomeScreenViewController : EmptyDataDelegate{
    
    func actionRefresh() {
        self.APIForgetNotesList()
    }
}

// MARK: - TableView Delegate Methods
extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrNoteDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrayNotes =  arrNotesFilter.filter({ getDate(convertToDate: $0.date)!  == self.arrNoteDates[section]})
        return arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell: DiaryHeaderListCell  = tableView.dequeueReusableCell(withIdentifier: "DiaryHeaderListCell") as? DiaryHeaderListCell else {
            return UIView()
        }
        cell.lblHeaderTitle.text = dayDifference(from:self.arrNoteDates[section].timeIntervalSince1970)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListCell") as! DiaryListCell
        cell.selectionStyle = .none
        let arrayNotes = arrNotesFilter.filter({getDate(convertToDate: $0.date)! == self.arrNoteDates[indexPath.section]})
        cell.setupCellData(obj: arrayNotes[indexPath.row])
        cell.handleDeleted = { [weak self]  in
            self?.deleteNotes(indexPath: indexPath)
        }
        cell.handleEdit = { [weak self]  in
            self?.editNotes(indexPath: indexPath)
        }
        return cell
    }
}

extension HomeScreenViewController : EditNotesViewControllerDelegate {
    
    func callBackEditSuccessfully() {
        self.loadNotes()
    }
}

//MARK: - API Method
extension HomeScreenViewController {
    
    func APIForgetNotesList() {
        self.showLoader()
        APIManager.getAllNotestList(with: { [weak self](data, json, message, error) in
            DispatchQueue.main.async(execute: {() -> Void in
                self?.hideloader()
                self?.notesList = nil
                if error == nil {
                    if (json != nil) {
                        if ((data?.count)! > 0) {
                            do {
                                let decoder = JSONDecoder()
                                var arrNotes : [Note] = []
                                arrNotes = try decoder.decode([Note].self, from: data!)
                                RealmDb.shared.deleteAllNotes()
                                for objNote in  arrNotes {
                                    let newNote = NotesObjectClass(notesId: objNote.id, notesTitle: objNote.title, notesContent: objNote.content,strDate: objNote.date, date: loadFormatter(start:objNote.date))
                                    RealmDb.shared.addNewNotes(objNotes: newNote)
                                }
                                self?.notesList = RealmDb.shared.getNotesCodes()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                if (self!.isPullToRefresh) {
                    self?.tblDiaryList.dg_stopLoading()
                }
                self?.loadNotes()
            })
        })
    }
}
