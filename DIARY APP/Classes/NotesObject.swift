//
//  NotesObjectClass.swift
//  DIARY APP
//
//  Created by Krupa Detroja on 21/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class NotesObjectClass: Object {
    @objc dynamic var notesId: String = ""
    @objc dynamic var notesTitle: String = ""
    @objc dynamic var notesContent: String = ""
    @objc dynamic var strDate: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var uuid = UUID().uuidString
 
    convenience init(notesId: String,notesTitle: String,notesContent: String,strDate: String,date : Date) {
        self.init()
        self.notesId = notesId
        self.notesTitle = notesTitle
        self.notesContent = notesContent
        self.strDate = strDate
        self.date = date
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
