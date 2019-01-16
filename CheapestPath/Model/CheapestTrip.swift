//
//  CheapestTrip.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation

struct CheapestTrip {
    let from: String
    let to: String
    let price: Int
    let tripConnections: [CityChange]
    
    init(from: String, to: String, price: Int, tripConnections: [CityChange]) {
        self.from = from
        self.to = to
        self.price = price
        self.tripConnections = tripConnections
    }
}
