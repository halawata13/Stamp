//
//  DateRange.swift
//

import Foundation

struct DateRange {
    let from: Date
    let to: Date
    let rangeName: String

    init(from: Date, to: Date, rangeName: String) {
        self.from = from
        self.to = to
        self.rangeName = rangeName
    }
}
