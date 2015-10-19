//
//  OpenSCADCSGLexer_tests.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-04.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import XCTest
import simd
@testable import DimensionsCAM

func XCTAssertEqualThrows<T: Equatable>(
    @autoclosure expression1: () throws -> T?,
    @autoclosure _ expression2: () throws -> T?,
    _ message: String = "",
    file: String = __FILE__,
    line: UInt = __LINE__
) {
    var result1: T? = nil
    var result2: T? = nil
    var error1: ErrorType? = nil
    var error2: ErrorType? = nil

    do {
        result1 = try expression1()
    } catch {
        error1 = error
    }

    do {
        result2 = try expression2()
    } catch {
        error2 = error
    }

    if result1 != nil && result2 != nil {
        XCTAssertEqual(result1!, result2!, message, file:file, line:line)
    } else if error1  != nil {
        XCTFail("left expression throws \(error1)", file:file, line:line)
    } else if error2  != nil {
        XCTFail("right expression throws \(error2)", file:file, line:line)
    }
}

class OpenSCADCSG_tests: XCTestCase {
    let test1 = String(sep:"\n",
        "foo() {",
        "    bar([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]], top=[1, 2.0e-3, -3.5, 4], center = 5, $f=6);",
        "}\n"
    )

    let test2 = String(sep:"\n",
        "group() {",
        "    multmatrix([[1, 0, 0, 40], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]) {",
        "        difference() {",
        "            union() {",
        "                cube(size = [100, 100, 100], center = true);",
        "                multmatrix([[1, 0, 0, 49.9], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]) {",
        "                    multmatrix([[2.22045e-16, 0, 1, 0], [0, 1, 0, 0], [-1, 0, 2.22045e-16, 0], [0, 0, 0, 1]]) {",
        "                        cylinder($fn = 0, $fa = 2, $fs = 2, h = 200, r1 = 50, r2 = 50, center = false);",
        "                    }",
        "                }",
        "            }",
        "            union() {",
        "                multmatrix([[1, 0, 0, 150], [0, 1, 0, -44], [0, 0, 1, 10], [0, 0, 0, 1]]) {",
        "                    multmatrix([[1, 0, 0, 0], [0, 0.939693, -0.34202, 0], [0, 0.34202, 0.939693, 0], [0, 0, 0, 1]]) {",
        "                        cube(size = [40, 40, 110], center = true);",
        "                    }",
        "                }",
        "                multmatrix([[1, 0, 0, 150], [0, 1, 0, 30], [0, 0, 1, -25], [0, 0, 0, 1]]) {",
        "                    multmatrix([[1, 0, 0, 0], [0, -0.173648, -0.984808, 0], [0, 0.984808, -0.173648, 0], [0, 0, 0, 1]]) {",
        "                        cylinder($fn = 0, $fa = 2, $fs = 2, h = 50, r1 = 10, r2 = 10, center = false);",
        "                    }",
        "                }",
        "            }",
        "        }",
        "    }",
        "}\n"

    )

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLexer() {
        var p = OpenSCADCSGLexer(text:test1, filename:"<test1>")

        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NAME("foo"))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_PARENTHESIS)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_PARENTHESIS)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACE)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NAME("bar"))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_PARENTHESIS)

        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(1.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(2.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(3.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(4.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(5.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(6.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(7.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(8.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(9.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(10.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(11.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(12.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(13.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(14.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(15.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(16.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)

        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NAME("top"))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.EQUAL)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.LEFT_BRACKET)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(1.0))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(2.0e-3))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(-3.5))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(4))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACKET)

        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NAME("center"))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.EQUAL)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(5))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.COMMA)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NAME("$f"))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.EQUAL)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.NUMBER(6))
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_PARENTHESIS)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.SEMICOLON)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.RIGHT_BRACE)
        XCTAssertEqualThrows(try p.getToken(), OpenSCADCSGToken.END_OF_FILE)
    }

    func testGrammar() {
        var p = OpenSCADCSGGrammar(text: test1, filename: "<test1>")

        let expected: OpenSCADCSGAST = .BRANCH("program", [
            .BRANCH("function", [
                .LEAF_NAME("foo"),
                .BRANCH("arguments", []),
                .BRANCH("block", [
                    .BRANCH("function", [
                        .LEAF_NAME("bar"),
                        .BRANCH("arguments", [
                            .BRANCH("argument", [
                                .NULL,
                                .LEAF_MATRIX(double4x4(rows:[double4(1, 2, 3, 4), double4(5, 6, 7, 8), double4(9, 10, 11, 12), double4(13, 14, 15, 16)]))
                            ]),
                            .BRANCH("argument", [
                                .LEAF_NAME("top"),
                                .LEAF_VECTOR(double4(1.0, 0.002, -3.5, 4))
                            ]),
                            .BRANCH("argument", [
                                .LEAF_NAME("center"),
                                .LEAF_NUMBER(5)
                            ]),
                            .BRANCH("argument", [
                                .LEAF_NAME("$f"),
                                .LEAF_NUMBER(6)
                            ])
                        ]),
                        .BRANCH("block", [])
                    ])
                ])
            ])
        ])

        XCTAssertEqualThrows(try p.parseProgram(), expected)
    }

    func testParser() {
        var p = OpenSCADCSGParser(text: test2, filename: "<test2>")

        Swift.print(try! p.parseProgram())
    }
}
