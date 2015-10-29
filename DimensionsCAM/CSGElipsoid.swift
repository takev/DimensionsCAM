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

class CSGElipsoid: CSGPrimative {
    /// 3D diameter of the Elipsoid.
    var size: double3
    var half_size: double3

    init(size: double3) {
        self.size = size
        self.half_size = size * 0.5
    }

    override var description: String {
        let class_name = String(self.dynamicType)
        return "<\(class_name) size=\(size)>"
    }
    
    override func updateBoundingBox() {
        let tmp = interval4(
            Interval(-0.5 * half_size.x, 0.5 * half_size.x),
            Interval(-0.5 * half_size.y, 0.5 * half_size.y),
            Interval(-0.5 * half_size.z, 0.5 * half_size.z),
            Interval(1.0)
        )

        boundingBox = globalTransformation × tmp
    }

    override func characteristic(with: interval4) -> Interval {
        let x = (with.x ** 2) / (size.x ** 2)
        let y = (with.y ** 2) / (size.y ** 2)
        let z = (with.z ** 2) / (size.z ** 2)
        return x + y + z
    }


}
