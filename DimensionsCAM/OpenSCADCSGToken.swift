//
//  OpenSCADCSGToken.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-16.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

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

