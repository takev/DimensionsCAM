//
//  CollectionType_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-29.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

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
