//
//  CSGIntersect.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-27.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

enum CSGMatch {
    /// The point (interval) is fully inside a CSG object.
    case INSIDE

    /// The point (interval) is fully outside a CSG object.
    case OUTSIDE

    /// The point (interval) may intersect exactly one primative.
    case SURFACE(CSGPrimative)

    /// The point (interval) may intersect multiple primatives.
    case INTERSECTS

}
