//
//  DateRangeLabelView.swift
//

import UIKit

final class DateRangeLabelView: UIView {
    private let fromDatePicker = UIDatePicker()
    private let toDatePicker = UIDatePicker()

    weak var delegate: DateRangeLabelViewDelegate?

    private var rangeName: String?

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var dateRangeButton: UIButton!
    @IBOutlet private weak var dateRangeStackView: UIStackView!
    @IBOutlet private weak var fromDateTextField: UITextField!
    @IBOutlet private weak var toDateTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadXib()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed("DateRangeLabelView", owner: self)
        contentView.frame = bounds
        addSubview(contentView)

        dateRangeButton.titleLabel?.adjustsFontSizeToFitWidth = true

        // fromDatePicker
        fromDatePicker.datePickerMode = .date
        fromDateTextField.inputView = fromDatePicker

        // toDatePicker
        toDatePicker.datePickerMode = .date
        toDateTextField.inputView = toDatePicker

        // pickerToolbar setup
        let pickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 34))
        pickerToolbar.barStyle = .default
        pickerToolbar.tintColor = UIColor.gray
        pickerToolbar.backgroundColor = UIColor.lightGray

        let toolbarButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(onEditedDatePicker))

        pickerToolbar.items = [toolbarButton]
        fromDateTextField.inputAccessoryView = pickerToolbar
        toDateTextField.inputAccessoryView = pickerToolbar

        // delegate
        fromDateTextField.delegate = self
        toDateTextField.delegate = self
    }

    func reloadDisplay(dateRange: DateRange) {
        dateRangeStackView.isHidden = dateRange.rangeName != DateRangeService.Range.others.rawValue

        UIView.setAnimationsEnabled(false)
        dateRangeButton.setTitle(dateRange.rangeName, for: .normal)
        UIView.setAnimationsEnabled(true)

        // fromDatePicker
        fromDateTextField.text = LocationService.convert(date: dateRange.from, dateStyle: .short, timeStyle: .none)
        fromDatePicker.date = dateRange.from

        // toDatePicker
        toDateTextField.text = LocationService.convert(date: dateRange.to, dateStyle: .short, timeStyle: .none)
        toDatePicker.date = dateRange.to

        self.rangeName = dateRange.rangeName
    }

    @objc func onEditedDatePicker(sender: UIBarButtonItem) {
        fromDateTextField.text = LocationService.convert(date: fromDatePicker.date, dateStyle: .short, timeStyle: .none)
        toDateTextField.text = LocationService.convert(date: toDatePicker.date, dateStyle: .short, timeStyle: .none)

        if let rangeName = rangeName {
            DateRangeService().save(dateRange: DateRange(from: fromDatePicker.date, to: toDatePicker.date, rangeName: rangeName))
        }

        delegate?.datePickerDidEndEditing()

        endEditing(true)
    }

    @IBAction func onTapDateRangeButton(_ sender: UIButton) {
        delegate?.dateRangeLabelButtonTapped()
    }
}

extension DateRangeLabelView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.datePickerWillShouldBeginEditing()

        return true
    }
}
