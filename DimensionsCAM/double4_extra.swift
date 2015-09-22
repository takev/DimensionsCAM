//
//  double4_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-15.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

extension double4: Addible, Equatable {
    var gridId: Int64 {
        assert(abs(x) < 2000.0 && abs(y) < 2000.0 && abs(z) < 2000.0, "Expect a coord to be less than 2 meter")

        var r: Int64
        r =     ((Int64(round(x * 1000.0))      ) & 0x1fffff)
        r = r | ((Int64(round(y * 1000.0)) << 21) & 0x1fffff)
        r = r | ((Int64(round(z * 1000.0)) << 42) & 0x1fffff)
        return r
    }

    public var length: Double {
        return sqrt(self ∙ self)
    }

    public var unit: double4 {
        return self / length
    }

    init(_ xyz: double3, _ w: Double) {
        self.init(xyz.x, xyz.y, xyz.z, w)
    }

}



public func ==(lhs: double4, rhs: double4) -> Bool {
    let tmp = abs(rhs - lhs)
    return (
        tmp.x < 0.001 &&
        tmp.y < 0.001 &&
        tmp.z < 0.001 &&
        tmp.w < 0.001
    )
}

public func /(lhs: double4, rhs:Double) -> double4 {
    let inv_rhs = 1.0 / rhs
    return double4(
        lhs.x * inv_rhs,
        lhs.y * inv_rhs,
        lhs.z * inv_rhs,
        lhs.w * inv_rhs
    )
}

public func round(v: double4) -> double4 {
    return double4(
        round(v.x),
        round(v.y),
        round(v.z),
        round(v.w)
    )
}

func ∙(lhs: double4, rhs: double4) -> Double {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Dot product should only be done on vectors, not points")
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}

func ×(lhs: double4, rhs: double4) -> double4 {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Cross product should only be done on vectors, not points")
    return double4(
        lhs.y * rhs.z - lhs.z * rhs.y,
        lhs.z * rhs.x - lhs.x * rhs.z,
        lhs.x * rhs.y - lhs.y * rhs.x,
        0.0
    )
}

