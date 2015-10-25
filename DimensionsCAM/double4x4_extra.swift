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

extension double4x4 {
    static var identity: double4x4 {
        return double4x4(rows:[
            double4(1.0, 0.0, 0.0, 0.0),
            double4(0.0, 1.0, 0.0, 0.0),
            double4(0.0, 0.0, 1.0, 0.0),
            double4(0.0, 0.0, 0.0, 1.0)
        ])
    }

    init(translate: double4) {
        self.init(rows:[
            double4(1.0, 0.0, 0.0, translate.x),
            double4(0.0, 1.0, 0.0, translate.y),
            double4(0.0, 0.0, 1.0, translate.z),
            double4(0.0, 0.0, 0.0, translate.w)
        ])
    }

    public var description: String {
        return String(sep:"",
            "((\(self[0][0]), \(self[1][0]), \(self[2][0]), \(self[3][0])),",
            " (\(self[0][1]), \(self[1][1]), \(self[2][1]), \(self[3][1])),",
            " (\(self[0][2]), \(self[1][2]), \(self[2][2]), \(self[3][2])),",
            " (\(self[0][3]), \(self[1][3]), \(self[2][3]), \(self[3][3])))"
        )
    }
}

func ×(lhs: double4x4, rhs: double4x4) -> double4x4 {
    return lhs * rhs
}

func ×(lhs: double4x4, rhs: double4) -> double4 {
    return lhs * rhs
}

func ×(lhs: double4x4, rhs: interval4) -> interval4 {
    // double4x4 is in column-major order. So the first index selects which column, second index selects row.

    let x0 = lhs[0][0] * rhs.x
    let x1 = lhs[1][0] * rhs.y
    let x2 = lhs[2][0] * rhs.z
    let x3 = lhs[3][0] * rhs.w
    let x =  x0 + x1 + x2 + x3

    let y0 = lhs[0][1] * rhs.x
    let y1 = lhs[1][1] * rhs.y
    let y2 = lhs[2][1] * rhs.z
    let y3 = lhs[3][1] * rhs.w
    let y =  y0 + y1 + y2 + y3

    let z0 = lhs[0][2] * rhs.x
    let z1 = lhs[1][2] * rhs.y
    let z2 = lhs[2][2] * rhs.z
    let z3 = lhs[3][2] * rhs.w
    let z =  z0 + z1 + z2 + z3

    let w0 = lhs[0][3] * rhs.x
    let w1 = lhs[1][3] * rhs.y
    let w2 = lhs[2][3] * rhs.z
    let w3 = lhs[3][3] * rhs.w
    let w =  w0 + w1 + w2 + w3

    return interval4(x, y, z, w)
}

public func ==(lhs: double4x4, rhs: double4x4) -> Bool {
    for r in 0 ..< 4 {
        if lhs[r] != rhs[r] {
            return false
        }
    }
    return true
}

public func !=(lhs: double4x4, rhs: double4x4) -> Bool {
    return !(lhs == rhs)
}
