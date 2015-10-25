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

class STLASCIIParser {
    var optionalMesh        : TriangleMesh? = nil
    var normal              : Vector3Fix10?
    var points              : [Vector3Fix10]     = []

    init() {
    }

    func parseLine(line: String, lineNr: Int, filename: String) -> Bool {
        if line.hasPrefix("solid") {
            optionalMesh = TriangleMesh()
            normal = nil

        } else if line.hasPrefix("facet normal") {
            let string_value = line[line.startIndex.advancedBy(13) ..< line.endIndex]
            guard let normal = string_value.toDoubles() else {
                Swift.print("\(filename):\(lineNr) Cannot parse normal '\(string_value)'.");
                return false
            }
            guard normal.count == 3 else {
                Swift.print("\(filename):\(lineNr) Normal does not have 3 numbers '\(string_value)'.");
                return false
            }
            self.normal = Vector3Fix10(normal[0], normal[1], normal[2])

        } else if line.hasPrefix("outer loop") {
            points = []

        } else if line.hasPrefix("vertex") {
            let string_value = line[line.startIndex.advancedBy(7) ..< line.endIndex]
            guard let point = string_value.toDoubles() else {
                Swift.print("\(filename):\(lineNr) Cannot parse vertex '\(string_value).");
                return false
            }
            guard point.count == 3 else {
                Swift.print("\(filename):\(lineNr) Vertex does not have 3 numbers '\(string_value).");
                return false
            }
            points.append(Vector3Fix10(point[0], point[1], point[2]))

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
