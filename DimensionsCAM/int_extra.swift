//
//  int_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-14.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

func **(lhs: Int, rhs: Int) -> Int {
    switch lhs {
    case 2:
        return 1 << rhs
    default:
        return Int(Double(lhs) ** Double(rhs))
    }
}

