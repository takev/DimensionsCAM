//
//  CSGObject.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-27.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//


import simd

/// A constructive solid geometry object.
class CSGObject {
    /// The position of this object within the enclosed object.
    let local_transformation: double4x4
    var global_transformation: double4x4

    init(transformation: double4x4) {
        local_transformation = transformation
        global_transformation = double4x4()
    }

    func updateTransformation(parent_transformation: double4x4) {
        global_transformation = local_transformation × parent_transformation
    }

    /// Check if this CSG Object is intersecting an axis-aligned bounding box.
    /// - return: INSIDE, OUTSIDE or INTERSECTING with a CSG primative.
    func isIntersectingWith(with: Interval) -> CSGIntersect {
        preconditionFailure("Abstract method")
    }

    

}