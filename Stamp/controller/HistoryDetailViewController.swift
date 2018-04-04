//
//  HistoryDetailViewController.swift
//

import Foundation
import UIKit
import MapKit

final class HistoryDetailViewController: UIViewController {
    var location: Location?

    @IBOutlet private weak var mapView: SingleLocationMapView!
    @IBOutlet private weak var locationInfoView: LocationInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let location = location else {
            assertionFailure()
            return
        }

        // title
        title = location.memo

        // mapView
        mapView.setLocation(location)
        mapView.setAnnotation()

        // locationInfoView
        locationInfoView.setInfo(location: location)

        // delegate
        locationInfoView.titleTextField.delegate = self

        // 画面をタップしたときにキーボードを下げるためのイベント
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapView))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func tapView() {
        // 画面をタップしたときにキーボードを下げる
        locationInfoView.titleTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension HistoryDetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let id = location?.id,
           let memo = textField.text {
            // メモを更新
            if !LocationService.update(id: id, memo: memo) {
                makeToast(message: "タイトルの入力に失敗しました")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
