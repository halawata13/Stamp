//
//  AlertDialog.swift
//

import UIKit

protocol AlertDialog: class {
    func showConfirmAlert(message: String, title: String, handler: ((UIAlertAction) -> Void)?)

    func showAuthorizationAlert(message: String, title: String, handler: ((UIAlertAction) -> Void)?)

    func showSettingsAlert(message: String, title: String)

    func showToast(message: String, title: String?, duration: Double)
}

extension AlertDialog where Self: UIViewController {
    ///
    /// OK のみのダイアログを出す
    ///
    func showConfirmAlert(message: String, title: String = "確認", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    ///
    /// OK とキャンセルのダイアログを出す
    ///
    func showAuthorizationAlert(message: String, title: String = "確認", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    ///
    /// 設定画面へ誘導するダイアログを出す
    ///
    func showSettingsAlert(message: String, title: String = "確認") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "設定", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    ///
    /// Toast を表示する
    ///
    func showToast(message: String, title: String? = nil, duration: Double = 1.0) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        present(alertController, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alertController.dismiss(animated: true)
            }
        })
    }
}
