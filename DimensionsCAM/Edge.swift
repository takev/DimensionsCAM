//
//  Edge.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-20.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

struct Edge: CollectionType, Hashable {
    typealias Index = Int
    typealias Element = double4

    let A:  double4
    let B:  double4

    var centroid:   double4 { return (A + B) / 2.0 }
    var count:      Int     { return 2 }
    var endIndex:   Int     { return 2 }
    var startIndex: Int     { return 0 }
    var isEmpty:    Bool    { return false }
    var gridId:     Int64   { return centroid.gridId }
    var hashValue:  Int     { return gridId.hashValue }

    /// The vertices must appear in counter-clockwise winding, the coordinate system is right-handed.
    init(_ A: double4, _ B: double4) {
        self.A = A
        self.B = B
    }

    subscript(index: Int) -> double4 {
        switch index {
        case 0: return A
        case 1: return B
        default: assertionFailure("Triangle only has three vertice.")
        }
    }
}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.gridId == rhs.gridId
}

