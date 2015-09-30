//
//  Interval.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-28.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

/// An interval.
/// This object is inspired a lot by: INTERVAL ARITHMETIC USING SSE-2 (BRANIMIR LAMBOV)
///
/// The FPU and SSE-2 need to be configured to round to negative infinty when executing many operation.
/// - see: Interval.setRoundMode()
///
struct Interval: Equatable, Hashable, Comparable, CustomStringConvertible, IntegerLiteralConvertible, FloatLiteralConvertible, ArrayLiteralConvertible {
    typealias Element = Double

    /// The interval is stored with the lower bound stored in the first element and
    /// the upper bound stored in the second element as a negated number.
    let value: double2

    init(_ low: Double, _ high: Double) {
        value = double2(low, -high)
    }

    init(_ range: double2) {
        value = double2(range.x, -range.y)
    }

    init(raw: double2) {
        value = raw
    }

    init(_ value: Double) {
        self.value = double2(value, -value)
    }

    init(integerLiteral value: IntegerLiteralType) {
        self.value = double2(Double(value), -Double(value))
    }

    init(floatLiteral value: FloatLiteralType) {
        self.value = double2(Double(value), -Double(value))
    }

    init(arrayLiteral elements: Element...) {
        switch (elements.count) {
        case 0:
            value = double2(Double.infinity, Double.infinity)
        case 1:
            value = double2(elements[0], -elements[0])
        case 2:
            value = double2(elements[0], -elements[1])
        default:
            preconditionFailure("Expect 0, 1 or 2 elements in a interval literal")
        }
    }

    var isZero: Bool {
        return self == 0.0
    }

    var isScalar: Bool {
        return value.x == -value.y
    }

    var isNaN: Bool {
        return value.x.isNaN || value.y.isNaN
    }

    var isEntire: Bool {
        return (
            value.x.isInfinite && value.x < 0.0 &&
            value.y.isInfinite && value.y < 0.0
        )
    }

    var isEmpty: Bool {
        return value.x > -value.y
    }

    var description: String {
        if isEmpty {
            return "⟨empty⟩"
        } else if isEntire {
            return "⟨entire⟩"
        } else if isNaN {
            return "⟨NaN⟩"
        } else if isScalar {
            return "⟨\(value.x)⟩"
        } else {
            return "⟨\(value.x), \(-value.y)⟩"
        }
    }

    var hashValue: Int {
        if isEmpty {
            return 0
        } else {
            return value.x.hashValue ^ value.y.hashValue
        }
    }

    /// When you use interval arithmatic you should first use setRoundMode()
    /// to force the FPU and SSE to round to negative infinity.
    ///
    /// Example to use at the start of a function that uses interval arithmatic:
    /// ```swift
    /// let previous_round_mode = Interval.setRoundMode()
    /// defer { Interval.unsetRoundMode(previous_round_mode) }
    /// ```
    static func setRoundMode(mode: Int32 = FE_DOWNWARD) -> Int32 {
        let round_mode = fegetround()

        if round_mode != mode {
            fesetround(mode)
        }

        return round_mode
    }

    static func unsetRoundMode(old_round_mode: Int32) {
        if old_round_mode != fegetround() {
            fesetround(old_round_mode)
        }
    }

    static func isCorrectRoundMode() -> Bool {
        return fegetround() == FE_DOWNWARD
    }

    static var entire: Interval {
        return Interval(raw: double2(-Double.infinity, -Double.infinity))
    }

    static var empty: Interval {
        return Interval(raw: double2(Double.infinity, Double.infinity))
    }

    static var NaN: Interval {
        return Interval(raw: double2(Double.NaN, Double.NaN))
    }
}

prefix func -(rhs: Interval) -> Interval {
    return Interval(raw:rhs.value.yx)
}

func +(lhs: Interval, rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    return Interval(raw:lhs.value + rhs.value)
}

func -(lhs: Interval, rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    return lhs + -rhs
}

func *(lhs: Interval, rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    let a = (lhs.value.x >= 0.0) ?  rhs.value.x : -rhs.value.y
    let b = (lhs.value.y <= 0.0) ? -rhs.value.x :  rhs.value.y
    let c = (lhs.value.y <= 0.0) ? -rhs.value.y :  rhs.value.x
    let d = (lhs.value.x >= 0.0) ?  rhs.value.y : -rhs.value.x

    let left = double2(a, c) * lhs.value
    let right = double2(b, d) * lhs.value.yx

    return Interval(raw:min(left, right))
}

func recip(rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    return Interval(raw:double2(-1.0, -1.0) / rhs.value.yx)
}

