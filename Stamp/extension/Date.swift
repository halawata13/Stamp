//
//  Date.swift
//

import Foundation

extension Date {
    ///
    /// 0時0分0秒の Date
    ///
    var at0: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/MM/dd"

        let dateString = formatter.string(from: self)

        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        return formatter.date(from: dateString + " 00:00:00")
    }
}
