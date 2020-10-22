//
//  RealmDb.swift
//  QRCodeReader
//
//  Created by Jakub Iwaszek on 25/04/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDb {
    static let shared = RealmDb()
    var realm: Realm!
    
    init() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("RealmDb")
        Realm.Configuration.defaultConfiguration = config
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        self.realm = try! Realm()
    }
    
    func addNewNotes(objNotes: NotesObjectClass) {
        let allScannedCodes = realm.objects(NotesObjectClass.self)
       // print(allScannedCodes)
        if allScannedCodes.contains(where: {$0.notesId == objNotes.notesId}) {
          //  print("This code is already in your history")
        } else {
          //  print("add code")
            try! realm.write {
                realm.add(objNotes)
            }
        }
    }
 
    
    func getNotesCodes() -> Results<NotesObjectClass> {
        let allScannedCodes = realm.objects(NotesObjectClass.self).sorted(byKeyPath: "date", ascending: true)
        return allScannedCodes
    }
    
    func deleteNotes(objNotes: NotesObjectClass) {
        try! realm.write {
            realm.delete(objNotes)
        }
    }
    func deleteAllNotes() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func updateNotes(objNotes: NotesObjectClass){
        let note = realm.objects(NotesObjectClass.self).filter("notesId = %@", objNotes.notesId)
        
        let realm = try! Realm()
        if let obj = note.first {
            try! realm.write {
                obj.notesTitle = objNotes.notesTitle
                obj.notesContent = objNotes.notesContent
            }
        }
    }
}
