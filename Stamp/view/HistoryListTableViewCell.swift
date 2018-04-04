//
//  HistoryListTableViewCell.swift
//

import UIKit

final class HistoryListTableViewCell: UITableViewCell {
    @IBOutlet private weak var memoLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var coordinateLabel: UILabel!

    func setLocation(_ location: Location) {
        if let memo = location.memo, !memo.isEmpty {
            memoLabel.text = location.memo
            coordinateLabel.text = LocationService.convert(latitude: location.latitude, longitude: location.longitude, convertType: .plain)
        } else {
            memoLabel.text = LocationService.convert(latitude: location.latitude, longitude: location.longitude, convertType: .plain)
        }

        if let date = location.date as Date? {
            timeLabel.text = LocationService.convert(date: date, dateStyle: .none, timeStyle: .medium)
        }
    }
}
