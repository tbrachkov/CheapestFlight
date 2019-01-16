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
    
    var didCallAddConnection: Bool!
    var cost: Float
    
    init(cost: Float) {
        self.cost = cost
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cost = 0
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
