//
//  DateRangeLabelViewDelegate.swift
//

import UIKit

protocol DateRangeLabelViewDelegate: class {
    func dateRangeLabelButtonTapped()

    func datePickerDidEndEditing()

    func datePickerWillShouldBeginEditing()
}

extension DateRangeLabelViewDelegate where Self: UIViewController {
    func dateRangeLabelButtonTapped() {
        let storyboard = UIStoryboard(name: "DateRangeSelector", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            present(initialViewController, animated: true)
        }
    }

    func datePickerDidEndEditing() {
        // optional
    }

    func datePickerWillShouldBeginEditing() {
        // optional
    }
}
