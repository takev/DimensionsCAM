//
//  OpenSCADCSGGrammar.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-08.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import simd

struct OpenSCADCSGGrammar {
    var lexer:          OpenSCADCSGLexer
    var currentToken:   OpenSCADCSGToken = .NULL
    var nextToken:      OpenSCADCSGToken = .NULL

    var filename: String {
        return lexer.filename
    }

    init(text: String, filename: String) {
        lexer = OpenSCADCSGLexer(text: text, filename: filename)
    }

    mutating func loadFirstToken() throws {
        currentToken = try lexer.getToken()
        nextToken = try lexer.getToken()
    }

    mutating func loadNextToken() throws {
        currentToken = nextToken
        nextToken = try lexer.getToken()
    }

    mutating func acceptToken(expectedToken: OpenSCADCSGToken) throws {
        guard currentToken == expectedToken else {
            throw OpenSCADCSGError.UNEXPECTED_TOKEN(lexer.filename, lexer.line_nr, expectedToken, currentToken)
        }

        try loadNextToken()
    }

    mutating func acceptName() throws -> String {
        switch currentToken {
        case .NAME(let name):
            try loadNextToken()
            return name
        default:
            throw OpenSCADCSGError.UNEXPECTED_TOKEN(lexer.filename, lexer.line_nr, .NAME(""), currentToken)
        }
    }

    mutating func acceptNumber() throws -> Double {
        switch currentToken {
        case .NUMBER(let number):
            try loadNextToken()
            return number
        default:
            throw OpenSCADCSGError.UNEXPECTED_TOKEN(lexer.filename, lexer.line_nr, .NUMBER(0.0), currentToken)
        }
    }

    mutating func acceptBoolean() throws -> Bool {
        switch currentToken {
        case .BOOLEAN(let value):
            try loadNextToken()
            return value
        default:
            throw OpenSCADCSGError.UNEXPECTED_TOKEN(lexer.filename, lexer.line_nr, .BOOLEAN(false), currentToken)
        }
    }

    /// vector ::= '[' number ',' number ',' number ',' number ']'
    mutating func acceptVector() throws -> double4 {
        var values: [Double] = []
        var first_iteration = true

        try acceptToken(.LEFT_BRACKET)

        while currentToken != .RIGHT_BRACKET {
            if first_iteration {
                first_iteration = false
            } else {
                try acceptToken(.COMMA)
            }

            let value = try acceptNumber()
            values.append(value)
        }

        try acceptToken(.RIGHT_BRACKET)

        switch values.count {
        case 4:
            return double4(values)
        case 3:
            return double4(values[0], values[1], values[2], 0.0)
        default:
            throw OpenSCADCSGError.BAD_VECTOR(lexer.filename, lexer.line_nr, values)
        }
    }


    /// matrix ::= '[' vector ',' vector ',' vector ',' vector ']'
    mutating func acceptMatrix() throws -> double4x4 {
        var values: [double4] = []

        try acceptToken(.LEFT_BRACKET)

        for _ in 0 ..< 3 {
            let value = try acceptVector()
            values.append(value)

            try acceptToken(.COMMA)
        }

        let value = try acceptVector()
        values.append(value)

        try acceptToken(.RIGHT_BRACKET)
        return double4x4(rows:values)
    }

    /// block_list ::= function
    ///                block_list function
    mutating func parseBlock() throws -> OpenSCADCSGAST {
        var functions: [OpenSCADCSGAST] = []

        while currentToken != .RIGHT_BRACE {
            let function = try parseFunction()

            functions.append(function)
        }

        return .BRANCH("block", functions)
    }


    /// matrix ::= '[' vector ',' vector ',' vector ',' vector ']'
    mutating func parseMatrix() throws -> OpenSCADCSGAST {
        let value = try acceptMatrix()
        return .LEAF_MATRIX(value)
    }

    /// vector ::= '[' number ',' number ',' number ',' number ']'
    mutating func parseVector() throws -> OpenSCADCSGAST {
        let value = try acceptVector()
        return .LEAF_VECTOR(value)
    }

    /// value ::= number
    ///           vector
    ///           matrix
    mutating func parseValue() throws -> OpenSCADCSGAST {
        switch currentToken {
        case .LEFT_BRACKET:
            if nextToken == .LEFT_BRACKET {
                return try parseMatrix()
            } else {
                return try parseVector()
            }
        case .NUMBER:
            let number = try acceptNumber()
            return .LEAF_NUMBER(number)
        case .BOOLEAN:
            let value = try acceptBoolean()
            return .LEAF_BOOLEAN(value)
        default:
            throw OpenSCADCSGError.UNEXPECTED_TOKEN(lexer.filename, lexer.line_nr, .NUMBER(0.0), currentToken)
        }
    }

    /// argument ::= name '=' value
    ///              value
    mutating func parseArgument() throws -> OpenSCADCSGAST {
        if let name = try? acceptName() {
            try acceptToken(.EQUAL)
            let value = try parseValue()
            return .BRANCH("argument", [.LEAF_NAME(name), value])

        } else {
            let value = try parseValue()
            return .BRANCH("argument", [.NULL, value])
        }
    }

    /// argument_list ::= argument
    ///                   argument_list ',' argument
    mutating func parseArguments() throws -> OpenSCADCSGAST {
        var arguments: [OpenSCADCSGAST] = []
        var first_iteration = true

        while currentToken != .RIGHT_PARENTHESIS {
            if !first_iteration {
                try acceptToken(.COMMA)
            } else {
                first_iteration = false
            }

            let argument = try parseArgument()
            arguments.append(argument)
        }

        return .BRANCH("arguments", arguments)
    }


    /// function ::= name '(' argument_list ')' '{' block_list '}'
    ///              name '(' argument_list ')' ';'
    ///              name '(' ')' '{' block_list '}'
    ///              name '(' ')' ';'
    mutating func parseFunction() throws -> OpenSCADCSGAST {
        let name = try acceptName()

        try acceptToken(.LEFT_PARENTHESIS)

        let arguments = try parseArguments()

        try acceptToken(.RIGHT_PARENTHESIS)

        var block: OpenSCADCSGAST
        if let _ = try? acceptToken(.SEMICOLON) {
            block = OpenSCADCSGAST.BRANCH("block", [])

        } else {
            try acceptToken(.LEFT_BRACE)

            block = try parseBlock()

            try acceptToken(.RIGHT_BRACE)
        }

        return .BRANCH("function", [.LEAF_NAME(name), arguments, block])
    }

    /// program ::= function
    mutating func parseProgram() throws -> OpenSCADCSGAST {
        try loadFirstToken()

        let function = try parseFunction()

        try acceptToken(.END_OF_FILE)

        return .BRANCH("program", [function])
    }
}
