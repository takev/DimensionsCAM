//
//  main.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-07.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

func main() {

    if fegetround() < 0 {
        preconditionFailure("fegetround() is not supported")
    }
    Swift.print("Success")

    /*if let mesh = STLLoadFile("/Users/takev/Projects/DimensionsCAM/DimensionsCAM/example_object.stl") {
        let tetrahedron_mesh = mesh.toTetrahedronMesh()
        let triangle_mesh = tetrahedron_mesh.toTriangleMesh()

        Swift.print(triangle_mesh)
        STLSaveFile(triangle_mesh, filename: "/Users/takev/Projects/DimensionsCAM/DimensionsCAM/result_object.stl")

    }*/

}

main()
