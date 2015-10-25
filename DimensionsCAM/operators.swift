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

/// Succeeds or touches
prefix operator √ { }



