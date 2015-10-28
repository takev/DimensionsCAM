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

enum VoxelType {
case NODE(Int)
case OUTSIDE
case MATERIAL
case SURFACE(Int?, Bool)    ///< primative index or nil when intersecting multiple primatives; true if surface is visited.
case INSIDE
case ERROR
}

///
/// 1nnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn     Node (Node index)
/// 01VSpppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp     Surface (Visited, Single primative, Primative index)
/// 00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000     Outside
/// 00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000001     Material
/// 00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000010     Inside
struct Voxel {
    var intrinsic: UInt32 = 0

    var value: VoxelType {
        set (value) {
            switch (value) {
            case .OUTSIDE:
                intrinsic = 0
            case .MATERIAL:
                intrinsic = 1
            case .INSIDE:
                intrinsic = 2
            case .NODE(let node_index):
                assert(node_index >= 0 && node_index <= 0x7fff_ffff, "Expect node index to between 0 and 2**31")
                intrinsic = UInt32(0x8000_0000) & UInt32(node_index)
            case .SURFACE(let optional_csg_primative_index, let visited):
                intrinsic = 0x4000_0000
                if visited {
                    intrinsic |= 0x2000_0000    // Visited
                }

                if let csg_primative_index = optional_csg_primative_index {
                    assert(csg_primative_index >= 0 && csg_primative_index <= 0x0fff_ffff, "Expect CSG primative index to between 0 and 2**28")
                    intrinsic |= UInt32(0x1000_0000)    // Single primative
                    intrinsic |= UInt32(csg_primative_index)
                }

            case .ERROR:
                preconditionFailure("Can not set voxel to error")
            }
        }
        get {
            if intrinsic == 0 {
                return .OUTSIDE

            } else if intrinsic == 1 {
                return .MATERIAL

            } else if intrinsic == 2 {
                return .INSIDE

            } else if ((intrinsic & 0x8000_0000) > 0) {
                let node_index = intrinsic & UInt32(0x7fff_ffff)
                return .NODE(Int(node_index))

            } else if ((intrinsic & 0x4000_0000) > 0) {
                let csg_primative_index = intrinsic & UInt32(0x0fff_ffff)

                if ((intrinsic & 0x1000_0000) > 0) {
                    return .SURFACE(Int(csg_primative_index), (intrinsic & 0x2000_0000) > 0)
                } else {
                    return .SURFACE(nil, (intrinsic & 0x2000_0000) > 0)
                }
            } else {
                return .ERROR
            }
        }
    }
}

struct VoxelNode {
    // I use 8 seperate variables, because I do not know if a fixed array becomes well packed after compilation.
    var A = Voxel()
    var B = Voxel()
    var C = Voxel()
    var D = Voxel()
    var E = Voxel()
    var F = Voxel()
    var G = Voxel()
    var H = Voxel()

    subscript(index: Int) -> Voxel{
        get {
            switch (index) {
            case 0: return A
            case 1: return B
            case 2: return C
            case 3: return D
            case 4: return E
            case 5: return F
            case 6: return G
            case 7: return H
            default: preconditionFailure("Expect index to be between 0 ..< 8.")
            }
        }
        set(newValue) {
            switch (index) {
            case 0: A = newValue
            case 1: B = newValue
            case 2: C = newValue
            case 3: D = newValue
            case 4: E = newValue
            case 5: F = newValue
            case 6: G = newValue
            case 7: H = newValue
            default: preconditionFailure("Expect index to be between 0 ..< 8.")
            }
        }
    }
}

struct VoxelTree {
    var csg_model       : CSGObject
    var csg_material    : CSGDifference

    let position        : interval4
    let orientation     : double3

    var nodes           : [VoxelNode] = []
    var nr_nodes        : Int = 0
    var node_free_list  : [Int] = []
    let max_level       : Int = 8

    init(model: CSGObject, material: CSGObject, removed_material: [CSGObject], orientation: double3) {
        csg_model = model
        csg_model.enumeratePrimatives()

        csg_material = CSGDifference()
        csg_material.addChild(material)
        csg_material.addChild(model)
        csg_material.addChildren(removed_material)

        let previous_rounding_mode = Interval.setRoundMode()
        defer { Interval.setRoundMode(previous_rounding_mode) }

        // The position of the voxel space inside XYZ space is the bounding box of both the material and the model.
        position = csg_material.boundingBox ⩂ csg_model.boundingBox
        self.orientation = orientation

        // XXX Convert orientation into a matrix and add it to the CSG model and material.
    }

