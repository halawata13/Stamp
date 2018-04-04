//
//  SingleLocationMapView.swift
//

import MapKit

final class SingleLocationMapView: MKMapView {
    func setLocation(_ location: Location) {
        var region = self.region
        region.center = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        region.span = MKCoordinateSpanMake(0.005, 0.005)

        setRegion(region, animated: false)
    }

    func setLocation(_ location: CLLocation) {
        var region = self.region
        region.center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        region.span = MKCoordinateSpanMake(0.005, 0.005)

        setRegion(region, animated: false)
    }

    func setAnnotation(title: String? = nil, subtitle: String? = nil) {
        removeAnnotations(annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude)
        annotation.title = title
        annotation.subtitle = subtitle

        addAnnotation(annotation)
    }
}
