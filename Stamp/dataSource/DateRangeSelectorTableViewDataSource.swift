//
//  DateRangeSelectorTableViewDataSource.swift
//

import UIKit

final class DateRangeSelectorTableViewDataSource: NSObject, UITableViewDataSource {
    private let dateRangeService = DateRangeService()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRangeService.ranges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateRangeSelectorTableViewCell", for: indexPath) as? DateRangeSelectorTableViewCell else {
            fatalError()
        }

        cell.textLabel?.text = dateRangeService.labels[indexPath.row]
        cell.rangeName = dateRangeService.labels[indexPath.row]

        return cell
    }
}
