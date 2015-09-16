//
//  TriangleMesh.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-07.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

class TriangleMesh {
    var name:                   String
    var triangles_by_centroid:  [double4:Triangle]
    var vertices_by_point:      [double4:Vertex]

    init(name: String) {
        self.name = name
        triangles_by_centroid = [:]
        vertices_by_point = [:]
    }

    func copy() -> TriangleMesh {
        let new_mesh = TriangleMesh(name: name + "(copy)")

        for (_, triangle) in triangles_by_centroid {
            new_mesh.addTriangle(triangle.points, normal: triangle.normal)
        }

        return new_mesh
    }

    func addTriangle(points: Set<double4>, normal: double4) {
        assert(points.count == 3, "Expecting 3 points for a triangle")

        var vertices = Set<Vertex>()
        for point in points {
            let vertex = vertices_by_point.setdefault(point, default_value:Vertex(point))
            vertices.insert(vertex)
        }

        let triangle = Triangle(vertices: vertices, normal: normal)

        for vertex in vertices {
            vertex.addSimplex(triangle)
        }

        triangles_by_centroid[triangle.centroid] = triangle
    }

    func removeTriangle(triangle: Triangle) {
        for vertex in triangle {
            vertex.removeSimplex(triangle)
        }
        triangles_by_centroid.removeValueForKey(triangle.centroid)
    }

    /// Gather all vertices of the lowest order.
    ///
    func getLowOrderVertices(minimum_order: Int = 3) -> Set<Vertex> {
        // Set lowest_found_order to the maximum possible.
        var lowest_found_order: Int? = nil
        var found_vertices = Set<Vertex>()

        for vertex in vertices_by_point.values {
            if vertex.count < minimum_order {
                continue
            }

            if lowest_found_order == nil || vertex.count < lowest_found_order! {
                // This vertex is lower then previous found, clear the set.
                lowest_found_order = vertex.count
                found_vertices.removeAll()
            }
            found_vertices.insert(vertex)
        }
        return found_vertices
    }

    /* func triangulateAtVertex(vertex: Vertex) -> Tetrahedron {

    } */

    /// Find a neighbour
    func getConvexNeighbour(triangle: Triangle) -> Triangle? {
        for vertex in triangle.vertices {
            for candidate in vertex.simplices as! Set<Triangle> {
                let shared_vertices = triangle.vertices.intersect(candidate.vertices)

                // A neighbour has exactly n-1 vertices in common.
                // A neighbour must be convex.
                // A neighbour must not be in the same plane.
                if (
                    (shared_vertices.count == candidate.count - 1) &&
                    triangle.isConvex(candidate) &&
                    !triangle.isParralel(candidate)
                ) {
                    return candidate
                }
            }
        }
        return nil
    }

    func triangulate() {
        var tmp_mesh = self.copy()

        for (_, triangle) in triangles_by_centroid {
            guard let neighbour = getConvexNeighbour(triangle) else {
                continue
            }

        }
    }


}
