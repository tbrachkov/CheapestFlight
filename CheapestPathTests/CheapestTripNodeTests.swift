//
//  CheapestTripNodeTests.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
import GameplayKit
@testable import CheapestPath

class CheapestTripNodeTests: XCTestCase {
    
    var fromNode: CheapestTripConnectable!
    var toNode: GKGraphNode!
    
    override func setUp() {
        fromNode = CheapestTripNode(name: "From")
        toNode = CheapestTripNode(name: "To")
    }
    
    func testTheCostIsCorrectWhenOneNodeIsAdded() {
        fromNode.addConnection(to: toNode, weight: 2.6)
        XCTAssertEqual(fromNode.cost(to: toNode), 2.6)
    }
    
    func testTheCostIsZeroWhenNoNodeIsAdded() {
        XCTAssertEqual(fromNode.cost(to: toNode), 0.0)
    }
}
