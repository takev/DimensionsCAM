//
//  Edge.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-20.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

/// An Edge is a line segement between two vertices called A & B.
struct Edge: CollectionType, Hashable {
    typealias Index = Int
    typealias Element = Vector3Fix10

    let A:  Element
    let B:  Element

    /// The centroid of the edge.
    var centroid:   Element { return (A + B) / 2 }

    /// The number of vertices. (always 2)
    var count:      Int     { return 2 }

    /// Beyond the last index in a list of vertices. (always 2)
    var endIndex:   Int     { return 2 }

    /// First index in a list of vertices. (always 0)
    var startIndex: Int     { return 0 }

    /// Is the list of vertices empty. (always false)
    var isEmpty:    Bool    { return false }

    /// Return a grid identifier for this object.
    var id:         UInt64  { return centroid.id }

    var hashValue:  Int     { return id.hashValue }

    /// Initialize an Edge
    /// There is no order of vertices on an edge, since an edge doesn't have an inside.
    ///
    /// param: A: First vertex.
    /// param: B: Second vertex.
    init(_ A: Element, _ B: Element) {
        self.A = A
        self.B = B
    }

    /// Get a vertex.
    /// param: index: integer index into the list of vertices.
    subscript(index: Int) -> Element {
        switch index {
        case 0: return A
        case 1: return B
        default: preconditionFailure("Triangle only has three vertice.")
        }
    }
}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.id == rhs.id
}

