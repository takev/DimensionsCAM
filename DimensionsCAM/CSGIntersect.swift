//
//  CSGIntersect.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-27.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

enum CSGIntersect {
    /// The AABBox is fully inside a CSG object.
    case INSIDE
    /// The AABBox is fully outside a CSG object.
    case OUTSIDE
    /// The AABBox is intersecting with the surface of the object at a CSG primative
    /// The primative is returned to retrieve a normal at the AABBox. 
    case SURFACE(CSGPrimative)
}
