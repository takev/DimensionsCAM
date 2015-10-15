//
//  double2_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-28.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//


import simd

extension double2: NumericOperationsType {
    var yx: double2 { return double2(y, x) }
}

