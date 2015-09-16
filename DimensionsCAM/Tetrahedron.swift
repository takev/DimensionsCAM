//
//  Tetrahedron.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-13.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

class Tetrahedron: Simplex {
    override init(vertices: Set<Vertex>) {
        assert(vertices.count == 4, "Expecting tetrahedron with only four vertices")
        super.init(vertices: vertices)
    }

}