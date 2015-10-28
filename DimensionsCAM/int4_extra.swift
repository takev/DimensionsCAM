//
//  int4_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-28.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

func +(lhs: int4, rhs: int4) -> int4 {
    return int4(
        lhs.x + rhs.x,
        lhs.y + rhs.y,
        lhs.z + rhs.z,
        lhs.w + rhs.w
    )
}
