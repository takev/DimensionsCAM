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
case SURFACE(Int)
case VISITED_SURFACE(Int)
case INSIDE
case ERROR
}

///
/// 1nnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn_nnnnnnnn     Node (Node index)
/// 01Vppppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp_pppppppp     Surface (Visited, Primative index)
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
                assert(node_index >= 0 && node_index < 0x8000_0000, "Expect node index to between 0 and 2**31")
                intrinsic = UInt32(0x8000_0000) & UInt32(node_index)
            case .SURFACE(let csg_primative_index):
                assert(csg_primative_index >= 0 && csg_primative_index < 0x2000_0000, "Expect CSG primative index to between 0 and 2**31")
                intrinsic = UInt32(0x4000_0000) & UInt32(csg_primative_index)
            case .VISITED_SURFACE(let csg_primative_index):
                assert(csg_primative_index >= 0 && csg_primative_index < 0x2000_0000, "Expect CSG primative index to between 0 and 2**31")
                intrinsic = UInt32(0x6000_0000) & UInt32(csg_primative_index)
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
                let csg_primative_index = intrinsic & UInt32(0x1fff_ffff)

                if ((intrinsic & 0x2000_0000) > 0) {
                    return .VISITED_SURFACE(Int(csg_primative_index))
                } else {
                    return .SURFACE(Int(csg_primative_index))
                }
            } else {
                return .ERROR
            }
        }
    }
}

struct VoxelNode {
    var lll: Voxel
    var llh: Voxel
    var lhl: Voxel
    var lhh: Voxel
    var hll: Voxel
    var hlh: Voxel
    var hhl: Voxel
    var hhh: Voxel
}

struct VoxelTree {
    var csg_model       : [CSGObject]
    var csg_material    : [CSGObject]
    var csg_primatives  : [CSGPrimative]

    var position        : interval4
    var orientation     : double3

    var nodes           : [VoxelNode] = []
    var nr_nodes        : Int = 0
    var free_list       : [Int] = []

}
