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

class TetrahedronMesh {
    var tetrahedron_by_centroid:    [UInt64:Tetrahedron]

    init() {
        self.tetrahedron_by_centroid = [:]
    }

    func copy() -> TetrahedronMesh {
        let tmp = TetrahedronMesh()

        for (_, tetrahedron) in tetrahedron_by_centroid {
            tmp.addTetrahedron(tetrahedron)
        }

        return tmp
    }

    func addTetrahedron(tetrahedron: Tetrahedron) {
        tetrahedron_by_centroid[tetrahedron.id] = tetrahedron
    }

    func toTriangleMesh() -> TriangleMesh {
        let triangle_mesh = TriangleMesh()

        for (_, tetrahedron) in tetrahedron_by_centroid {
            triangle_mesh.addTetrahedron(tetrahedron)
        }

        return triangle_mesh
    }
}
