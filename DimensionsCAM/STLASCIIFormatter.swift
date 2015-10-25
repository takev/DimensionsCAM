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

func STLFormatASCII(mesh: TriangleMesh) -> String {
    var strings: [String] = []

    strings.append("solid DimensionsCam_Model\n")
    for (_, triangle) in mesh.triangle_by_centroid {
        strings.append("  facet normal \(Double(triangle.normal.x)) \(Double(triangle.normal.y)) \(Double(triangle.normal.z))\n")
        strings.append("    outer loop\n")
        strings.append("      vertex \(Double(triangle.A.x)) \(Double(triangle.A.y)) \(Double(triangle.A.z))\n")
        strings.append("      vertex \(Double(triangle.B.x)) \(Double(triangle.B.y)) \(Double(triangle.B.z))\n")
        strings.append("      vertex \(Double(triangle.C.x)) \(Double(triangle.C.y)) \(Double(triangle.C.z))\n")
        strings.append("    endloop\n")
        strings.append("  endfacet\n")
    }
    strings.append("endsolid DimensionsCam_Model\n")

    return strings.joinWithSeparator("")
}