func /(lhs: Interval, rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    if (0.0 ∈ rhs) {
        return Interval.entire
    } else {
        return lhs * recip(rhs)
    }
}

func /(lhs: Double, rhs: Interval) -> Interval {
    assert(Interval.isCorrectRoundMode())

    if (0.0 ∈ rhs) {
        return Interval.entire

    } else if (lhs == 1.0) {
        return recip(rhs)

    } else {
        return Interval(lhs) / rhs
    }
}

func abs(rhs: Interval) -> Interval {
    return Interval(raw:double2(
        max(0.0, rhs.value.x, rhs.value.y),
        -min(rhs.value.x, rhs.value.y)
    ))
}

func square(rhs: Interval) -> Interval {
    // In a square we can make the value positive.
    // That means the multiplication becomes simple and only need a signchange for one of the numbers.
    let left = abs(rhs).value
    let right = double2(left.x, -left.y)
    return Interval(raw:left * right)
}

/// Greatest lower bound.
func glb(lhs: Interval, rhs: Interval) -> Interval {
    return Interval(raw:double2(
        min(lhs.value.x, rhs.value.x),
        max(lhs.value.y, rhs.value.y)
    ))
}

/// Least upper bound.
func lub(lhs: Interval, rhs: Interval) -> Interval {
    return Interval(raw:double2(
        max(lhs.value.x, rhs.value.x),
        min(lhs.value.y, rhs.value.y)
    ))
}

/// Intersection.
/// - return:An interval where both intervals intersect with each other, or a empty interval.
func ∩(lhs: Interval, rhs: Interval) -> Interval {
    return Interval(raw: max(lhs.value, rhs.value))
}

/// Hull
/// - return:An interval that includes both intervals completely.
func ⩂(lhs: Interval, rhs: Interval) -> Interval {
    return Interval(raw:min(lhs.value, rhs.value))
}

func ==(lhs: Interval, rhs: Interval) -> Bool {
    return (
        (lhs.value.x == rhs.value.x && lhs.value.y == rhs.value.y) ||
        (lhs.isEmpty && rhs.isEmpty)
    )
}

func ⊂(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x > rhs.value.x && lhs.value.y > rhs.value.y
}

func ⊆(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x >= rhs.value.x && lhs.value.y >= rhs.value.y
}

func ⊃(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x < rhs.value.x && lhs.value.y < rhs.value.y
}

func ⊇(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x <= rhs.value.x && lhs.value.y <= rhs.value.y
}

func <(lhs: Interval, rhs: Interval) -> Bool {
    return -lhs.value.y < rhs.value.x
}

func <=(lhs: Interval, rhs: Interval) -> Bool {
    return -lhs.value.y <= rhs.value.x
}

func ≺(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.y > rhs.value.y
}

func ≼(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.y >= rhs.value.y
}

func >(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x > -rhs.value.y
}

func >=(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x >= -rhs.value.y
}

func ≻(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x > rhs.value.x
}

func ≽(lhs: Interval, rhs: Interval) -> Bool {
    return lhs.value.x >= rhs.value.x
}

func sqrt(rhs: Interval) -> Interval {
    if (rhs < 0.0) {
        return Interval.NaN

    } else {
        assert(Interval.isCorrectRoundMode())

        let low = sqrt(rhs.value.x)
        Interval.setRoundMode(FE_UPWARD)
        let high = sqrt(-rhs.value.y)
        Interval.setRoundMode()

        return Interval(raw:double2(low, -high))
    }
}

func **(lhs: Interval, rhs: Double) -> Interval {
    switch (rhs) {
    case 2.0:
        return square(lhs)
    default:
        preconditionFailure("Power is only implemented for 2.0")
    }
}

func **(lhs: Interval, rhs: Int) -> Interval {
    switch (rhs) {
    case 2:
        return square(lhs)
    default:
        preconditionFailure("Power is only implemented for 2")
    }
}

func ∈(lhs: Double, rhs: Interval) -> Bool {
    return rhs.value.x <= lhs && lhs <= -rhs.value.y
}

func ==(lhs: Interval, rhs: Double) -> Bool {
    return lhs == Interval(rhs)
}

func <(lhs: Interval, rhs: Double) -> Bool {
    return lhs < Interval(rhs)
}

func <=(lhs: Interval, rhs: Double) -> Bool {
    return lhs <= Interval(rhs)
}

func >(lhs: Interval, rhs: Double) -> Bool {
    return lhs > Interval(rhs)
}

func >=(lhs: Interval, rhs: Double) -> Bool {
    return lhs >= Interval(rhs)
}


