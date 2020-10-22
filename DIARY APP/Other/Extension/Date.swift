//
//  Date.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import Foundation
extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
    
    func formattedRelativeString() -> String{
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(self) ||  calendar.isDateInYesterday(self) {
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
        } else if calendar.compare(Date(), to: self, toGranularity: .weekOfYear) == .orderedSame {
            dateFormatter.dateFormat = "EEEE, h:mm a"
        } else if calendar.compare(Date(), to: self, toGranularity: .year) == .orderedSame {
            dateFormatter.dateFormat = "E, d MMM, h:mm a"
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
        
        return dateFormatter.string(from: self)
    }
    
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
    
    public var relativeTimeString: String {
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            return formatter.localizedString(for: self, relativeTo: Date())
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        var interval: Int
        var unit: String
        if let value = components.year, value > 0  {
            interval = value
            unit = "year"
        }
        else if let value = components.month, value > 0  {
            interval = value
            unit = "month"
        }
        else if let value = components.day, value > 0  {
            interval = value
            unit = "day"
        }
        else if let value = components.hour, value > 0  {
            interval = value
            unit = "hour"
        }
        else if let value = components.minute, value > 0  {
            interval = value
            unit = "minute"
        }
        else {
            return "moments ago"
        }
        
        return "\(interval) \(unit + (interval > 1 ? "s" : "")) ago"
    }
}


struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
        DateComponentUnitFormat(unit: .year,
                                singularUnit: "year",
                                pluralUnit: "years",
                                futureSingular: "Next year",
                                pastSingular: "Last year"),
        
        DateComponentUnitFormat(unit: .month,
                                singularUnit: "month",
                                pluralUnit: "months",
                                futureSingular: "Next month",
                                pastSingular: "Last month"),
        
        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: "week",
                                pluralUnit: "weeks",
                                futureSingular: "Next week",
                                pastSingular: "Last week"),
        
        DateComponentUnitFormat(unit: .day,
                                singularUnit: "day",
                                pluralUnit: "days",
                                futureSingular: "Tomorrow",
                                pastSingular: "Yesterday"),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "hour",
                                pluralUnit: "hours",
                                futureSingular: "an hour",
                                pastSingular: "An hour ago"),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "min",
                                pluralUnit: "min",
                                futureSingular: "a min",
                                pastSingular: "A min ago"),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: "sec",
                                pluralUnit: "sec",
                                futureSingular: "Just now",
                                pastSingular: "Just now"),
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) ago"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
            case -1:
                return useNumericDates ? "\(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "\(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
        }
        
        return "Just now"
    }
}
