//
//  fix3.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-09.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

/* let FIX3_SHIFT        = 10
let FIX3_2SHIFT       = FIX3_SHIFT * 2
let FIX3_FACTOR       = Double(2 ** FIX3_SHIFT)
let FIX3_OVER_FACTOR  = 1.0 / FIX3_FACTOR

struct fix3 : Hashable, CustomReflectable {
    let intrinsic: int3

    var x: Double {
        return Double(intrinsic.x) * FIX3_OVER_FACTOR
    }
    var y: Double {
        return Double(intrinsic.y) * FIX3_OVER_FACTOR
    }
    var z: Double {
        return Double(intrinsic.z) * FIX3_OVER_FACTOR
    }

    var length: Double {
        return sqrt(self ∙ self)
    }

    func customMirror() -> Mirror {
        return Mirror(self, children: [
            "float_vector": [x, y, z],
            "fix_vector": [intrinsic.x, intrinsic.y, intrinsic.z],
        ])
    }

    var hashValue: Int {
        return (
            intrinsic.x.hashValue ^
            intrinsic.y.hashValue ^
            intrinsic.z.hashValue
        )
    }

    init() {
        self.intrinsic = int3()
    }

    init(_ value: double3) {
        self.intrinsic = int3(
            Int32(round(value.x * FIX3_FACTOR)),
            Int32(round(value.y * FIX3_FACTOR)),
            Int32(round(value.z * FIX3_FACTOR))
        )
    }

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.init(double3(x, y, z))
    }

    init(intrinsic: int3) {
        self.intrinsic = intrinsic
    }

    func normalize() -> fix3 {
        return self / length
    }

    func toDouble3() -> double3 {
        return double3(
            Double(self.x) * FIX3_OVER_FACTOR,
            Double(self.y) * FIX3_OVER_FACTOR,
            Double(self.z) * FIX3_OVER_FACTOR
        )
    }

    func toFloat3() -> float3 {
        let tmp = toDouble3()
        return float3(
            Float(tmp.x),
            Float(tmp.y),
            Float(tmp.z)
        )
    }

}

infix operator ∙ { associativity left precedence 150 }

func ==(lhs: fix3, rhs: fix3) -> Bool {
    return lhs.intrinsic == rhs.intrinsic
}

func -(lhs: fix3, rhs: fix3) -> fix3 {
    return fix3(intrinsic:int3(
            lhs.intrinsic.x - rhs.intrinsic.x,
            lhs.intrinsic.y - rhs.intrinsic.y,
            lhs.intrinsic.z - rhs.intrinsic.z
        )
    )
}

func +(lhs: fix3, rhs: fix3) -> fix3 {
    return fix3(intrinsic:int3(
            lhs.intrinsic.x + rhs.intrinsic.x,
            lhs.intrinsic.y + rhs.intrinsic.y,
            lhs.intrinsic.z + rhs.intrinsic.z
        )
    )
}

func /(lhs: fix3, rhs: Int) -> fix3 {
    return fix3(intrinsic:int3(
            Int32((Int(lhs.intrinsic.x) << FIX3_SHIFT) / (rhs << FIX3_SHIFT)),
            Int32((Int(lhs.intrinsic.y) << FIX3_SHIFT) / (rhs << FIX3_SHIFT)),
            Int32((Int(lhs.intrinsic.z) << FIX3_SHIFT) / (rhs << FIX3_SHIFT))
        )
    )
}

func /(lhs: fix3, rhs: Double) -> fix3 {
    return fix3(

    )
}

func ∙(lhs: fix3, rhs: fix3) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}
*/
