//
//  DateExtension.swift
//  We
//
//

import Foundation

extension Date {
    func relativeDate() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: self)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: self)
        }
    }
}

extension Date {
    /// Returns a user-friendly string representing the time elapsed since the date.
    var timeAgo: String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        if timeInterval < 60 {
            return "Updated just now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "Updated \(minutes) min ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "Updated \(hours) hour ago"
        } else {
            return "Updated a long time ago"
        }
    }
}