    /// Coord is a coordinate within voxel space.
    /// The x, y and z values are used for indexing into voxel space at a specific level.
    /// w is used to specify the level within voxel space.
    static func coordToInterval(coord: int4) -> interval4 {
        let inverse_level_size = 1 << coord.w

        // Make a box of the coordinate.
        let coord_interval = interval4(
            Interval(Double(coord.x), Double(coord.x + 1)),
            Interval(Double(coord.y), Double(coord.y + 1)),
            Interval(Double(coord.z), Double(coord.z + 1)),
            Interval(0.0)
        )

        return coord_interval / Double(inverse_level_size)
    }

    func coordToInterval(coord: int4) -> interval4 {
        let base_interval = VoxelTree.coordToInterval(coord)
        let size = position.size
        let resized_interval = base_interval * size

        return interval4(
            Interval(resized_interval.x.low + position.x.low, resized_interval.x.high + position.x.low),
            Interval(resized_interval.y.low + position.y.low, resized_interval.y.high + position.y.low),
            Interval(resized_interval.z.low + position.z.low, resized_interval.z.high + position.z.low),
            Interval(1)
        )
    }

    static func getSubCoord(coord: int4, index: Int) -> int4 {
        let base_sub_coord = int4(coord.x << 1, coord.y << 1, coord.z << 1, coord.w + 1)

        switch (index) {
        case 0: return base_sub_coord + int4(0, 0, 0, 0)
        case 1: return base_sub_coord + int4(1, 0, 0, 0)
        case 2: return base_sub_coord + int4(0, 1, 0, 0)
        case 3: return base_sub_coord + int4(1, 1, 0, 0)
        case 4: return base_sub_coord + int4(0, 0, 1, 0)
        case 5: return base_sub_coord + int4(1, 0, 1, 0)
        case 6: return base_sub_coord + int4(0, 1, 1, 0)
        case 7: return base_sub_coord + int4(1, 1, 1, 0)
        default: preconditionFailure("Expect index to be between 0 ..< 8.")
        }
    }


    mutating func getNewVoxelNode() -> Int {
        if let node_index = node_free_list.popLast() {
            // Take a node from the free list if available.
            nr_nodes = nr_nodes + 1
            return node_index

        } else {
            // Create a new fresh node.
            let node_index = nodes.count
            assert(node_index <= 0x7fff_ffff, "Can not handle more than 2**31 nodes in the oct tree")
            nr_nodes = nr_nodes + 1
            nodes.append(VoxelNode())
            return node_index
        }
    }

    /// Render the CSG model and material into voxel space.
    /// The coord is the index for each voxel at a nested level.
    mutating func render(coord: int4 = int4(0, 0, 0, 0)) -> Voxel {
        // Start of with an empty voxel, we fill it in as we know how it intersects with the model or material.
        // This voxel is always returned by the method.
        var voxel = Voxel()

        // Voxel checks are done using interval arithmatic, force the SSE in the correct rounding mode.
        let previous_rounding_mode = Interval.setRoundMode()
        defer { Interval.setRoundMode(previous_rounding_mode) }

        // Check if the voxel at this level is fully inside or fully outside the model or material
        let coord_interval = coordToInterval(coord)

        // At level 0, we will need to search deeper as we need at least 1 root VoxelNode.
        var search_deeper = coord.w == 0

        // Check for intersecting with the model first.
        switch csg_model.isIntersectingWith(coord_interval) {
        case .INSIDE:
            voxel.value = VoxelType.INSIDE

        case .SURFACE(let primative_index):
            // If it voxel intersects with the surface we will have to search deeper to get a more accurate picture.
            search_deeper = true
            voxel.value = VoxelType.SURFACE(primative_index, false)

        case .OUTSIDE:
            // If we are outside the model we may still be intersecting with material so check this.
            switch csg_material.isIntersectingWith(coord_interval) {
            case .INSIDE:
                // This voxel lies outisde the model but inside the material.
                voxel.value = VoxelType.MATERIAL

            case .SURFACE(_):
                // We don't care about how the material is intersecting with the surface, but we do need a more accureate picture.
                search_deeper = true
                voxel.value = VoxelType.MATERIAL

            case .OUTSIDE:
                // This voxel is completely outside the model and material.
                voxel.value = VoxelType.OUTSIDE
            }
        }

        // At a maximum level we will no longer search deeper.
        search_deeper = search_deeper && Int(coord.w) < max_level

        if search_deeper {
            // If the voxel intersects with the surface of the model or material we need to go deeper into the voxel space.
            // Create a new node, and set the voxel to point to the new node.
            let node_index = getNewVoxelNode()
            voxel.value = VoxelType.NODE(node_index)

            assert(coord.w > 0 || node_index == 0, "At level 0, a root node should have index 0.")

            // Iterate over all 8 sub nodes.
            for i in 0 ..< 8 {
                let sub_coord = VoxelTree.getSubCoord(coord, index: i)
                nodes[node_index][i] = render(sub_coord)
            }
        }

        return voxel
    }
}
