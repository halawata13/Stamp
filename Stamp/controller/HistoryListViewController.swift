//
//  HistoryListViewController.swift
//

import Foundation
import UIKit

final class HistoryListViewController: UIViewController {
    private var locations: [Location]!
    private var dateRange: DateRange!
    private var historyTableViewDataSource: HistoryTableViewDataSource!

    @IBOutlet private weak var historyTableView: UITableView!
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryDetailSegue" {
            guard let historyDetailViewController = segue.destination as? HistoryDetailViewController,
                  let indexPath = historyTableView.indexPathForSelectedRow else {
                assertionFailure()
                return
            }

            historyDetailViewController.location = historyTableViewDataSource.getLocation(indexPath: indexPath)
        }
    }

    func reloadLocation() {
        let dateRangeService = DateRangeService()
        dateRange = dateRangeService.load()

        guard let fromDate = dateRange.from.at0,
              let toDate = dateRange.to.at0 else {
            return
        }

        locations = LocationService.fetch(from: fromDate, to: toDate)
    }

    func reloadView() {
        historyTableViewDataSource = HistoryTableViewDataSource(locations: locations)
        historyTableView.dataSource = historyTableViewDataSource
        historyTableView.reloadData()

        dateRangeLabelView.reloadDisplay(dateRange: dateRange)
    }
}

// MARK: - DateRangeLabelViewDelegate
extension HistoryListViewController: DateRangeLabelViewDelegate {
    func datePickerDidEndEditing() {
        reloadLocation()
        reloadView()
    }
}
