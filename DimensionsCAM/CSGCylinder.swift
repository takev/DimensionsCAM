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

class CSGCylinder: CSGPrimative {
    var height: Double
    var diameter_bottom: Double
    var diameter_top: Double

    init(height: Double, diameter_bottom: Double, diameter_top: Double) {
        self.height = height
        self.diameter_bottom = diameter_bottom
        self.diameter_top = diameter_top
    }

    override var description: String {
        let class_name = String(self.dynamicType)
        return "<\(class_name) height=\(height), diameter_bottom=\(diameter_bottom), diameter_top=\(diameter_top)>"
    }

    override func updateBoundingBox() {
        let size = max(diameter_top, diameter_bottom)
        let tmp = interval4(
            Interval(-0.5 * size, 0.5 * size),
            Interval(-0.5 * size, 0.5 * size),
            Interval(-0.5 * height, 0.5 * height),
            Interval(1.0)
        )

        boundingBox = globalTransformation × tmp
    }
}
