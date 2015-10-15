//
//  STLSaver.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-23.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//



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