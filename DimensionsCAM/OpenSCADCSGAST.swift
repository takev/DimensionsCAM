//
//  OpenSCADCSGAST.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-16.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

enum OpenSCADCSGAST: Equatable, CustomStringConvertible {
    case LEAF_NAME(String)
    case LEAF_NUMBER(Double)
    case LEAF_BOOLEAN(Bool)
    case LEAF_VECTOR(double4)
    case LEAF_MATRIX(double4x4)
    case BRANCH(String, [OpenSCADCSGAST])
    case NULL

    var description: String {
        switch (self) {
        case .LEAF_NAME(let a):             return "\"\(a)\""
        case .LEAF_NUMBER(let a):           return "\(a)"
        case .LEAF_BOOLEAN(let a):          return "\(a)"
        case .LEAF_VECTOR(let a):           return "\(a)"
        case .LEAF_MATRIX(let a):           return "\(a)"
        case .NULL:                         return "NULL"
        case .BRANCH(let name, let list):   return "\(name): \(list)"
        }
    }
}

func ==(a: OpenSCADCSGAST, b: OpenSCADCSGAST) -> Bool {
    switch (a, b) {
    case (.LEAF_NAME(let a),        .LEAF_NAME(let b))          where a == b:               return true
    case (.LEAF_NUMBER(let a),      .LEAF_NUMBER(let b))        where a == b:               return true
    case (.LEAF_VECTOR(let a),      .LEAF_VECTOR(let b))        where a == b:               return true
    case (.LEAF_MATRIX(let a),      .LEAF_MATRIX(let b))        where a == b:               return true
    case (.BRANCH(let a1, let a2),  .BRANCH(let b1, let b2))    where a1 == b1 && a2 == b2: return true
    case (.NULL,                    .NULL):                                                 return true
    default:                                                                                return false
    }
}

