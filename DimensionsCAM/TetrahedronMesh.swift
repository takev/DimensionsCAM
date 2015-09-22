//
//  TetrahedronMesh.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-21.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

class TetrahedronMesh {
    var tetrahedron_by_centroid:    [Int64:Tetrahedron]

    init() {
        self.tetrahedron_by_centroid = [:]
    }

    func copy() -> TetrahedronMesh {
        let tmp = TetrahedronMesh(name: name + " copy")

        for (_, tetrahedron) in tetrahedron_by_centroid {
            tmp.addTetrahedron(tetrahedron)
        }

        return tmp
    }

    func addTetrahedron(tetrahedron: Tetrahedron) {
        tetrahedron_by_centroid[tetrahedron.gridId] = tetrahedron
    }

    func toTriangleMesh() -> TriangleMesh {
        let triangle_mesh = TriangleMesh()

        for (_, tetrahedron) in tetrahedron_by_centroid {
            triangle_mesh.addTetrahedron(tetrahedron)
        }

        return triangle_mesh
    }
}
