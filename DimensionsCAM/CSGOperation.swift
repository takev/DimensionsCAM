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

class CSGOperation : CSGObject {
    var children: [CSGObject] = []

    func addChild(child: CSGObject) {
        child.parent = self
        children.append(child)
    }

    func addChildren(children: [CSGObject]) {
        for child in children {
            addChild(child)
        }
    }

    override func enumeratePrimatives(var index: Int = 0) -> Int {
        for child in children {
            index = child.enumeratePrimatives(index)
        }
        return index
    }

    override func updateTransformation(parent_transformation: double4x4) {
        super.updateTransformation(parent_transformation)
        for child in children {
            child.updateTransformation(self.globalTransformation)
        }
    }

    override func updateBoundingBox() {
        // Recuse into the children.
        for child in children {
            child.updateBoundingBox()
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
