//
//  UserClass.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit

class Note: Codable {
    
    var id: String
    var title: String
    var content: String
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case content = "content"
        case date = "date"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else {
            self.id = ""
        }
        if let title = try container.decodeIfPresent(String.self, forKey: .title) {
            self.title = title
        } else {
            self.title = ""
        }
        
        if let content = try container.decodeIfPresent(String.self, forKey: .content) {
            self.content = content
        } else {
            self.content = ""
        }
        
        if let date = try container.decodeIfPresent(String.self, forKey: .date) {
            self.date = date
        } else {
            self.date = ""
        }
    }
}
