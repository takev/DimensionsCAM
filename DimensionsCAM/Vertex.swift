//
//  Vertex.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-08.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

class Vertex: Hashable {
    let point:    double4
    var simplices:   Set<Simplex>

    init(_ point: double4) {
        self.point = point
        self.simplices = Set<Simplex>()
    }

    var hashValue : Int {
        return point.x.hashValue
    }

    var count : Int {
        return simplices.count
    }

    func addSimplex(simplex: Simplex) {
        simplices.insert(simplex)
    }

    func removeSimplex(simplex: Simplex) {
        simplices.remove(simplex)
    }
}

func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.point == rhs.point
}

/*func +(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.point + rhs.point
}

func -(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.point - rhs.point
}*/
