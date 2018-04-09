//
//  SnapshotService.swift
//

import Foundation
import MapKit

final class SnapshotService {
    let options = MKMapSnapshotOptions()
    let snapshotter: MKMapSnapshotter

    init(region: MKCoordinateRegion) {
        options.region = region
        options.scale = UIScreen.main.scale
        options.size = CGSize(width: 300, height: 300)
        options.showsBuildings = true
        options.showsPointsOfInterest = true

        snapshotter = MKMapSnapshotter(options: options)
    }

    func shot(completionHandler: @escaping MKMapSnapshotCompletionHandler) {
        snapshotter.start(with: DispatchQueue.global(), completionHandler: completionHandler)
    }
}
