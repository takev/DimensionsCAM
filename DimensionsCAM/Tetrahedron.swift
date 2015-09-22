//
//  Tetrahedron.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-13.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

///                       A
///                      /.\
///                     / . \
///                    /  .  \
///                   /   .   \
///                  /    .    \
///                 /     .     \
///                /      .      \
///               /     . D .     \
///              /    .       .    \
///             /   .           .   \
///            /  .               .  \
///           / .                   . \
///          /.                       .\
///        B --------------------------- C
///
///
///
class Tetrahedron: CollectionType, Hashable {
    typealias Index = Int
    typealias Element = double4

    let A:  double4
    let B:  double4
    let C:  double4
    let D:  double4

    var a:          Triangle    { return Triangle(D, C, B) }
    var b:          Triangle    { return Triangle(A, C, D) }
    var c:          Triangle    { return Triangle(A, D, B) }
    var d:          Triangle    { return Triangle(A, B, C) }
    var triangles:  [Triangle]  { return [a, b, c, d] }

    var centroid:   double4 { return (A + B + C + D) / 4.0 }
    var count:      Int     { return 4 }
    var endIndex:   Int     { return 4 }
    var startIndex: Int     { return 0 }
    var isEmpty:    Bool    { return false }
    var gridId:     Int64   { return centroid.gridId }
    var hashValue:  Int     { return gridId.hashValue }

    init(_ A: double4, _ B: double4, _ C: double4, _ D: double4) {
        self.A = A
        self.B = B
        self.C = C
        self.D = D
    }

    subscript(index: Int) -> double4 {
        switch index {
        case 0: return A
        case 1: return B
        case 2: return C
        case 3: return D
        default: assertionFailure("Triangle only has three vertice.")
        }
    }
}

func ==(lhs: Tetrahedron, rhs: Tetrahedron) -> Bool {
    return lhs.gridId == rhs.gridId
}

