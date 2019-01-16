//
//  TripSelectorViewModel.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import UIKit

protocol TripSelectorDelegate: class {
    func didFind(cheapestTrip: CheapestTrip?)
    func didUpdate(from destinations: [String])
    func didUpdate(to destinations: [String])
}

protocol TripSelectorInput {
    func didSelect(from: String, to: String)
    func start()
    func autoCompleteText(in textField: UITextField, using string: String, suggestions: [String]) -> Bool
    var fromDestinations: [String] { get }
    var toDestinations: [String] { get }
    var delegate: TripSelectorDelegate? { set get }
}

class TripSelectorViewModel: TripSelectorInput {
    weak var delegate: TripSelectorDelegate?
    let apiClientService: APIClientService
    var cheapestTripFinder: CheapestTripFinder?
    var trips: [TripConnection]
    
    var fromDestinations: [String] = []
    var toDestinations: [String] = []

    convenience init() {
        let apiClientService = APIClientService()
        self.init(apiClientService: apiClientService)
    }

    init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
        self.trips = []
    }
    
    func didSelect(from: String, to: String) {
        let cheapestTrip = cheapestTripFinder?.query(from: from, to: to)
        self.delegate?.didFind(cheapestTrip: cheapestTrip)
    }
    
    func start() {
        requestTripsFromAPI { [weak self] (tripConnections) in
            guard let strongSelf = self else {
                return
            }
            let graph = CheapestTripFinder(tripConnections: tripConnections)
            strongSelf.cheapestTripFinder = graph
            strongSelf.updateFromAndToDestinations(from: tripConnections)
        }
    }
    
    func autoCompleteText(in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange, selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text(in: prefixRange) {
            let prefix = text + string
            let matches = suggestions.filter { $0.hasPrefix(prefix) }
            
            if (matches.count > 0) {
                textField.text = matches[0]
                
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    
                    return true
                }
            }
        }
        return false
    }
    
    private func updateFromAndToDestinations(from tripConnections: [TripConnection]) {
        let fromDestinations = tripConnections.compactMap { $0.from.capitalized }
        let toDestinations = tripConnections.compactMap { $0.to.capitalized }
        
        self.fromDestinations = fromDestinations
        self.toDestinations = toDestinations
        
        self.delegate?.didUpdate(from: fromDestinations)
        self.delegate?.didUpdate(to: toDestinations)
    }
    
    private func requestTripsFromAPI(callback: @escaping (_ tripConnections: [TripConnection]) -> Void) {
        apiClientService.getTripConnections { (error, data) in
            if let _ = error {
                callback([])
                return
            }
            guard let rasultData = data else {
                callback([])
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let root = try decoder.decode(Root.self, from: rasultData)
                callback(root.connections)
            } catch {
                callback([])
            }
        }
    }
}
