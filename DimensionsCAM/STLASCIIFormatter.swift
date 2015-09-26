//
//  STLASCIIFormatter.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-23.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

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
