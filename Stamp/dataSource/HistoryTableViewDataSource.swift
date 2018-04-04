//
//  HistoryTableViewDataSource.swift
//

import UIKit
import MapKit

final class HistoryTableViewDataSource: NSObject, UITableViewDataSource {
    private var sections: [String]
    private var locations: [String: [Location]]

    init(locations: [Location]) {
        var sortedSections = [String]()
        var sortedLocations = [String: [Location]]()

        for location in locations {
            guard let date = location.date as Date? else {
                continue
            }

            let dateString = LocationService.convert(date: date, dateStyle: .long, timeStyle: .none)

            // 日付ごとのセクションにする
            if let _ = sortedLocations[dateString] {
                sortedLocations[dateString]?.insert(location, at: 0)
            } else {
                sortedSections.insert(dateString, at: 0)
                sortedLocations[dateString] = [location]
            }
        }

        self.sections = sortedSections
        self.locations = sortedLocations
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations[sections[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryListTableViewCell

        if let location = getLocation(indexPath: indexPath) {
            cell.setLocation(location)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           let id = getLocation(indexPath: indexPath)?.id,
           LocationService.delete(id: id) {
            let sectionName = sections[indexPath.section]
            locations[sectionName]?.remove(at: indexPath.row)

            // 日付に属する記録がなくなったらセクションごと消す
            if locations[sectionName]?.count == 0 {
                sections.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func getLocation(indexPath: IndexPath) -> Location? {
        let sectionName = sections[indexPath.section]
        return locations[sectionName]?[indexPath.row]
    }
}
