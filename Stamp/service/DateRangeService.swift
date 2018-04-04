//
//  DateRangeService.swift
//

import Foundation

final class DateRangeService {
    let labels = [
        Range.today.rawValue,
        Range.recentWeek.rawValue,
        Range.recentMonth.rawValue,
        Range.recentYear.rawValue,
        Range.others.rawValue,
    ]

    let ranges = [
        Range.today,
        Range.recentWeek,
        Range.recentMonth,
        Range.recentYear,
        Range.others,
    ]

    let defaultRange = Range.recentMonth

    private let udDateRangeKey = "dateRangeKey"
    private let udOthersFromKey = "othersFromKey"
    private let udOthersToKey = "othersToKey"

    func save(rangeName: String) {
        UserDefaults.standard.set(rangeName, forKey: udDateRangeKey)
    }

    func save(dateRange: DateRange) {
        UserDefaults.standard.set(dateRange.rangeName, forKey: udDateRangeKey)

        if dateRange.rangeName == Range.others.rawValue {
            UserDefaults.standard.set(dateRange.from, forKey: udOthersFromKey)
            UserDefaults.standard.set(dateRange.to, forKey: udOthersToKey)
        }
    }

    func load() -> DateRange {
        guard let rangeName = UserDefaults.standard.object(forKey: udDateRangeKey) as? String else {
            return create(range: defaultRange)
        }

        return create(rangeName: rangeName)
    }

    private func create(range: Range) -> DateRange {
        return create(rangeName: range.rawValue)
    }

    private func create(rangeName: String) -> DateRange {
        var from: Date!
        var to: Date!

        switch (rangeName) {
        case Range.today.rawValue:
            from = Date()
            to = Date()
        case Range.recentWeek.rawValue:
            from = Date(timeIntervalSinceNow: 60 * 60 * 24 * 6 * -1)
            to = Date()
        case Range.recentMonth.rawValue:
            from = Date(timeIntervalSinceNow: 60 * 60 * 24 * 29 * -1)
            to = Date()
        case Range.recentYear.rawValue:
            from = Date(timeIntervalSinceNow: 60 * 60 * 24 * 364 * -1)
            to = Date()
        default:
            from = UserDefaults.standard.object(forKey: udOthersFromKey) as? Date ?? Date(timeIntervalSinceNow: 60 * 60 * 24 * 29 * -1)
            to = UserDefaults.standard.object(forKey: udOthersToKey) as? Date ?? Date()
        }

        return DateRange(from: from, to: to, rangeName: rangeName)
    }

    enum Range: String {
        case today = "今日"
        case recentWeek = "最近1週間"
        case recentMonth = "最近30日"
        case recentYear = "最近1年間"
        case others = "期間を指定"
    }
}
