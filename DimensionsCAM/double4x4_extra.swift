//
//  double4x4_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-03.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

extension double4x4 {
    init(translate: double4) {
        self.init(rows:[
            double4(1.0, 0.0, 0.0, translate.x),
            double4(0.0, 1.0, 0.0, translate.y),
            double4(0.0, 0.0, 1.0, translate.z),
            double4(0.0, 0.0, 0.0, translate.w)
        ])
    }
}

func ×(lhs: double4x4, rhs: double4x4) -> double4x4 {
    return lhs * rhs
}

func ×(lhs: double4x4, rhs: double4) -> double4 {
    return lhs * rhs
}

func ×(lhs: double4x4, rhs: interval4) -> interval4 {
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
