//
//  MapViewConfigurator.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import MapKit

class MapViewConfigurator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0

        return renderer
    }
}
