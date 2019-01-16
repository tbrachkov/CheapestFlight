//
//  CheapestTripNodeMock.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
import GameplayKit
@testable import CheapestPath

class CheapestTripNodeMock: GKGraphNode, CheapestTripConnectable {
    var name: String
    var coordinate: Coordinate2D
    
    var didCallAddConnection: Bool!
    var cost: Float
    
    init(cost: Float) {
        self.cost = cost
        self.name = ""
        self.coordinate = Coordinate2D(lat: -1.0, long: -1.0)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cost = 0
        self.name = ""
        self.coordinate = Coordinate2D(lat: -1.0, long: -1.0)
        super.init()
    }
    
    func addConnection(to node: GKGraphNode, weight: Float) {
        super.addConnections(to: [node], bidirectional: false)
        didCallAddConnection = true
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        return cost
    }
}
