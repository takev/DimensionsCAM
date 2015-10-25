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

struct OpenSCADCSGParser {
    var grammar: OpenSCADCSGGrammar


    init(text: String, filename: String) {
        grammar = OpenSCADCSGGrammar(text: text, filename: filename)
    }

    /// A group is not really a node, and simply returns the one child node it contains.
    func parseGroupFunction(ast: OpenSCADCSGAST, child_objects: [CSGObject]) throws -> CSGObject {
        guard child_objects.count == 1 else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Multimatrix does not have exactly 1 child")
        }
        return child_objects[0]
    }

    /// A union function combines all children.
    func parseUnionFunction(ast: OpenSCADCSGAST, child_objects: [CSGObject]) throws -> CSGObject {
        let parent = CSGUnion()
        for child in child_objects {
            parent.addChild(child)
        }

        return parent
    }

    /// A intersection function takes only the overalp of all children.
    func parseIntersectionFunction(ast: OpenSCADCSGAST, child_objects: [CSGObject]) throws -> CSGObject {
        let parent = CSGIntersection()
        for child in child_objects {
            parent.addChild(child)
        }

        return parent
    }

    /// A difference function removes 2 to n children from child 1.
    func parseDifferenceFunction(ast: OpenSCADCSGAST, child_objects: [CSGObject]) throws -> CSGObject {
        let parent = CSGDifference()
        for child in child_objects {
            parent.addChild(child)
        }

        return parent
    }

    func getArgument(arguments_node: OpenSCADCSGAST, name: String = "", index: Int = -1) throws -> OpenSCADCSGAST {
        guard case .BRANCH(let type, let argument_nodes) = arguments_node where type == "arguments" else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(arguments_node, "Expect a 'arguments' branch.")
        }

        var i = 0
        for argument_node in argument_nodes {
            guard case .BRANCH(let type, let name_value_nodes) = argument_node where type == "argument" && name_value_nodes.count == 2 else {
                throw OpenSCADCSGError.UNEXPECTED_ASTNODE(argument_node, "Expecting 'argument' node with 2 childs")
            }
            let name_node = name_value_nodes[0]
            let value_node = name_value_nodes[1]

            switch (name_node) {
            case .NULL:
                if i == index {
                    return value_node
                }
            case .LEAF_NAME(let leaf_name):
                if leaf_name == name {
                    return value_node
                }
            default:
                throw OpenSCADCSGError.UNEXPECTED_ASTNODE(name_node, "Expecting NULL or Name")
            }
            i++
        }
        throw OpenSCADCSGError.UNEXPECTED_ASTNODE(.NULL, "Could not find argument of '\(name)'")
    }

    func getBooleanArgument(arguments_node: OpenSCADCSGAST, name: String = "", index: Int = -1) throws -> Bool {
        let value_node = try getArgument(arguments_node, name: name, index: index)

        if case .LEAF_BOOLEAN(let value) = value_node {
            return value
        } else  {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(value_node, "Expecting boolean leaf node.")
        }
    }

    func getNumberArgument(arguments_node: OpenSCADCSGAST, name: String = "", index: Int = -1) throws -> Double {
        let value_node = try getArgument(arguments_node, name: name, index: index)

        if case .LEAF_NUMBER(let value) = value_node {
            return value
        } else  {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(value_node, "Expecting number leaf node.")
        }
    }

    func getVectorArgument(arguments_node: OpenSCADCSGAST, name: String = "", index: Int = -1) throws -> double4 {
        let value_node = try getArgument(arguments_node, name: name, index: index)

        if case .LEAF_VECTOR(let value) = value_node {
            return value
        } else  {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(value_node, "Expecting vector leaf node.")
        }
    }

    func getMatrixArgument(arguments_node: OpenSCADCSGAST, name: String = "", index: Int = -1) throws -> double4x4 {
        let value_node = try getArgument(arguments_node, name: name, index: index)

        if case .LEAF_MATRIX(let value) = value_node {
            return value
        } else  {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(value_node, "Expecting matrix leaf node.")
        }
    }

    func parseCubeFunction(ast: OpenSCADCSGAST, arguments_node: OpenSCADCSGAST) throws -> CSGObject {
        let size = try getVectorArgument(arguments_node, name:"size")
        let center = try getBooleanArgument(arguments_node, name:"center")
        let object = CSGCube(size:size.xyz)

        if !center {
            // Move the cube which is normally has its center on the origin to having its corner on the origin.
            // Just move it half of its own size.
            object.localTransformations.insert(double4x4(translate:size * 0.5), atIndex:0)
        }

        return object
    }

    func parseCylinderFunction(ast: OpenSCADCSGAST, arguments_node: OpenSCADCSGAST) throws -> CSGObject {
        var d1: Double
        var d2: Double

        if let r1 = try? getNumberArgument(arguments_node, name:"r1") {
            d1 = r1 * 2.0
        } else {
            d1 = try getNumberArgument(arguments_node, name:"d1")
        }

        if let r2 = try? getNumberArgument(arguments_node, name:"r2") {
            d2 = r2 * 2.0
        } else {
            d2 = try getNumberArgument(arguments_node, name:"d2")
        }

        let h = try getNumberArgument(arguments_node, name:"h")
        let center = try getBooleanArgument(arguments_node, name:"center")

        let object = CSGCylinder(height: h, diameter_bottom: d1, diameter_top: d2)

        if !center {
            // Move the cylinder which is normally has its center on the origin to having its bottom cap's center on the origin.
            // Just move it half of its height.
            object.localTransformations.insert(double4x4(translate:double4(0.0, 0.0, h * 0.5, 0.0)), atIndex:0)
        }

        return object
    }

    func parseSphereFunction(ast: OpenSCADCSGAST, arguments_node: OpenSCADCSGAST) throws -> CSGObject {
        var d: Double
        if let r = try? getNumberArgument(arguments_node, name:"r") {
            d = r * 2.0
        } else {
            d = try getNumberArgument(arguments_node, name:"d")
        }

        let size = double3(d, d, d)
        return CSGSphere(size:size)
    }

    /// A multmatrix modifies its single child node.
    func parseMultmatrixFunction(ast: OpenSCADCSGAST, child_objects: [CSGObject], arguments_node: OpenSCADCSGAST) throws -> CSGObject {
        guard child_objects.count == 1 else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Multimatrix does not have exactly 1 child")
        }
        let child = child_objects[0]

        let value = try getMatrixArgument(arguments_node, index:0)

        child.localTransformations.insert(value, atIndex: 0)
        return child
    }

    func parseBlocks(ast: OpenSCADCSGAST) throws -> [CSGObject] {
        guard case .BRANCH(let type, let block_nodes) = ast where type == "block" else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Expect a 'block' branch.")
        }

        // Recurse the blocks.
        var child_objects: [CSGObject] = []
        for block_node in block_nodes {
            let child_object = try parseFunction(block_node)
            child_objects.append(child_object)
        }

        return child_objects
    }

    func parseFunction(ast: OpenSCADCSGAST) throws -> CSGObject {
        guard case .BRANCH(let type, let children) = ast where type == "function" && children.count == 3 else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Expect a 'function' branch with 3 children.")
        }
        let name_node = children[0]
        let arguments_node = children[1]
        let block_node = children[2]

        guard case .LEAF_NAME(let name) = name_node else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(name_node, "Expect a name leaf.")
        }

        let child_objects = try parseBlocks(block_node)

        switch name {
        case "group":
            return try parseGroupFunction(ast, child_objects: child_objects)

        case "multmatrix":
            return try parseMultmatrixFunction(ast, child_objects: child_objects, arguments_node: arguments_node)

        case "difference":
            return try parseDifferenceFunction(ast, child_objects: child_objects)

        case "union":
            return try parseUnionFunction(ast, child_objects: child_objects)

        case "intersection":
            return try parseIntersectionFunction(ast, child_objects: child_objects)

        case "cube":
            return try parseCubeFunction(ast, arguments_node: arguments_node)

        case "cylinder":
            return try parseCylinderFunction(ast, arguments_node: arguments_node)

        case "sphere":
            return try parseSphereFunction(ast, arguments_node: arguments_node)

        default:
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Unknown funcion: '\(name)'.")
        }
    }

    mutating func parseProgram() throws -> CSGObject {
        let ast = try grammar.parseProgram()

        guard case .BRANCH(let type, let children) = ast where type == "program" && children.count == 1 else {
            throw OpenSCADCSGError.UNEXPECTED_ASTNODE(ast, "Expect a 'program' branch with 1 child.")
        }

        return try parseFunction(children[0])
    }
}
