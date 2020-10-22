//
//  Common.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit


class COMMON_SINON: NSObject {
    
    class var SHARED: COMMON {
        struct Singleton {
            static let instance = COMMON()
        }
        return Singleton.instance
    }
}

class COMMON: NSObject {
    func DLOG(message: Any, function: String = #function) {
      #if DEBUG
        print("\(function): \(message)")
      #endif
    }
}

func loadFormatter(start:String) -> Date {
    let formatterDate = DateFormatter()
    formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    if let date = formatterDate.date(from: start) {
        return date
    }
    return Date()
}

func getDate(convertToDate:Date) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone.local
    let strDate = dateFormatter.string(from: convertToDate)
    let date = dateFormatter.date(from: strDate)
    return date
}

func disaplyDateFormate(date: Date) -> String {
    let formatterDate = DateFormatter()
    formatterDate.dateFormat = "MMM dd yyyy"
    return formatterDate.string(from: date)
}

func dayDifference(from interval : TimeInterval) -> String {
    let calendar = Calendar.current
    let date = Date(timeIntervalSince1970: interval)
    if calendar.isDateInYesterday(date) { return "Yesterday" }
    else if calendar.isDateInToday(date) { return "Today" }
    else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
    else {
        return disaplyDateFormate(date: date)
    }
}
