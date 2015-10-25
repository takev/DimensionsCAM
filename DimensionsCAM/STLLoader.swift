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

func STLLoadFile(path: String) -> TriangleMesh? {
    let stl_ascii_magic_text = "solid"
    let stl_ascii_magic_bytes = stl_ascii_magic_text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)!

    guard let file_data = NSData(contentsOfFile: path) else {
        Swift.print("Could not open STL file '\(path)'.")
        return nil;
    }

    let file_magic = file_data.subdataWithRange(NSRange(location: 0, length: stl_ascii_magic_bytes.length))
    if (file_magic == stl_ascii_magic_bytes) {
        // This is an ascii file, parse it with the ascii parser.
        guard let file_text = NSString(data:file_data, encoding:NSUTF8StringEncoding) else {
            Swift.print("Non UTF8 characters in file '\(path)'.");
            return nil;
        }

        return STLParseASCII(file_text as String, filename: path)

    } else {
        Swift.print("Not implemented binary STL loader '\(path)'.");
        return nil;
    }
}
