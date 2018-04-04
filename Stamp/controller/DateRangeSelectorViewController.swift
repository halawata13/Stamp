//
//  DateRangeSelectorViewController.swift
//

import UIKit

final class DateRangeSelectorViewController: UIViewController {
    private var dataSource: DateRangeSelectorTableViewDataSource!

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // dataSource
        dataSource = DateRangeSelectorTableViewDataSource()
        tableView.dataSource = dataSource

        // delegate
        tableView.delegate = self
    }

    @IBAction func onTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension DateRangeSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateRangeService = DateRangeService()
        let rangeName = dateRangeService.labels[indexPath.row]

        // 選択した範囲名を保存して終了
        dateRangeService.save(rangeName: rangeName)
        dismiss(animated: true)
    }
}
