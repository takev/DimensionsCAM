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

