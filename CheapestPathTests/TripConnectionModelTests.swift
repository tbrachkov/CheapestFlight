//
//  TripConnectionModelTests.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
@testable import CheapestPath

class TripConnectionModelTests: XCTestCase {

    var jsonData: Data!
    override func setUp() {
        let jsonString = """
        {
            "connections": [{
                "from": "London",
                "to": "Tokyo",
                "coordinates": {
                    "from": {
                        "lat": 51.5285582,
                        "long": -0.241681
                    },
                    "to": {
                        "lat": 35.652832,
                        "long": 139.839478
                    }
                },
                "price": 600
            }]
        }
        """
        jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) ?? Data(count: 1)
    }
    
    func testTripGetsDecodedCorrectlyWithOneTrip() {
        let decoder = JSONDecoder()
        do {
            let root = try decoder.decode(Root.self, from: jsonData)
            XCTAssertEqual(root.connections.count, 1)
        } catch {
            XCTFail()
        }
    }
    
    func testTripGetsDecodedCorrectlyWithCorrectPrice() {
        let decoder = JSONDecoder()
        do {
            let root = try decoder.decode(Root.self, from: jsonData)
            XCTAssertEqual(root.connections.first?.price ?? 0, 600)
        } catch {
            XCTFail()
        }
    }    
}
