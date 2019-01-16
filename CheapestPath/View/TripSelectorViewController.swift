//
//  TripSelectorViewController.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import UIKit
import MapKit

class TripSelectorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromCityLabel: UILabel!
    @IBOutlet weak var toCityLabel: UILabel!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var cheapestResultLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var viewModel: TripSelectorInput!
    private var mapOverlay: MKOverlay?
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cheapestResultLabel.text = ""
        
        setupMapView()
        setupTextFields()
        setupViewModel()
    }
    
    private func setupTextFields() {
        self.fromCityTextField.delegate = self
        self.toCityTextField.delegate = self
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func setupViewModel() {
        viewModel = TripSelectorViewModel()
        viewModel.delegate = self
        viewModel.start()
    }
    
    private func drawMap(with connections: [CityChange]) {
        guard let start = connections.first, let destination = connections.last else {
            return
        }
        
        mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
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
    
    private func addRoute(with connections: [CityChange]) {
        let coords = connections.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.coordinate.lat), CLLocationDegrees($0.coordinate.long)) }
        let routePolyline = MKPolyline(coordinates: coords, count: coords.count)
        
        if let overlay = mapOverlay {
            mapView.removeOverlay(overlay)
        }
        mapView.addOverlay(routePolyline)
        mapOverlay = routePolyline
        
        let rect = routePolyline.boundingMapRect
        mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
}

extension TripSelectorViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}

extension TripSelectorViewController: TripSelectorDelegate {
    func didFind(cheapestTrip: CheapestTrip?) {
        guard let route = cheapestTrip else {
            cheapestResultLabel.text = ""
            return
        }
        cheapestResultLabel.text = "Cheapest trip: \(route.price)"
        drawMap(with: route.tripConnections)
    }
    
    func didUpdate(from destinations: [String]) {
        // TODO: - Use this in the future to make more interactive UI
    }
    
    func didUpdate(to destinations: [String]) {
        // TODO: - Use this in the future to make more interactive UI
    }
}

extension TripSelectorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fromCityTextField {
            return !self.viewModel.autoCompleteText(in: textField, using: string.capitalized, suggestions: viewModel.fromDestinations)
        }else {
            return !self.viewModel.autoCompleteText(in: textField, using: string.capitalized, suggestions: viewModel.toDestinations)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if let destination = getFieldsIfNotEmpty() {
            viewModel.didSelect(from: destination.from, to: destination.to)
        }
    }
    
    func getFieldsIfNotEmpty() -> (from: String, to: String)? {
        guard let from = fromCityTextField.text, let to = toCityTextField.text else {
            return nil
        }
        if from.isEmpty || to.isEmpty {
            return nil
        }
        return (from: from, to: to)
    }
}
