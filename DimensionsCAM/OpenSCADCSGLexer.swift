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
