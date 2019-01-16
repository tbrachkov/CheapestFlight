//
//  CheapestTripFinderTests.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
import GameplayKit
@testable import CheapestPath

class CheapestTripFinderTests: XCTestCase {
    
    var mockedGraph: MockGraph!
    
    override func setUp() {
        mockedGraph = MockGraph()
    }
    
    func testNoPathIsReturnedIfNoNodesAdded() {
        let pathFinder = CheapestTripFinder(tripConnections: [], graph: mockedGraph)
        let path = pathFinder.query(from: "London", to: "Porto")
        XCTAssertNil(path)
    }
    
    func testNoPathIsReturnedIfNodesAddedButGraphDoesNotFindPath() {
        let fromNode = CheapestTripNodeMock(cost: 400)
        let toNode = CheapestTripNodeMock(cost: 500)
        fromNode.addConnection(to: toNode, weight: 600)
        
        var pathFinder = CheapestTripFinder(tripConnections: [], graph: mockedGraph)
        
        pathFinder.tripConnectionsGraphNodes.updateValue(fromNode, forKey: "London")
        pathFinder.tripConnectionsGraphNodes.updateValue(toNode, forKey: "Porto")
        
        let path = pathFinder.query(from: "London", to: "Porto")
        XCTAssertNil(path)
    }
    
    func testPathIsReturnedIfNodesAddedAndTheCostIsTheMockedCost() {
        let fromNode = CheapestTripNodeMock(cost: 400)
        let toNode = CheapestTripNodeMock(cost: 500)
        fromNode.addConnection(to: toNode, weight: 0)
        mockedGraph.resultPath = [fromNode, toNode]
        var pathFinder = CheapestTripFinder(tripConnections: [], graph: mockedGraph)
        
        pathFinder.tripConnectionsGraphNodes.updateValue(fromNode, forKey: "London")
        pathFinder.tripConnectionsGraphNodes.updateValue(toNode, forKey: "Porto")
        
        let path = pathFinder.query(from: "London", to: "Porto")
        XCTAssertEqual(path?.price, 400)
    }
    
    func testPathIsReturnedIfNodesAddedAndTheNumberOfStopsIsCorrect() {
        let fromNode = CheapestTripNodeMock(cost: 800)
        let toNode = CheapestTripNodeMock(cost: 500)
        fromNode.addConnection(to: toNode, weight: 0)
        mockedGraph.resultPath = [fromNode, toNode]
        var pathFinder = CheapestTripFinder(tripConnections: [], graph: mockedGraph)
        
        pathFinder.tripConnectionsGraphNodes.updateValue(fromNode, forKey: "London")
        pathFinder.tripConnectionsGraphNodes.updateValue(toNode, forKey: "Porto")
        
        let path = pathFinder.query(from: "London", to: "Porto")
        XCTAssertEqual(path?.tripConnections.count, 2)
    }

}
