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

extension double4 {
    var xyz: double3 { return double3(x, y, z) }

    init(_ xyz: double3, _ w: Double) {
        self.init(xyz.x, xyz.y, xyz.z, w)
    }
}

func ∙(lhs: double4, rhs: double4) -> Double {
    return dot(lhs, rhs)
}

func ×(lhs: double4, rhs: double4) -> double4 {
    return double4(cross(lhs.xyz, rhs.xyz), 0.0)
}

public func ==(lhs: double4, rhs: double4) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
}

public func !=(lhs: double4, rhs: double4) -> Bool {
    return !(lhs == rhs)
}
