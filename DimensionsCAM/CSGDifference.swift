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

class CSGDifference : CSGOperation {

    override func updateBoundingBox() {
        super.updateBoundingBox()

        // Only look at the first child
        // The other childs could be subtracted if it overlaps on two axis, we don't care right now.
        boundingBox = children[0].boundingBox
    }

    override func isIntersectingWith(with: interval4) -> CSGMatch {
        var r = children[0].isIntersectingWith(with)

        for i in 0 ..< children.count {
            let child = children[i]

            switch child.isIntersectingWith(with) {
            case .INSIDE:
                // When a voxel is fully inside one of the children it means it is subtracted
                // from any other, so it is outside the model.
                return .OUTSIDE

            case .OUTSIDE:
                // When a child is outside nothing changes.
                break

            case .SURFACE(let primative_index):
                // When a child's surface is intersecting the voxel it may still be inside
                // another child, or it may also intersect the surface of another child.
                // When two childs intersect we should return nil.
                if case .OUTSIDE = r {
                    r = .SURFACE(primative_index)
                } else {
                    r = .SURFACE(nil)
                }
            }
        }

        return r
    }

}
