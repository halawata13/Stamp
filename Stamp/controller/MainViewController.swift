//
//  MainViewController.swift
//

import UIKit
import CoreLocation
import MapKit

final class MainViewController: UIViewController, AlertDialog {
    private var locationManager: CLLocationManager!

    @IBOutlet private weak var mapView: SingleLocationMapView!
    @IBOutlet private weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        locationManager.stopUpdatingLocation()
    }

    @IBAction func onTapRecordButton(_ sender: UIButton) {
        // 現在地の記録
        showAuthorizationAlert(message: "現在地を記録しますか？", title: "確認") { [weak self] (action) in
            guard let center = self?.mapView.region.center else {
                return
            }

            if let location = LocationService.insert(coordinate: center),
               let historyDetailViewController = self?.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailViewController") as? HistoryDetailViewController {
                historyDetailViewController.location = location
                self?.navigationController?.pushViewController(historyDetailViewController, animated: true)
            }
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 大元の位置情報サービスの許可チェック
        if CLLocationManager.locationServicesEnabled() == false {
            showConfirmAlert(message: "位置情報サービスがONになっていないため、現在地を記録できません。")
            recordButton.isHidden = true
            return
        }

        // 権限チェック
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showSettingsAlert(message: "位置情報サービスの利用が許可されていないため、現在地を記録できません。")
            recordButton.isHidden = true
        case .restricted:
            showConfirmAlert(message: "位置情報サービスの利用が制限されているため、現在地を記録できません。")
            recordButton.isHidden = true
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            recordButton.isHidden = false
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            mapView.setLocation(location)
            mapView.setAnnotation(title: "現在地")
        }
    }
}
