//
//  FixedPoint.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-24.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

protocol NumericOperationsType {
    func +(l: Self, r: Self) -> Self
    func -(l: Self, r: Self) -> Self
    func *(l: Self, r: Self) -> Self
    func /(l: Self, r: Self) -> Self
}

protocol ShiftOperationsType {
    func <<(l: Self, r: Self) -> Self
    func >>(l: Self, r: Self) -> Self
}

protocol NumericConvertible {
    init(_: Int64)
    init(_: Int)
    init(_: Double)
    var id: UInt64 { get }
    var toDouble: Double { get }
}

extension NumericConvertible {
    /// Get the lowest 21 bits of a signed scaled Q10 integer
    var id: UInt64 {
        switch self {
        case let x as Int64:
            return UInt64(bitPattern: x) & 0x1fffff;
        default:
            preconditionFailure("Can not cast to an id")
        }
    }

    var toDouble: Double {
        return Double(self)
    }
}

extension Int64: NumericOperationsType, ShiftOperationsType, NumericConvertible {
}

extension Double: NumericOperationsType, NumericConvertible {
    init(_ x: NumericConvertible) {
        switch x {
        case let value as Int64:
            self = Double(value)
        case let value as Double:
            self = value
        default:
            self = x.toDouble
        }
    }
}


protocol FixedPointQ {
    typealias IntElement: NumericOperationsType, BitwiseOperationsType, Comparable, ShiftOperationsType, IntegerLiteralConvertible, NumericConvertible, Hashable;

    static var fractionWidth: IntElement { get }

    static func scaleUp(x: Double) -> IntElement
    static func scaleUp(x: IntElement) -> IntElement
    static func scaleDown(x: IntElement) -> IntElement
    static func scaleDown(x: IntElement) -> Double
}

extension FixedPointQ {
    static func scaleUp(x: Double) -> IntElement {
        return IntElement(round(x * Double(1 << fractionWidth)))
    }

    static func scaleDown(x: IntElement) -> Double {
        return Double(x) / Double(1 << fractionWidth)
    }

    static func scaleUp(x: IntElement) -> IntElement {
        return x << fractionWidth
    }

    static func scaleDown(x : IntElement) -> IntElement {
        return (x >> fractionWidth) + ((x >> (fractionWidth - 1)) & 1)
    }
}

struct FixedPointQ53_10: FixedPointQ {
    typealias IntElement = Int64
    static var fractionWidth: IntElement = 10
}

struct FixedPoint<T: FixedPointQ> : NumericOperationsType, Comparable, NumericConvertible, Hashable, IntegerLiteralConvertible, FloatLiteralConvertible {
    let v: T.IntElement

    init(_ a: T.IntElement) {
        v = T.scaleUp(a)
    }

    init(_ a: Double) {
        v = T.scaleUp(a)
    }

    init(_ a: Int) {
        v = T.scaleUp(T.IntElement(a))
    }

    init(_ a: Int64) {
        v = T.scaleUp(T.IntElement(a))
    }

    init(raw: T.IntElement) {
        v = raw
    }

    init(integerLiteral value: IntegerLiteralType) {
        v = T.scaleUp(T.IntElement(value))
    }

    init(floatLiteral value: FloatLiteralType) {
        v = T.scaleUp(value)
    }

    var hashValue: Int {
        return v.hashValue
    }

    var id: UInt64 {
        return v.id
    }

    var toDouble: Double {
        return T.scaleDown(v)
    }
}

func ==<T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> Bool {
    return lhs.v == rhs.v
}

func < <T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> Bool {
    return lhs.v < rhs.v
}

func <= <T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> Bool {
    return lhs.v <= rhs.v
}

func > <T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> Bool {
    return lhs.v > rhs.v
}

func >= <T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> Bool {
    return lhs.v >= rhs.v
}

func +<T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> FixedPoint<T> {
    return FixedPoint<T>(raw:lhs.v + rhs.v)
}

func -<T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> FixedPoint<T> {
    return FixedPoint<T>(raw:lhs.v - rhs.v)
}

func *<T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> FixedPoint<T> {
    return FixedPoint<T>(raw:T.scaleDown(lhs.v * rhs.v))
}

func /<T: FixedPointQ>(lhs: FixedPoint<T>, rhs: FixedPoint<T>) -> FixedPoint<T> {
    return FixedPoint<T>(raw:T.scaleUp(lhs.v) / rhs.v)
}



typealias Fix10 = FixedPoint<FixedPointQ53_10>
