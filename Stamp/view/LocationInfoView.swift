//
//  LocationInfoView.swift
//

import UIKit

final class LocationInfoView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadXib()
    }

    func loadXib() {
        Bundle.main.loadNibNamed("LocationInfoView", owner: self)
        contentView.frame = bounds
        addSubview(contentView)
    }

    func setInfo(location: Location) {
        if let memo = location.memo, !memo.isEmpty {
            titleTextField.text = memo
        }

        datetimeLabel.text = LocationService.convert(date: location.date! as Date, dateStyle: .medium, timeStyle: .medium)
        latitudeLabel.text = LocationService.convert(latitude: location.latitude, convertType: .plain)
        longitudeLabel.text = LocationService.convert(longitude: location.longitude, convertType: .plain)
    }
}
