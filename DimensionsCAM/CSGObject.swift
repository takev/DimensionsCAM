//
//  CSGObject.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-27.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//


import simd

/// A constructive solid geometry object.
class CSGObject: CustomStringConvertible {
    weak var parent : CSGObject? = nil

    /// The position of this object within the enclosed object.
    var local_transformations: [double4x4] = []
    var global_transformation = double4x4()

    init() {
    }

    var description: String {
        let class_name = String(self.dynamicType)
        return "<\(class_name)>"
    }

    func updateTransformation(parent_transformation: double4x4) {
        global_transformation = double4x4()
        for local_transformation in local_transformations {
            global_transformation = global_transformation × local_transformation
        }
        global_transformation = global_transformation × parent_transformation
    }

    /// Check if this CSG Object is intersecting an axis-aligned bounding box.
    /// - return: INSIDE, OUTSIDE or INTERSECTING with a CSG primative.
    func isIntersectingWith(with: Interval) -> CSGMatch {
        preconditionFailure("Abstract method")
    }

    

}