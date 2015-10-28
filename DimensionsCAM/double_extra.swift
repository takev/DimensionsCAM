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

import Foundation

extension Double: SqrtOperationsType, NumericOperationsType {
    var square: Double {
        return self * self
    }
}

func **(radix: Double, power: Double) -> Double {
    return pow(radix, power)
}

func **(radix: Double, power: Int) -> Double {
    switch power {
    case 2: return radix * radix
    default: return radix * Double(power)
    }
}

prefix func √(rhs: Double) -> Double {
    return sqrt(rhs)
}
