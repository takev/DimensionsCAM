//
//  double4_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-03.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

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
