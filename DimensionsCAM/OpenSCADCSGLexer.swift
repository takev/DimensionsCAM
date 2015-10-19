//
//  OpenSCADCSGLexer.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-03.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

struct OpenSCADCSGLexer {
    let filename: String
    let text: String
    var line_nr: Int = 0
    var index: String.Index

    init(text: String, filename: String) {
        self.text = text
        self.index = self.text.startIndex
        self.filename = filename
    }

    mutating func getNameToken() -> OpenSCADCSGToken {
        let startTokenIndex: String.Index = index
        var endTokenIndex: String.Index = index.advancedBy(1)

        loop: while index != text.endIndex {
            switch (text[endTokenIndex]) {
            case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                 "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                 "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                 "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                 "$", "_", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                endTokenIndex++
            default:
                break loop
            }
        }

        let tokenText = text[Range<String.Index>(start: startTokenIndex, end: endTokenIndex)]
        index = endTokenIndex

        switch (tokenText) {
        case "true":    return .BOOLEAN(true)
        case "false":   return .BOOLEAN(false)
        default:        return .NAME(tokenText)
        }
    }

    mutating func getNumberToken() throws -> OpenSCADCSGToken {
        let startTokenIndex: String.Index = index
        var endTokenIndex: String.Index = index.advancedBy(1)

        loop: while index != text.endIndex {
            switch (text[endTokenIndex]) {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-", "e":
                endTokenIndex++
            default:
                break loop
            }
        }

        let tokenText = text[Range<String.Index>(start: startTokenIndex, end: endTokenIndex)]
        index = endTokenIndex

        if let tokenValue = Double(tokenText) {
            return .NUMBER(tokenValue)
        } else {
            throw OpenSCADCSGError.BAD_NUMBER(filename, line_nr, tokenText)
        }
    }

    mutating func getToken() throws -> OpenSCADCSGToken {
        while index != text.endIndex {
            switch (text[index]) {
            case "{":
                index++
                return .LEFT_BRACE
            case "}":
                index++
                return .RIGHT_BRACE
            case "[":
                index++
                return .LEFT_BRACKET
            case "]":
                index++
                return .RIGHT_BRACKET
            case "(":
                index++
                return .LEFT_PARENTHESIS
            case ")":
                index++
                return .RIGHT_PARENTHESIS
            case ",":
                index++
                return .COMMA
            case ";":
                index++
                return .SEMICOLON
            case "=":
                index++
                return .EQUAL

            case "\n":
                line_nr++
                fallthrough
            case "\t", " ":
                index++

            case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                 "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                 "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                 "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                 "$":
                return getNameToken()

            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-":
                return try getNumberToken()

            default:
                throw OpenSCADCSGError.UNKNOWN_CHARACTER(filename, line_nr, text[index])
            }
        }
        return .END_OF_FILE
    }
}
