//
//  protocols.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-29.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

protocol Addible {
    func +(lhs: Self, rhs: Self) -> Self
}

protocol NumericOperationsType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
}

/*protocol NumericDoubleOperationsType {
    func +(lhs: Self, rhs: Double) -> Self
    func +(lhs: Double, rhs: Double) -> Self
    func *(lhs: Self, rhs: Double) -> Self
    func *(lhs: Double, rhs: Self) -> Self
}*/

protocol SqrtOperationsType {
    prefix func √(rhs: Self) -> Self
    var square: Self { get }
}

protocol ShiftOperationsType {
    func <<(lhs: Self, rhs: Self) -> Self
    func >>(lhs: Self, rhs: Self) -> Self
}

/*protocol NumericConvertible {
    init(_: Int64)
    init(_: Int)
    init(_: Double)
    var id: UInt64 { get }
    var toDouble: Double { get }
}*/

