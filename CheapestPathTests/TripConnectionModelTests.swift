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
        let bundle = Bundle(for: MockURLSession.self)
        guard let filePath = bundle.path(forResource: "oneSampleConnection", ofType: "json"), case let  data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Missing test json for one connection")
        }
        jsonData = data
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
