//
//  CSGObject.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-27.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

/// A constructive solid geometry object.
class CSGObject {
    /// The position of this object within the enclosed object.
    let transformation: double4x4

    init(transformation: double4x4) {
        self.transformation = transformation
    }

    /// Check if this CSG Object is intersecting an axis-aligned bounding box.
    /// - return: INSIDE, OUTSIDE or INTERSECTING with a CSG primative.
    func isIntersectingWith(with: AABBox) -> CSGIntersect {
        preconditionFailure("Abstract method")
    }

    

}