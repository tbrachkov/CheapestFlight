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
    var name: String { get }
    var coordinate: Coordinate2D { get }
}

extension CheapestTripNode: CheapestTripConnectable {}

class CheapestTripNode: GKGraphNode {
    var name: String
    var coordinate: Coordinate2D
    var travelCost: [GKGraphNode: Float] = [:]
    
    init(name: String, coordinate: Coordinate2D) {
        self.name = name
        self.coordinate = coordinate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = "CheapestTrip"
        self.coordinate = Coordinate2D(lat: -1.0, long: -1.0)
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
