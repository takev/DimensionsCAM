//
//  STLParserASCII.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-07.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation
import simd

class STLASCIIParser {
    var optionalMesh        : TriangleMesh? = nil
    var normal              : double4       = double4()
    var points              : [double4]     = []

    init() {
    }

    func parseLine(line: String, lineNr: Int, filename: String) -> Bool {
        if line.hasPrefix("solid") {
            optionalMesh = TriangleMesh()
            normal = double4()

        } else if line.hasPrefix("facet normal") {
            let string_value = line[line.startIndex.advancedBy(13) ..< line.endIndex]
            guard let normal = string_value.toDouble3() else {
                Swift.print("\(filename):\(lineNr) Cannot parse normal '\(string_value)'.");
                return false
            }
            self.normal = double4(normal, 0.0)

        } else if line.hasPrefix("outer loop") {
            points = []

        } else if line.hasPrefix("vertex") {
            let string_value = line[line.startIndex.advancedBy(7) ..< line.endIndex]
            guard let point = string_value.toDouble3() else {
                Swift.print("\(filename):\(lineNr) Cannot parse vertex '\(string_value).");
                return false
            }
            points.append(double4(point, 1.0).snap)

        } else if line.hasPrefix("endloop") {
            if (points.count != 3) {
                Swift.print("\(filename):\(lineNr) Expect exactly three vertices, got \(points.count)")
                return false
            }

        } else if line.hasPrefix("endfacet") {
            if let mesh = optionalMesh {
                let triangle = Triangle(points[0], points[1], points[2])
                mesh.addTriangle(triangle)
            } else {
                Swift.print("\(filename):\(lineNr) Mesh is not created while parsing 'endfacet'")
                return false
            }

        } else if line.hasPrefix("endsolid") {
            if let mesh = optionalMesh {
                mesh.postProcess()
            } else {
                Swift.print("\(filename):\(lineNr) Mesh is not created while parsing 'endsolid'")
                return false
            }

        } else {
            Swift.print("\(filename):\(lineNr) Unknown line start")
            return false;
        }
        
        return true
    }

    func parse(text: String, filename: String) -> TriangleMesh? {
        var failed = false
        var lineNr = 1
        text.enumerateLines { (line, stop) -> Void in
            if !self.parseLine(line.strip(), lineNr:lineNr, filename: filename) {
                Swift.print("\(filename):\(lineNr) Failed to parse line '\(line)'.")
                failed = true
                stop = true
            }
            lineNr = lineNr + 1
        }

        if failed {
            return nil
        } else {
            return optionalMesh
        }
    }
}

func STLParseASCII(text: String, filename: String) -> TriangleMesh? {
    let p = STLASCIIParser();

    return p.parse(text, filename: filename)
}
