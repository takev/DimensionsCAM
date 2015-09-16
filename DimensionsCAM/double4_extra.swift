//
//  double4_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-15.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

let DOUBLE4_GRID            = 0.0001
let DOUBLE4_ONE_OVER_GRID   = 10000.0

extension double4: Hashable {
    var snapToGrid: double4 {
        return round(self * DOUBLE4_ONE_OVER_GRID) * DOUBLE4_GRID
    }

    public var hashValue: Int {
        // Get integer coordinates of the grid.
        let tmp = round(self * DOUBLE4_ONE_OVER_GRID)

        return (
            Int(tmp.x).hashValue ^
            Int(tmp.y).hashValue ^
            Int(tmp.z).hashValue
        )
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
        tmp.x < DOUBLE4_GRID &&
        tmp.y < DOUBLE4_GRID &&
        tmp.z < DOUBLE4_GRID &&
        tmp.w < DOUBLE4_GRID
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
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z + lhs.w * rhs.w
}

