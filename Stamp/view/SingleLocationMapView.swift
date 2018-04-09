//
//  SingleLocationMapView.swift
//

import MapKit

final class SingleLocationMapView: MKMapView {
    static let latitudinalMeters: Double = 500
    static let longitudinalMeters: Double = 500

    func setLocation(_ location: Location) {
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.latitude, location.longitude), SingleLocationMapView.latitudinalMeters, SingleLocationMapView.longitudinalMeters)

        setRegion(region, animated: false)
    }

    func setLocation(_ location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), SingleLocationMapView.latitudinalMeters, SingleLocationMapView.longitudinalMeters)

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
