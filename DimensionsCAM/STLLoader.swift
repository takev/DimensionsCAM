//
//  File.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-07.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

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
