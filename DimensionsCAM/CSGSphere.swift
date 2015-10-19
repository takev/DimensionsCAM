//
//  CSGSphere.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-19.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

class CSGSphere: CSGPrimative {
    var size: double3

    init(size: double3) {
        self.size = size
    }

    override var description: String {
        return "<CSGSphere size=\(size)>"
    }
}
