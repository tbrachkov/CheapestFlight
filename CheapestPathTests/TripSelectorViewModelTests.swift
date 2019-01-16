//
//  TripSelectorViewModelTests.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//


import Foundation
import XCTest
import GameplayKit
@testable import CheapestPath

class TripSelectorViewModelTests: XCTestCase {
    
    var httpClient: APIClientService!
    var session: MockURLSession!
    var viewModel: TripSelectorViewModel!
    var jsonData: Data!

    override func setUp() {
        session = MockURLSession()
        httpClient = APIClientService(session: session)
    }
    
    func testNoDataReturnedFromAPINoFromCityIsSet() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData = nil
        viewModel = TripSelectorViewModel(apiClientService: httpClient)
        viewModel.start()
        viewModel.didSelect(from: "London", to: "Porto")
        
        XCTAssertEqual(viewModel.fromDestinations, [])
        XCTAssertEqual(viewModel.toDestinations, [])
    }
    
    func testDataReturnedFromAPICorrectFromCityIsSet() {
        let bundle = Bundle(for: MockURLSession.self)
        guard let filePath = bundle.path(forResource: "oneSampleConnection", ofType: "json"), case let  data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Missing test json for one connection")
        }
        jsonData = data
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData = jsonData
        viewModel = TripSelectorViewModel(apiClientService: httpClient)
        viewModel.start()
        viewModel.didSelect(from: "London", to: "Porto")
        
        XCTAssertEqual(viewModel.fromDestinations, ["London"])
        XCTAssertEqual(viewModel.toDestinations, ["Tokyo"])
    }
    
    func testErrorReturnedFromAPINoCheapTripIsSet() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextError = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey : "This is mocked error!"])
        viewModel = TripSelectorViewModel(apiClientService: httpClient)
        viewModel.start()
        viewModel.didSelect(from: "London", to: "Porto")
        
        XCTAssertNil(viewModel.cheapestTrip)
    }
    
    func testDataReturnedFromAPICorrectAndTheCheapestTripIsFound() {
        let bundle = Bundle(for: MockURLSession.self)
        guard let filePath = bundle.path(forResource: "fullListConnections", ofType: "json"), case let  data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Missing test json for full list of connections")
        }
        jsonData = data
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData = jsonData
        viewModel = TripSelectorViewModel(apiClientService: httpClient)
        viewModel.start()
        viewModel.didSelect(from: "London", to: "Los Angeles")
        
        XCTAssertEqual(viewModel.cheapestTrip?.price, 680)
        XCTAssertEqual(viewModel.cheapestTrip?.tripConnections.count, 3)
    }
}
