//
//  CSGPlane.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-28.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//


import simd

class CSGPlane: CSGPrimative {
    let normal: double4
    let position: double4

    override init() {
        normal = double4(1.0, 0.0, 0.0, 0.0)
        position = double4(0.0, 0.0, 0.0, 1.0)

        super.init()
    }

    override func normalAt(at: Interval) -> double4 {
        return normal
    }


}
