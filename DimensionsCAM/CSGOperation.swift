//
//  CSGOperation.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-18.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

class CSGOperation : CSGObject {
    var children: [CSGObject] = []

    func addChild(child: CSGObject) {
        child.parent = self
        children.append(child)
    }

    override func updateTransformation(parent_transformation: double4x4) {
        super.updateTransformation(parent_transformation)
        for child in children {
            child.updateTransformation(self.global_transformation)
        }
    }

    override var description: String {
        var str_list: [String] = []

        for child in children {
            str_list.append(child.description)
        }

        let str = str_list.joinWithSeparator(", ")
        let class_name = String(self.dynamicType)
        return "<\(class_name) \(str)>"
    }
}
