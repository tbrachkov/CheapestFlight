//
//  MapRenderer.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import MapKit

protocol TripRenderer {
    func clearMap()
    func addRoute(with connections: [CityChange])
    func drawMap(with connections: [CityChange])
}

class MapRenderer {
    var mapView: MapViewPlotting
    private var mapOverlay: MKOverlay?

    init(mapView: MapViewPlotting) {
        self.mapView = mapView
    }
    
    func clearMap() {
        mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
        if let overlay = mapOverlay {
            mapView.removeOverlay(overlay)
        }
    }
    
    func addRoute(with connections: [CityChange]) {
        let coords = connections.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.coordinate.lat), CLLocationDegrees($0.coordinate.long)) }
        let routePolyline = MKPolyline(coordinates: coords, count: coords.count)
        
        mapView.addOverlay(routePolyline)
        mapOverlay = routePolyline
        
        let rect = routePolyline.boundingMapRect
        mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
    
    func drawMap(with connections: [CityChange]) {
        guard let start = connections.first, let destination = connections.last else {
            return
        }
        
        let startLocation = CLLocationCoordinate2D(latitude: start.coordinate.lat, longitude: start.coordinate.long)
        let destinationLocation = CLLocationCoordinate2D(latitude: destination.coordinate.lat, longitude: destination.coordinate.long)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = start.name
        startAnnotation.coordinate = startLocation
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = destination.name
        destinationAnnotation.coordinate = destinationLocation
        
        mapView.showAnnotations([startAnnotation, destinationAnnotation], animated: true)
        addRoute(with: connections)
    }
}
