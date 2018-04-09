//
//  MainViewController.swift
//

import UIKit
import CoreLocation
import MapKit

final class MainViewController: UIViewController {
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
        makeAuthorizationDialog(message: "現在地を記録しますか？", title: "確認") { [weak self] (action) in
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
        // 権限チェック
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            makeConfirmDialog(message: "位置情報サービスが無効になっているため、現在地を記録できません")
            recordButton.isHidden = true
        case .restricted:
            makeConfirmDialog(message: "位置情報サービスが無効になっているため、現在地を記録できません")
            recordButton.isHidden = true
        case .authorizedAlways:
            break
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
