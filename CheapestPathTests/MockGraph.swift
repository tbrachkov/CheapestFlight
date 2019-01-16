//
//  MockGraph.swift
//  CheapestPathTests
//
//  Created by Todor Brachkov on 16/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation
import XCTest
import GameplayKit
@testable import CheapestPath

class MockGraph: Graphable {
    
    var nodesStore: [GKGraphNode] = []
    var resultPath: [GKGraphNode] = []

    func remove(_ nodes: [GKGraphNode]) {
        for node in nodes {
            if let index = nodes.firstIndex(of: node) {
                nodesStore.remove(at: index)
            }
        }
    }
    
    func add(_ nodes: [GKGraphNode]) {
        for node in nodes {
            nodesStore.append(node)
        }
    }
    
    func findPath(from startNode: GKGraphNode, to endNode: GKGraphNode) -> [GKGraphNode] {
        return resultPath
    }
}
