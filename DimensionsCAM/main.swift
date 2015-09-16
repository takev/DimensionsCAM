//
//  main.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-07.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

func main() {

    let mesh = STLLoadFile("/Users/takev/Projects/DimensionsCAM/DimensionsCAM/example_object.stl")
    Swift.print(mesh)
}

main()
