//
//  SingleMapViewController.swift
//

import Foundation
import UIKit
import MapKit

final class SingleMapViewController: UIViewController, MapSnapshotShare, AlertDialog {
    var location: Location?
    var keyboardHeight: CGFloat?

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

        // navigationBarItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(onTapShareButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // タイトル入力時にキーボードの高さ分画面を押し上げるための監視を追加
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // タイトル入力時にキーボードの高さ分画面を押し上げるための監視を削除
        NotificationCenter.default.removeObserver(self)
    }

    @objc func tapView() {
        // 画面をタップしたときにキーボードを下げる
        locationInfoView.titleTextField.resignFirstResponder()
    }

    @objc func onTapShareButton() {
        guard let location = location else {
            return
        }

        shareMapSnapshot(region: MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.latitude, location.longitude), mapView.region.span))
    }

    @objc func keyboardWillShow(notification: Notification?) {
        // キーボードを上げたときにキーボードの高さ分画面を押し上げる
        guard let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        keyboardHeight = keyboardHeight ?? rect.size.height - (tabBarController?.tabBar.frame.size.height ?? 0)

        let duration = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { [weak self] in
            let transform = CGAffineTransform(translationX: 0, y: -(self?.keyboardHeight)!)
            self?.view.transform = transform
        })
    }

    @objc func keyboardWillHide(notification: Notification?) {
        // キーボードが消えたときに画面を戻す
        let duration = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { [weak self] in
            self?.view.transform = CGAffineTransform.identity
        })
    }
}

// MARK: - UITextFieldDelegate
extension SingleMapViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let id = location?.id,
           let memo = textField.text {
            // メモを更新
            if !LocationService.update(id: id, memo: memo) {
                showConfirmAlert(message: "タイトルの入力に失敗しました")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
