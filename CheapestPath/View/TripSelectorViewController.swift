//
//  TripSelectorViewController.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import UIKit

class TripSelectorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromCityLabel: UILabel!
    @IBOutlet weak var toCityLabel: UILabel!
    @IBOutlet weak var fromCityTextField: UITextField!
    @IBOutlet weak var toCityTextField: UITextField!
    @IBOutlet weak var cheapestResultLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: TripSelectorInput!
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cheapestResultLabel.text = ""
        
        self.fromCityTextField.delegate = self
        self.toCityTextField.delegate = self

        viewModel = TripSelectorViewModel()
        viewModel.delegate = self
        viewModel.start()
    }
    
    func requestCheapestTripQuote() {
    }
}

extension TripSelectorViewController: TripSelectorDelegate {
    func didFind(cheapestTrip: CheapestTrip?) {
        guard let route = cheapestTrip else {
            cheapestResultLabel.text = ""
            return
        }
        cheapestResultLabel.text = "Cheapest trip: \(route.price)"
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
