//
//  Triangle.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-08.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

struct Triangle: CollectionType, Hashable {
    typealias Index = Int
    typealias Element = double4

    let A:  double4
    let B:  double4
    let C:  double4

    var a:          Edge    { return Edge(C, B) }
    var b:          Edge    { return Edge(A, C) }
    var c:          Edge    { return Edge(B, A) }
    var edges:      [Edge]  { return [a, b, c] }
    var normal:     double4 { return (B - A) × (C - A) }
    var centroid:   double4 { return (A + B + C) / 3.0 }
    var count:      Int     { return 3 }
    var endIndex:   Int     { return 3 }
    var startIndex: Int     { return 0 }
    var isEmpty:    Bool    { return false }
    var gridId:     Int64   { return centroid.gridId }
    var hashValue:  Int     { return gridId.hashValue }

    /// The vertices must appear in counter-clockwise winding, the coordinate system is right-handed.
    init(_ A: double4, _ B: double4, _ C: double4) {
        self.A = A
        self.B = B
        self.C = C
    }

    subscript(index: Int) -> double4 {
        switch index {
        case 0: return A
        case 1: return B
        case 2: return C
        default: assertionFailure("Triangle only has three vertice.")
        }
    }

    /// Check if this triangle is convex with another triangle.
    func isConvex(other: Triangle) -> Bool {
        /// Draw a vector through the centroid of both triangles.
        for other_vertex in other {
            let centroid_vertex_line = other_vertex - self.centroid

            if self.normal ∙ centroid_vertex_line.unit >= cos(90.0) {
                // Other vertex is not visible on the inside of this triangle.
                return false
            }
        }

        return true
    }

    func isParralel(other: Triangle) -> Bool {
        return self.normal == other.normal
    }


}

func ==(lhs: Triangle, rhs: Triangle) -> Bool {
    return lhs.gridId == rhs.gridId
}

prefix func -(rhs: Triangle) -> Triangle {
    return Triangle(rhs.C, rhs.B, rhs.A)
}


