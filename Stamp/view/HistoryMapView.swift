//
//  HistoryMapView.swift
//

import MapKit

final class HistoryMapView: MKMapView {
    func setLocations(_ locations: [Location]) {
        // region の設定
        if let location = locations.last {
            var region = self.region
            region.center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            region.span = MKCoordinateSpanMake(0.1, 0.1)

            setRegion(region, animated: false)
        }

        // annotation の設定
        var annotations = [MKPointAnnotation]()

        locations.forEach { (location) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = LocationService.convert(date: location.date! as Date, dateStyle: .short, timeStyle: .none)

            annotations.append(annotation)
        }

        removeAnnotations(self.annotations)
        addAnnotations(annotations)
    }
}
