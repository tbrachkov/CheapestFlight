//
//  TripConnection.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation

struct Root: Decodable {
    let connections: [TripConnection]
}
struct TripConnection: Decodable {
    let from: String
    let to: String
    let coordinates: Coordinates
    let price: Int
}


struct Coordinates: Decodable {
    let from: Coordinate2D
    let to: Coordinate2D
}

struct Coordinate2D: Decodable {
    let lat: Double
    let long: Double
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}


struct CityChange {
    let name: String
    let coordinate: Coordinate2D
    
    init(name: String, coordinate: Coordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
}
