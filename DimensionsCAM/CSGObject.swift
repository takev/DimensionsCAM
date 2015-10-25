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

import simd

/// A constructive solid geometry object.
class CSGObject: CustomStringConvertible {
    weak var parent : CSGObject? = nil

    /// The position of this object within the enclosed object.
    var localTransformations: [double4x4] = []
    var globalTransformation = double4x4.identity

    /// The axis aligned bounding box of the CSG tree.
    var boundingBox = interval4()

    init() {
    }

    var description: String {
        let class_name = String(self.dynamicType)
        return "<\(class_name)>"
    }

    /// Update global transformation.
    /// This function recurses through the CSG tree and calculates the transformation
    /// need to transform a CSG primative to its final global location.
    func updateTransformation(parent_transformation: double4x4) {
        globalTransformation = double4x4.identity
        for localTransformation in localTransformations {
            globalTransformation = globalTransformation × localTransformation
        }
        globalTransformation = globalTransformation × parent_transformation
    }

    /// Update bounding box on this CSG (sub)tree.
    /// requirement: updateTransformation() must be called first.
    func updateBoundingBox() {
        preconditionFailure("Abstract method")
    }

    /// Update pre-calculations on the CSG object.
    func update(parent_transformation: double4x4) {
        updateTransformation(parent_transformation)
        updateBoundingBox()
    }

    /// Check if this CSG Object is intersecting an axis-aligned bounding box.
    /// - return: INSIDE, OUTSIDE or INTERSECTING with a CSG primative.
    func isIntersectingWith(with: Interval) -> CSGMatch {
        preconditionFailure("Abstract method")
    }

    

}