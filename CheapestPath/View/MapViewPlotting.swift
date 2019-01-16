//
//  MapViewPlotting.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewPlotting {
    func removeOverlay(_ overlay: MKOverlay)
    func addOverlay(_ overlay: MKOverlay)
    func removeAnnotation(_ annotation: MKAnnotation)
    func setRegion(_ region: MKCoordinateRegion, animated: Bool)
    func showAnnotations(_ annotations: [MKAnnotation], animated: Bool)
    var annotations: [MKAnnotation] { get }
}

extension MKMapView: MapViewPlotting {}
