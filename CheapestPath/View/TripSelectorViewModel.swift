//
//  TripSelectorViewModel.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation

protocol TripSelectorDelegate: class {
    func didFind(cheapestTrip: CheapestTrip?)
    func didUpdate(from destinations: [String])
    func didUpdate(to destinations: [String])
}

protocol TripSelectorInput {
    func didSelectStart(from: String)
    func didSelect(to: String)
    func start()
}

class TripSelectorViewModel: TripSelectorInput {
    weak var delegate: TripSelectorDelegate?
    let apiClientService: APIClientService
    var cheapestTripFinder: CheapestTripFinder?
    var trips: [TripConnection]
    
    convenience init() {
        let apiClientService = APIClientService()
        self.init(apiClientService: apiClientService)
    }

    init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
        self.trips = []
    }
    
    func didSelectStart(from: String) {
        cheapestTripFinder?.query(from: "London", to: "Cape Town")
    }
    
    func didSelect(to: String) {
        cheapestTripFinder?.query(from: "London", to: "Cape Town")
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
    
    private func updateFromAndToDestinations(from tripConnections: [TripConnection]) {
        let fromDestinations = tripConnections.compactMap { $0.from }
        let toDestinations = tripConnections.compactMap { $0.to }
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
