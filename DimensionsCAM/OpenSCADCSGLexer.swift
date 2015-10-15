//
//  OpenSCADCSGLexer.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-03.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

enum OpenSCADCSGError : ErrorType, CustomStringConvertible {
    case UNKNOWN_CHARACTER(String, Int, Character)
    case BAD_NUMBER(String, Int, String)
    case UNEXPECTED_TOKEN(String, Int, OpenSCADCSGToken, OpenSCADCSGToken)

    var description: String {
        switch (self) {
        case .UNKNOWN_CHARACTER(let filename, let linenr, let character):
            return "\(filename):\(linenr + 1): Unknown character '\(character)'"

        case .BAD_NUMBER(let filename, let linenr, let text):
            return "\(filename):\(linenr + 1): Bad number \"\(text)\""
            
        case .UNEXPECTED_TOKEN(let filename, let linenr, let expected_token, let received_token):
            return "\(filename):\(linenr + 1): Unexpected token \(received_token), expecting \(expected_token)"
        }
    }
}

enum OpenSCADCSGToken: Equatable, CustomStringConvertible {
    case NAME(String)
    case NUMBER(Double)
    case BOOLEAN(Bool)
    case LEFT_PARENTHESIS
    case RIGHT_PARENTHESIS
    case LEFT_BRACKET
    case RIGHT_BRACKET
    case LEFT_BRACE
    case RIGHT_BRACE
    case COMMA
    case EQUAL
    case SEMICOLON
    case END_OF_FILE
    case NULL

    var description: String {
        switch (self) {
        case .NAME(let a):          return "\"\(a)\""
        case .NUMBER(let a):        return "\(a)"
        case .BOOLEAN(let a):       return "\(a)"
        case .LEFT_PARENTHESIS:     return "'('"
        case .RIGHT_PARENTHESIS:    return "')'"
        case .LEFT_BRACKET:         return "'['"
        case .RIGHT_BRACKET:        return "']'"
        case .LEFT_BRACE:           return "'{'"
        case .RIGHT_BRACE:          return "'}'"
        case .COMMA:                return "','"
        case .EQUAL:                return "'='"
        case .SEMICOLON:            return "';'"
        case .END_OF_FILE:          return "EOF"
        case .NULL:                 return "NULL"
        }
    }
}

func ==(a: OpenSCADCSGToken, b: OpenSCADCSGToken) -> Bool {
    switch (a, b) {
    case (.NAME(let a),         .NAME(let b))   where a == b:                           return true
    case (.NUMBER(let a),       .NUMBER(let b)) where a == b:                           return true
    case (.LEFT_PARENTHESIS,    .LEFT_PARENTHESIS):                                     return true
    case (.RIGHT_PARENTHESIS,   .RIGHT_PARENTHESIS):                                    return true
    case (.LEFT_BRACKET,        .LEFT_BRACKET):                                         return true
    case (.RIGHT_BRACKET,       .RIGHT_BRACKET):                                        return true
    case (.LEFT_BRACE,          .LEFT_BRACE):                                           return true
    case (.RIGHT_BRACE,         .RIGHT_BRACE):                                          return true
    case (.COMMA,               .COMMA):                                                return true
    case (.EQUAL,               .EQUAL):                                                return true
    case (.SEMICOLON,           .SEMICOLON):                                            return true
    case (.END_OF_FILE,         .END_OF_FILE):                                          return true
    case (.NULL,                .NULL):                                                 return true
    default:                                                                            return false
    }
}

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
                 "$", "_":
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
