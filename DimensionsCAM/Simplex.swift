//
//  Simplex.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-13.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

class Simplex: Hashable, SequenceType {
    let centroid: double4
    let vertices: Set<Vertex>

    var points : Set<double4> {
        var tmp = Set<double4>()

        for vertex in vertices {
            tmp.insert(vertex.point)
        }
        return tmp
    }

    init(vertices: Set<Vertex>) {
        self.vertices = vertices

        var total = double4()
        for vertex in vertices {
            total = total + vertex.point
        }
        self.centroid = total / Double(vertices.count)
    }

    /*subscript(i: Int) -> Vertex {
        return vertices[i]
    }*/

    func generate() -> SetGenerator<Vertex> {
        return vertices.generate()
    }

    var hashValue: Int {
        return centroid.hashValue
    }

    var count: Int {
        return vertices.count
    }

    /* func edge(a: Int, b: Int) -> fix3 {
        return self[b] - self[a]
    }

    func edge_length(a: Int, b: Int) -> fix3 {
        return edge(a, b).length
    } */
}

func ==(lhs: Simplex, rhs: Simplex) -> Bool {
    if lhs.count != rhs.count {
        // Number of vertices is different.
        return false;
    }

    return lhs.centroid == rhs.centroid
}


