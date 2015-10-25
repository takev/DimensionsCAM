//
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

class CSGCube: CSGPrimative {
    var size: double3

    init(size: double3) {
        self.size = size
    }

    override var description: String {
        let class_name = String(self.dynamicType)
        return "<\(class_name) size=\(size)>"
    }
    
    override func updateBoundingBox() {
        let tmp = interval4(
            Interval(-0.5 * size.x, 0.5 * size.x),
            Interval(-0.5 * size.y, 0.5 * size.y),
            Interval(-0.5 * size.z, 0.5 * size.z),
            Interval(0.0)
        )

        boundingBox = globalTransformation × tmp
    }
}
