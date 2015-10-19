//
//  CSGCylinder.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-19.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

class CSGCylinder: CSGPrimative {
    var height: Double
    var diameter_bottom: Double
    var diameter_top: Double

    init(height: Double, diameter_bottom: Double, diameter_top: Double) {
        self.height = height
        self.diameter_bottom = diameter_bottom
        self.diameter_top = diameter_top
    }

    override var description: String {
        return "<CSGSphere height=\(height), diameter_bottom=\(diameter_bottom), diameter_top=\(diameter_top)>"
    }
}
