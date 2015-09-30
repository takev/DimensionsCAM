//
//  CSGPrimative.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-28.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

/// A constructive solid primative.
/// A primative is a CGS object that has a surface and is not a combination
/// of other CSG objects.
class CSGPrimative: CSGObject {

    /// The normal at the AABBox.
    /// This function may return an estimation or average of the normal since the AABBox
    /// will intersect a surface area, instead of a single point.
    func normalAt(at: AABBox) -> double4 {
        preconditionFailure("Abstract method")
    }


}
