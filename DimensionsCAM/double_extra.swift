//
//  float_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-14.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

extension Double: SqrtOperationsType, NumericOperationsType {
    var square: Double {
        return self * self
    }
}

func **(radix: Double, power: Double) -> Double {
    return pow(radix, power)
}

prefix func √(rhs: Double) -> Double {
    return sqrt(rhs)
}
