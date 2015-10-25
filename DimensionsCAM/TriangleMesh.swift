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

class TriangleMesh {
    var triangle_by_centroid:   [UInt64:Triangle]
    var triangles_by_vertex:    [UInt64:CSet<Triangle>]
    var triangles_by_edge:      [UInt64:CSet<Triangle>]

    init() {
        triangle_by_centroid = [:]
        triangles_by_vertex = [:]
        triangles_by_edge = [:]
    }

    func postProcess() {
    }
    
    func copy() -> TriangleMesh {
        let new_mesh = TriangleMesh()

        for (_, triangle) in triangle_by_centroid {
            new_mesh.addTriangle(triangle)
        }

        return new_mesh
    }

    func contains(triangle: Triangle) -> Bool {
        if let _ = triangle_by_centroid[triangle.id] {
            return true
        } else {
            return false
        }
    }

    func addTriangle(triangle: Triangle) {
        if triangle_by_centroid[triangle.id] != nil {
            preconditionFailure("Triangle already exists")
        }

        // Add triangle to various tables.
        triangle_by_centroid[triangle.id] = triangle

        for vertex in triangle {
            let vertex_triangles = triangles_by_vertex.setdefault(vertex.id, default_value: CSet<Triangle>())
            vertex_triangles.insert(triangle)
        }
        for edge in triangle.edges {
            let edge_triangles = triangles_by_edge.setdefault(edge.id, default_value: CSet<Triangle>())
            edge_triangles.insert(triangle)
        }
    }

    func removeTriangle(triangle: Triangle) {
        for vertex in triangle {
            if let vertex_triangles = triangles_by_vertex[vertex.id] {
                vertex_triangles.remove(triangle)
            }
        }
        for edge in triangle.edges {
            if let edge_triangles = triangles_by_edge[edge.id] {
                edge_triangles.remove(triangle)
            }
        }
        triangle_by_centroid.removeValueForKey(triangle.centroid.id)
    }

    func getNeighbours(current: Triangle) -> Set<Triangle> {
        var neighbours = Set<Triangle>()

        for edge in current.edges {
            if let triangles = triangles_by_edge[edge.centroid.id] {
                assert(triangles.count == 2, "Each edge should have two triangles.")
                for neighbour in triangles {
                    if (neighbour == current) {
                        continue
                    } else {
                        neighbours.insert(neighbour)
                    }
                }
            } else {
                assertionFailure("Could not find current triangle in triangles_by_edge")
            }
        }

        return neighbours
    }

    /// Find a neighbour
    func getConvexNeighbour(current: Triangle) -> Triangle? {
        for candidate in getNeighbours(current) {
            // A neighbour must be convex.
            // A neighbour must not be in the same plane.
            if current.isConvex(candidate) && !current.isParralel(candidate) {
                return candidate
            }
        }
        return nil
    }

    // To remove a tetrahedron we need to find if its triangles belong to the mesh.
    // If a triangle is part of the mesh, it simply needs to be removed.
    // When a triangle isn't part of the mesh, the inverse triangle needs to be added.
    func removeTetrahedron(tetrahedron: Tetrahedron) {
        for triangle in tetrahedron.triangles {
            if contains(triangle) {
                removeTriangle(triangle)
            } else {
                addTriangle(-triangle)
            }
        }
    }

    // To add a tetrahedron we find if its triangles already belong to the mesh.
    // If the inverse triangle is part of the mesh, it is removed.
    // If the triangle isn't part of the mesh, the triangle is added.
    // This is exactly the same as removeTetrahedron.
    func addTetrahedron(tetrahedron: Tetrahedron) {
        for triangle in tetrahedron.triangles {
            if contains(-triangle) {
                removeTriangle(-triangle)
            } else {
                assert(!contains(triangle), "Expect the triangle not to exist yet in the mesh.")
                addTriangle(triangle)
            }
        }
    }

    func extractTetrahedron(t1: Triangle, _ t2: Triangle) -> Tetrahedron {
            let not_ABC_vertices = t2 - t1
            assert(not_ABC_vertices.count == 1, "Expect the two triangles of a tetrahedron to be neighbours and only have 1 vertex not in common")

            let A = t1.A
            let B = t1.B
            let C = t1.C
            let D = not_ABC_vertices[0]

            let tetrahedron = Tetrahedron(A, B, C, D)

            // Remove the tetrahedron from the model.
            removeTetrahedron(tetrahedron)
            return tetrahedron
    }

    func toTetrahedronMesh() -> TetrahedronMesh {
        let tetrahedron_mesh = TetrahedronMesh()

        for (_, triangle) in triangle_by_centroid {
            Swift.print("Found a triangle")

            guard let neighbour = getConvexNeighbour(triangle) else {
                continue
            }

            let tetrahedron = extractTetrahedron(triangle, neighbour)

            tetrahedron_mesh.addTetrahedron(tetrahedron)
        }

        return tetrahedron_mesh
    }


}
