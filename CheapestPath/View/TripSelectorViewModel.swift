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
    
    convenience init() {
        let apiClientService = APIClientService()
        self.init(apiClientService: apiClientService)
    }

    init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
    
    func didSelectStart(from: String) {
        cheapestTripFinder?.query(from: "London", to: "Cape Town")
    }
    
    func didSelect(to: String) {
        cheapestTripFinder?.query(from: "London", to: "Cape Town")
    }
    
    func start() {
        requesttripsFromAPI { [weak self] (tripConnections) in
            let graph = CheapestTripFinder(tripConnections: tripConnections)
            self?.cheapestTripFinder = graph
        }
    }
    
    private func requesttripsFromAPI(callback: @escaping (_ tripConnections: [TripConnection]) -> Void) {
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
            } catch let error {
                callback([])
            }
        }
    }
}
