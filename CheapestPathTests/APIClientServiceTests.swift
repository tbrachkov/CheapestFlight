//
//  APIClientServiceTests.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import XCTest
@testable import CheapestPath

class APIClientServiceTests: XCTestCase {
    
    var httpClient: APIClientService!
    var session: MockURLSession!

    override func setUp() {
        session = MockURLSession()
        httpClient = APIClientService(session: session)
    }
    
    func testResumeGetsCalled() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        guard let url = URL(string: "https://mockurl.com") else {
            fatalError("URL can't be empty")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        httpClient.getTripConnections(request: request, callback: { (_, _) in
        })
        
        XCTAssertTrue(dataTask.resumeWasCalled)
    }
    
    func testCorrectURLBeingCalled() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        guard let url = URL(string: "https://mockurl.com/demo.json") else {
            fatalError("URL can't be empty")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let expectation = self.expectation(description: "Get trip connections")

        httpClient.getTripConnections(request: request, callback: { (_, _) in
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(session.lastURL, url)
    }
}
