//
//  UIViewController.swift
//

import UIKit
import ToastSwiftFramework

extension UIViewController {
    ///
    /// OK のみのダイアログを出す
    ///
    func makeConfirmDialog(message: String, title: String = "確認", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)

        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    ///
    /// OK とキャンセルのダイアログを出す
    ///
    func makeAuthorizationDialog(message: String, title: String = "確認", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    ///
    /// Toast メッセージを出す
    ///
    func makeToast(message: String) {
        view.makeToast(message)
    }
}
