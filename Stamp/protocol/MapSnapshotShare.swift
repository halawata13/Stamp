//
//  MapSnapshotShare.swift
//

import Foundation
import MapKit

protocol MapSnapshotShare: class {
    func shareMapSnapshot(region: MKCoordinateRegion)
}

extension MapSnapshotShare where Self: UIViewController {
    func shareMapSnapshot(region: MKCoordinateRegion) {
        let snapshotService = SnapshotService(region: region)
        snapshotService.shot { [weak self] (snapshot: MKMapSnapshot?, error: Error?) in
            guard let snapshot = snapshot, error == nil, let view = self?.view else {
                assertionFailure()
                return
            }

            // 共有用画像作成
            let annotationView = MKPinAnnotationView(annotation: nil, reuseIdentifier: "pin")
            annotationView.pinTintColor = .red
            let pinImage = annotationView.image

            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)

            snapshot.image.draw(at: CGPoint(x: 0, y: 0))

            var point = snapshot.point(for: CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude))
            point.x -= annotationView.bounds.size.width / 2
            point.y -= annotationView.bounds.size.height / 2
            point.x += annotationView.centerOffset.x
            point.y += annotationView.centerOffset.y
            pinImage?.draw(at: point)

            let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            guard let pinnedImage = generatedImage else {
                assertionFailure()
                return
            }

            // UIActivityViewController
            let items: [Any] = [pinnedImage]
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)

            let excluded = [
                UIActivityType.print,
                UIActivityType.saveToCameraRoll,
                UIActivityType.assignToContact,
            ]

            activityController.excludedActivityTypes = excluded
            activityController.popoverPresentationController?.sourceView = view
            activityController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2, width: 1, height: 1)

            self?.present(activityController, animated: true)
        }
    }
}
