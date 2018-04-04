//
//  HistoryMapViewController.swift
//

import Foundation
import UIKit
import CoreLocation
import MapKit

final class HistoryMapViewController: UIViewController {
    private var dateRange: DateRange!

    @IBOutlet private weak var historyMapView: HistoryMapView!
    @IBOutlet private weak var dateRangeLabelView: DateRangeLabelView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate
        dateRangeLabelView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadLocation()
        reloadView()
    }

    func reloadLocation() {
        let dateRangeService = DateRangeService()
        dateRange = dateRangeService.load()

        guard let fromDate = dateRange.from.at0,
              let toDate = dateRange.to.at0 else {
            return
        }

        if let locations = LocationService.fetch(from: fromDate, to: toDate) {
            historyMapView.setLocations(locations)
        }
    }

    func reloadView() {
        dateRangeLabelView.reloadDisplay(dateRange: dateRange)
    }
}

// MARK: - DateRangeLabelViewDelegate
extension HistoryMapViewController: DateRangeLabelViewDelegate {
    func datePickerDidEndEditing() {
        reloadLocation()
        reloadView()
    }
}
