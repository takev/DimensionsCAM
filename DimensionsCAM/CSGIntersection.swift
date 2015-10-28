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

class CSGIntersection : CSGOperation {

    override func updateBoundingBox() {
        super.updateBoundingBox()

        // Make a union of all the bounding boxes.
        // Possibly we can do an intersection, but I am not sure.
        boundingBox = children[0].boundingBox
        for i in 1 ..< children.count {
            boundingBox = boundingBox ⩂ children[i].boundingBox
        }
    }

    override func isIntersectingWith(with: interval4) -> CSGMatch {
        var r = CSGMatch.INSIDE

        for child in children {
            switch child.isIntersectingWith(with) {
            case .INSIDE:
                // We don't know anything, all children must be INSIDE to know.
                break

            case .OUTSIDE:
                // When one child is outside, then the intersection of all childs is outside.
                return .OUTSIDE

            case .SURFACE(let primative_index):
                // When a child's surface is intersecting the voxel it may still be inside
                // another child, or it may also intersect the surface of another child.
                // When two childs intersect we should return nil.
                if case .INSIDE = r {
                    r = .SURFACE(primative_index)
                } else {
                    r = .SURFACE(nil)
                }
            }
        }

        return r
    }
}
