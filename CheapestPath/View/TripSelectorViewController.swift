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
    var mapRenderer: MapRenderer!
    private var mapViewConfigurator: MapViewConfigurator!
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cheapestResultLabel.text = ""
        setupMapView()
        setupTextFields()
        setupViewModel()
        setupMapRenderer(with: mapView)
    }
    
    private func setupTextFields() {
        self.fromCityTextField.delegate = self
        self.toCityTextField.delegate = self
    }
    
    private func setupMapRenderer(with mapView: MapViewPlotting) {
        mapRenderer = MapRenderer(mapView: mapView)
    }
    
    private func setupMapView() {
        mapViewConfigurator = MapViewConfigurator()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = mapViewConfigurator
        mapView.showsUserLocation = true
    }
    
    private func setupViewModel() {
        viewModel = TripSelectorViewModel()
        viewModel.delegate = self
        viewModel.start()
    }
}

extension TripSelectorViewController: TripSelectorDelegate {
    func didFind(cheapestTrip: CheapestTrip?) {
        mapRenderer.clearMap()
        guard let route = cheapestTrip else {
            cheapestResultLabel.text = ""
            return
        }
        cheapestResultLabel.text = "Cheapest trip: \(route.price)"
        mapRenderer.drawMap(with: route.tripConnections)
    }
}

extension TripSelectorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var textFieldAutocomplete = textField as UITextFieldAutoCompletable
        if textField == fromCityTextField {
            return !self.viewModel.autoCompleteText(in: &textFieldAutocomplete, using: string.capitalized, suggestions: viewModel.fromDestinations)
        }else {
            return !self.viewModel.autoCompleteText(in: &textFieldAutocomplete, using: string.capitalized, suggestions: viewModel.toDestinations)
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
