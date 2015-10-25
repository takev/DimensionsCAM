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

enum STLFileType {
    case BINARY;
    case ASCII;
}

func STLSaveFile(triangleMesh: TriangleMesh, filename: String, format: STLFileType = STLFileType.ASCII) {
    var text: String
    switch (format) {
    case STLFileType.ASCII:
        text = STLFormatASCII(triangleMesh)
        
    case STLFileType.BINARY:
        notImplementedFailure()
    }

    guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
        Swift.print("Could not encode text to UTF8")
        return
    }

    data.writeToFile(filename, atomically: false)
}