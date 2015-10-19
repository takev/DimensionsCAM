//
//  OpenSCADCSGError.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-16.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

enum OpenSCADCSGError : ErrorType, CustomStringConvertible {
    case UNKNOWN_CHARACTER(String, Int, Character)
    case BAD_NUMBER(String, Int, String)
    case UNEXPECTED_TOKEN(String, Int, OpenSCADCSGToken, OpenSCADCSGToken)
    case BAD_VECTOR(String, Int, [Double])
    case UNEXPECTED_ASTNODE(OpenSCADCSGAST, String)

    var description: String {
        switch (self) {
        case .UNKNOWN_CHARACTER(let filename, let linenr, let character):
            return "\(filename):\(linenr + 1): Unknown character '\(character)'"

        case .BAD_NUMBER(let filename, let linenr, let text):
            return "\(filename):\(linenr + 1): Bad number \"\(text)\""
            
        case .BAD_VECTOR(let filename, let linenr, let value):
            return "\(filename):\(linenr + 1): Bad vector \(value)"
            
        case .UNEXPECTED_TOKEN(let filename, let linenr, let expected_token, let received_token):
            return "\(filename):\(linenr + 1): Unexpected token \(received_token), expecting \(expected_token)"

        case .UNEXPECTED_ASTNODE(let node, let message):
            return "Unexpected node \(node), \(message)."
        }
    }
}

