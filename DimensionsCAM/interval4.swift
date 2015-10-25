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

struct interval4: CustomStringConvertible {
    let x: Interval
    let y: Interval
    let z: Interval
    let w: Interval

    init() {
        x = Interval()
        y = Interval()
        z = Interval()
        w = Interval()
    }

    init(_ a: [Double]) {
        x = Interval(a[0])
        y = Interval(a[1])
        z = Interval(a[2])
        w = Interval(a[3])
    }

    init(_ a: [Interval]) {
        x = a[0]
        y = a[1]
        z = a[2]
        w = a[3]
    }

    init(_ x: Interval, _ y: Interval, _ z: Interval, _ w: Interval) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    var description: String {
        return "(\(x), \(y), \(z), \(w))"
    }
}

func dot(lhs: interval4, _ rhs: interval4) -> Interval {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Expect dot product on two vectors, not points")
    return (
        lhs.x.square +
        lhs.y.square +
        lhs.z.square
    )
}

func cross(lhs: interval4, _ rhs: interval4) -> interval4 {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Expect dot product on two vectors, not points")
    let x0 = lhs.y * rhs.z
    let x1 = lhs.z * rhs.y
    let x = x0 - x1

    let y0 = lhs.z * rhs.x
    let y1 = lhs.x * rhs.z
    let y = y0 - y1

    let z0 = lhs.x * rhs.y
    let z1 = lhs.y * rhs.x
    let z = z0 - z1

    return interval4([x, y, z, Interval(0.0)])
}

func ∙(lhs: interval4, rhs: interval4) -> Interval {
    return dot(lhs, rhs)
}

func ×(lhs: interval4, rhs: interval4) -> interval4 {
    return cross(lhs, rhs)
}

/// A hull over two axis aligned bounding box.
func ⩂(lhs: interval4, rhs: interval4) -> interval4 {
    return interval4(
        lhs.x ⩂ rhs.x,
        lhs.y ⩂ rhs.y,
        lhs.z ⩂ rhs.z,
        lhs.w ⩂ rhs.w
    )
}
