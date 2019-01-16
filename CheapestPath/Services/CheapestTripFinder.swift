//
//  CheapestTripFinder.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import GameplayKit

protocol Graphable {
    func remove(_ nodes: [GKGraphNode])
    func add(_ nodes: [GKGraphNode])
    func findPath(from startNode: GKGraphNode, to endNode: GKGraphNode) -> [GKGraphNode]
}

extension GKGraph: Graphable {}

struct CheapestTripFinder {
    let tripConnections: [TripConnection]
    let tripConnectionsGraph: Graphable
    var tripConnectionsGraphNodes: [String: CheapestTripConnectable]

    init(tripConnections: [TripConnection]) {
        let graph = GKGraph()
        self.init(tripConnections: tripConnections, graph: graph)
    }
    
    init(tripConnections: [TripConnection], graph: Graphable) {
        self.tripConnections = tripConnections
        self.tripConnectionsGraph = graph
        self.tripConnectionsGraphNodes = [:]
        self.buildTripConnectionsGraph(with: tripConnections)
    }
    
    mutating func buildTripConnectionsGraph(with tripConnections: [TripConnection]) {
        for connection in tripConnections {
            var nodeFrom: CheapestTripNode!
            var nodeTo: CheapestTripNode!
            
            if let startNode = tripConnectionsGraphNodes[connection.from] as? CheapestTripNode {
                nodeFrom = startNode
            }else {
                nodeFrom = CheapestTripNode(name: "\(connection.from)", coordinate: connection.coordinates.from)
                tripConnectionsGraphNodes.updateValue(nodeFrom, forKey: "\(connection.from)")
            }
            
            if let endNode = tripConnectionsGraphNodes[connection.to] as? CheapestTripNode {
                nodeTo = endNode
            }else {
                nodeTo = CheapestTripNode(name: "\(connection.to)", coordinate: connection.coordinates.to)
                tripConnectionsGraphNodes.updateValue(nodeTo, forKey: "\(connection.to)")
            }

            tripConnectionsGraph.add([nodeFrom, nodeTo])
            nodeFrom.addConnection(to: nodeTo, weight: Float(connection.price))
        }
    }
    
    func query(from: String, to: String) -> CheapestTrip? {
        guard let startNode = tripConnectionsGraphNodes[from] as? GKGraphNode, let endNode = tripConnectionsGraphNodes[to] as? GKGraphNode else {
            return nil
        }
        
        let path = tripConnectionsGraph.findPath(from: startNode, to: endNode)
        if path.count == 0 {
            return nil
        }
        let cost = calculateCost(for: path)
        let tripConnections = getCityChanges(for: path as! [CheapestTripConnectable])
        let cheapestPath = CheapestTrip(from: from, to: to, price: cost, tripConnections: tripConnections)
        return cheapestPath
    }
    
    private func getCityChanges(for path: [CheapestTripConnectable]) -> [CityChange] {
        var cityChanges: [CityChange] = []
        for city in path {
            let change = CityChange(name: city.name, coordinate: city.coordinate)
            cityChanges.append(change)
        }
        return cityChanges
    }
    
    private func calculateCost(for path: [GKGraphNode]) -> Int {
        var total: Float = 0
        for i in 0..<(path.count-1) {
            total += path[i].cost(to: path[i+1])
        }
        return Int(total)
    }
}
