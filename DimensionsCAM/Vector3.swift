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

protocol Vector3ElementType: NumericOperationsType, NumericConvertible, Hashable {
}

struct Vector3<T: Vector3ElementType>: NumericOperationsType, Hashable {
    typealias Element = T

    let x: T
    let y: T
    let z: T

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = Element(x)
        self.y = Element(y)
        self.z = Element(z)
    }

    init(_ x: T, _ y: T, _ z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    var hashValue: Int {
        return x.hashValue ^ y.hashValue ^ z.hashValue;
    }

    var id: UInt64 {
        return (
            (z.id << 42) |
            (y.id << 21) |
            x.id
        )
    }

    var length: Element {
        return Element(sqrt(Double(self ∙ self)))
    }

    var unit: Vector3<T> {
        return self / length
    }
}

func ==<T: Equatable>(lhs: Vector3<T>, rhs: Vector3<T>) -> Bool {
    return (
        lhs.x == rhs.x &&
        lhs.y == rhs.y &&
        lhs.z == rhs.z
    )
}

func +<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> Vector3<T> {
    return Vector3<T>(
        lhs.x + rhs.x,
        lhs.y + rhs.y,
        lhs.z + rhs.z
    )
}

func -<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> Vector3<T> {
    return Vector3<T>(
        lhs.x - rhs.x,
        lhs.y - rhs.y,
        lhs.z - rhs.z
    )
}

func *<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> Vector3<T> {
    return Vector3<T>(
        lhs.x * rhs.x,
        lhs.y * rhs.y,
        lhs.z * rhs.z
    )
}

func *<T: NumericOperationsType>(lhs: Vector3<T>, rhs: T) -> Vector3<T> {
    return Vector3<T>(
        lhs.x * rhs,
        lhs.y * rhs,
        lhs.z * rhs
    )
}

func /<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> Vector3<T> {
    return Vector3<T>(
        lhs.x / rhs.x,
        lhs.y / rhs.y,
        lhs.z / rhs.z
    )
}

func /<T: NumericOperationsType>(lhs: Vector3<T>, rhs: T) -> Vector3<T> {
    return Vector3<T>(
        lhs.x / rhs,
        lhs.y / rhs,
        lhs.z / rhs
    )
}

func ∙<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> T {
    return (
        lhs.x * rhs.x +
        lhs.y * rhs.y +
        lhs.z * rhs.z
    )
}

func ×<T: NumericOperationsType>(lhs: Vector3<T>, rhs: Vector3<T>) -> Vector3<T> {
    return Vector3<T>(
        lhs.y * rhs.z - lhs.z * rhs.y,
        lhs.z * rhs.x - lhs.x * rhs.z,
        lhs.x * rhs.y - lhs.y * rhs.x
    )
}

extension FixedPoint: Vector3ElementType {
}
extension Double: Vector3ElementType {
}

typealias Vector3Fix10 = Vector3<Fix10>
typealias Vector3Double = Vector3<Double>

