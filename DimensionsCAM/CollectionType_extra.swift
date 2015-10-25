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

func sum<C: CollectionType where C.Generator.Element: Addible>(values: C) -> C.Generator.Element {
    var index = values.startIndex
    var total = values[index]
    index = index.advancedBy(1)

    while (index != values.endIndex) {
        total = total + values[index]
        index = index.advancedBy(1)
    }
    return total
}

func -<C: CollectionType where C.Generator.Element: Equatable>(lhs: C, rhs: C) -> [C.Generator.Element] {
    var tmp = Array<C.Generator.Element>()

    for lhs_element in lhs {
        var found_in_rhs = false
        for rhs_element in rhs {
            found_in_rhs = found_in_rhs || (lhs_element == rhs_element)
        }
        if !found_in_rhs {
            tmp.append(lhs_element)
        }
    }
    return tmp
}
