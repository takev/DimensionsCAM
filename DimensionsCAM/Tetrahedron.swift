//
//  Tetrahedron.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-13.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//



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
    typealias Element = Vector3Fix10

    let A:  Vector3Fix10
    let B:  Vector3Fix10
    let C:  Vector3Fix10
    let D:  Vector3Fix10

    var a:          Triangle    { return Triangle(D, C, B) }
    var b:          Triangle    { return Triangle(A, C, D) }
    var c:          Triangle    { return Triangle(A, D, B) }
    var d:          Triangle    { return Triangle(A, B, C) }
    var triangles:  [Triangle]  { return [a, b, c, d] }

    var centroid:   Vector3Fix10 { return (A + B + C + D) / 4 }
    var count:      Int     { return 4 }
    var endIndex:   Int     { return 4 }
    var startIndex: Int     { return 0 }
    var isEmpty:    Bool    { return false }
    var id:         UInt64  { return centroid.id }
    var hashValue:  Int     { return id.hashValue }

    init(_ A: Vector3Fix10, _ B: Vector3Fix10, _ C: Vector3Fix10, _ D: Vector3Fix10) {
        self.A = A
        self.B = B
        self.C = C
        self.D = D
    }

    subscript(index: Int) -> Vector3Fix10 {
        switch index {
        case 0: return A
        case 1: return B
        case 2: return C
        case 3: return D
        default: preconditionFailure("Triangle only has three vertice.")
        }
    }
}

func ==(lhs: Tetrahedron, rhs: Tetrahedron) -> Bool {
    return lhs.id == rhs.id
}

