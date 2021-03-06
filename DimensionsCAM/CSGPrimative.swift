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

/// A constructive solid primative.
/// A primative is a CGS object that has a surface and is not a combination
/// of other CSG objects.
class CSGPrimative: CSGObject {
    var index: Int? = nil

    /// The normal at the AABBox.
    /// This function may return an estimation or average of the normal since the AABBox
    /// will intersect a surface area, instead of a single point.
    func normalAt(at: Interval) -> double4 {
        preconditionFailure("Abstract method")
    }

    override func enumeratePrimatives(index: Int = 0) -> Int {
        self.index = index
        return index + 1
    }

    /// The characteristic of a function.
    /// - returns: < 1.0 inside, > 1.0 outisde, otherwise intersecting.
    func characteristic(with: interval4) -> Interval {
        preconditionFailure("Abstract method")
    }

    override func isIntersectingWith(with: interval4) -> CSGMatch {
        let box = globalTransformation × with

        let value = characteristic(box)

        if value < 1.0 {
            return .INSIDE
        } else if value > 1.0 {
            return .OUTSIDE
        } else {
            return .SURFACE(index)
        }
    }

}
