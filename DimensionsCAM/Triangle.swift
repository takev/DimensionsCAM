//
//  Triangle.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-08.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

class Triangle: Simplex {
    let normal: double4

    init(vertices: Set<Vertex>, normal: double4) {
        assert(vertices.count == 3, "Expecting triangle with only three vertices")
        self.normal = normal
        super.init(vertices: vertices)
    }

    /// Check if this triangle is convex with another triangle.
    func isConvex(other: Triangle) -> Bool {
        /// Draw a vector through the centroid of both triangles.
        for other_vertex in other.vertices {
            let centroid_vertex_line = other_vertex.point - self.centroid

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

