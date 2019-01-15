//
//  CheapestTripNode.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import GameplayKit

protocol CheapestTripConnectable {
    func addConnection(to node: GKGraphNode, weight: Float)
    func cost(to node: GKGraphNode) -> Float
}

extension CheapestTripNode: CheapestTripConnectable {}

class CheapestTripNode: GKGraphNode {
    let name: String
    var travelCost: [GKGraphNode: Float] = [:]
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = "CheapestTrip"
        super.init()
    }
    
    override func cost(to node: GKGraphNode) -> Float {
        return travelCost[node] ?? 0
    }
    
    func addConnection(to node: GKGraphNode, weight: Float) {
        let bidirectional = false
        self.addConnections(to: [node], bidirectional: bidirectional)
        travelCost[node] = weight
        (node as? CheapestTripNode)?.travelCost[self] = weight
    }
}
