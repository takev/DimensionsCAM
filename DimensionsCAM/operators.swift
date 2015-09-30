//
//  new_operators.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-15.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

/// Power
infix operator ** { associativity left precedence 155 }

/// Dot product
infix operator ∙ { associativity left precedence 150 }

/// Cross product
infix operator × { associativity left precedence 155 }

/// Intersect
infix operator ∩ { associativity left precedence 150 }

/// Union
infix operator ∪ { associativity left precedence 140 }

/// Hull
infix operator ⩂ { associativity left precedence 140 }

/// Element of
infix operator ∈ { associativity left precedence 132 }

/// strict subset
infix operator ⊂ { associativity left precedence 130 }

/// Subset or equal
infix operator ⊆ { associativity left precedence 130 }

/// Strict superset
infix operator ⊃ { associativity left precedence 130 }

/// Superset or equal
infix operator ⊇ { associativity left precedence 130 }

/// Precedes
infix operator ≺ { associativity left precedence 130 }

/// Precedes or touches
infix operator ≼ { associativity left precedence 130 }

/// Succeeds
infix operator ≻ { associativity left precedence 130 }

/// Succeeds or touches
infix operator ≽ { associativity left precedence 130 }

