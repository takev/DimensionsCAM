// DimensionsCAM - A multi-axis tool path generator for a milling machine
// Copyright (C) 2015  Take Vos
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

