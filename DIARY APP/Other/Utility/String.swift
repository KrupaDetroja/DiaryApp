
//
//  NSString+Utility.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import Foundation

extension String {
    func trimString() -> String {
        var trimmedStr: String = ""
        let str_Trimmed: String = (self as NSString).replacingCharacters(in: (self as NSString).range(of:"^\\s*", options: .regularExpression), with: "")
        if str_Trimmed.count > 0 {
            trimmedStr = (str_Trimmed as NSString).replacingCharacters(in: (str_Trimmed as NSString).range(of:"\\s*$", options: .regularExpression), with: "")
        }
        return trimmedStr
    }
    var length: Int {
        return (self as NSString).length
    }
}

extension Character {
    func unicodeScalar() -> UnicodeScalar {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex]
    }
}
