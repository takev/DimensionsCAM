// DimensionsCAM - A multi-axis tool path generator for a milling machine
// Copyright (C) 2015  Take Vos
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

struct Triangle: CollectionType, Hashable {
    typealias Index = Int
    typealias Element = Vector3Fix10

    let A:  Element
    let B:  Element
    let C:  Element

    var a:          Edge    { return Edge(C, B) }
    var b:          Edge    { return Edge(A, C) }
    var c:          Edge    { return Edge(B, A) }
    var edges:      [Edge]  { return [a, b, c] }
    var normal:     Element { return (B - A) × (C - A) }
    var centroid:   Element { return (A + B + C) / 3 }
    var count:      Int     { return 3 }
    var endIndex:   Int     { return 3 }
    var startIndex: Int     { return 0 }
    var isEmpty:    Bool    { return false }
    var id:         UInt64  { return centroid.id }
    var hashValue:  Int     { return id.hashValue }

    /// The vertices must appear in counter-clockwise winding, the coordinate system is right-handed.
    init(_ A: Element, _ B: Element, _ C: Element) {
        self.A = A
        self.B = B
        self.C = C
    }

    subscript(index: Int) -> Element {
        switch index {
        case 0: return A
        case 1: return B
        case 2: return C
        default: preconditionFailure("Triangle only has three vertice.")
        }
    }

    /// Check if this triangle is convex with another triangle.
    func isConvex(other: Triangle) -> Bool {
        /// Draw a vector through the centroid of both triangles.
        for other_vertex in other {
            let centroid_vertex_line = other_vertex - self.centroid

            if (self.normal ∙ centroid_vertex_line.unit) >= Fix10(cos(90.0)) {
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
    return lhs.id == rhs.id
}

prefix func -(rhs: Triangle) -> Triangle {
    return Triangle(rhs.C, rhs.B, rhs.A)
}


