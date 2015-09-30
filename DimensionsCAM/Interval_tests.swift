//
//  Interval_tests.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-29.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import XCTest
@testable import DimensionsCAM

class Interval_tests: XCTestCase {
    var previous_round_mode: Int32 = -1
    
    override func setUp() {
        super.setUp()

        previous_round_mode = Interval.setRoundMode()
    }
    
    override func tearDown() {
        Interval.unsetRoundMode(previous_round_mode)

        super.tearDown()
    }
    
    func testAddOperations() {
        XCTAssertEqual(Interval(10.0, 20.0) + Interval(13.0, 17.0), Interval(23.0, 37.0));
        XCTAssertEqual(Interval(13.0, 17.0) + Interval(10.0, 20.0), Interval(23.0, 37.0));
    }

    func testSubOperations() {
        XCTAssertEqual(Interval(10.0, 20.0) - Interval(13.0, 16.0), Interval(-6.0, 7.0));
        XCTAssertEqual(Interval(13.0, 16.0) - Interval(10.0, 20.0), Interval(-7.0, 6.0));
    }

    func testNegOperations() {
        XCTAssertEqual(-Interval(10.0, 20.0), Interval(-20.0, -10.0));
    }

    func testMulOperations() {
        XCTAssertEqual(Interval( 1.0,  2.0) * Interval( 3.0,  4.0), Interval( 3.0,  8.0));
        XCTAssertEqual(Interval(-1.0,  2.0) * Interval( 3.0,  4.0), Interval(-4.0,  8.0));
        XCTAssertEqual(Interval(-2.0,  1.0) * Interval( 3.0,  4.0), Interval(-8.0,  4.0));
        XCTAssertEqual(Interval(-2.0, -1.0) * Interval( 3.0,  4.0), Interval(-8.0, -3.0));
        XCTAssertEqual(Interval( 1.0,  2.0) * Interval(-3.0,  4.0), Interval(-6.0,  8.0));
        XCTAssertEqual(Interval(-1.0,  2.0) * Interval(-3.0,  4.0), Interval(-6.0,  8.0));
        XCTAssertEqual(Interval(-2.0,  1.0) * Interval(-3.0,  4.0), Interval(-8.0,  6.0));
        XCTAssertEqual(Interval(-2.0, -1.0) * Interval(-3.0,  4.0), Interval(-8.0,  6.0));
        XCTAssertEqual(Interval( 1.0,  2.0) * Interval(-4.0,  3.0), Interval(-8.0,  6.0));
        XCTAssertEqual(Interval(-1.0,  2.0) * Interval(-4.0,  3.0), Interval(-8.0,  6.0));
        XCTAssertEqual(Interval(-2.0,  1.0) * Interval(-4.0,  3.0), Interval(-6.0,  8.0));
        XCTAssertEqual(Interval(-2.0, -1.0) * Interval(-4.0,  3.0), Interval(-6.0,  8.0));
        XCTAssertEqual(Interval( 1.0,  2.0) * Interval(-4.0, -3.0), Interval(-8.0, -3.0));
        XCTAssertEqual(Interval(-1.0,  2.0) * Interval(-4.0, -3.0), Interval(-8.0,  4.0));
        XCTAssertEqual(Interval(-2.0, -1.0) * Interval(-4.0, -3.0), Interval( 3.0,  8.0));
    }

    func testDivOperations() {
        XCTAssertEqual(Interval( 1.0,  2.0) / Interval( 4.0,  8.0), Interval( 0.125, 0.5));
        XCTAssertEqual(Interval(-1.0,  2.0) / Interval( 4.0,  8.0), Interval(-0.25,  0.5));
        XCTAssertEqual(Interval(-2.0,  1.0) / Interval( 4.0,  8.0), Interval(-0.5,   0.25));
        XCTAssertEqual(Interval(-2.0, -1.0) / Interval( 4.0,  8.0), Interval(-0.5,  -0.125));
        XCTAssertEqual(Interval( 1.0,  2.0) / Interval(-4.0,  8.0), Interval.entire);
        XCTAssertEqual(Interval(-1.0,  2.0) / Interval(-4.0,  8.0), Interval.entire);
        XCTAssertEqual(Interval(-2.0,  1.0) / Interval(-4.0,  8.0), Interval.entire);
        XCTAssertEqual(Interval(-2.0, -1.0) / Interval(-4.0,  8.0), Interval.entire);
        XCTAssertEqual(Interval( 1.0,  2.0) / Interval(-8.0,  4.0), Interval.entire);
        XCTAssertEqual(Interval(-1.0,  2.0) / Interval(-8.0,  4.0), Interval.entire);
        XCTAssertEqual(Interval(-2.0,  1.0) / Interval(-8.0,  4.0), Interval.entire);
        XCTAssertEqual(Interval(-2.0, -1.0) / Interval(-8.0,  4.0), Interval.entire);
        XCTAssertEqual(Interval( 1.0,  2.0) / Interval(-8.0, -4.0), Interval(-0.5,  -0.125));
        XCTAssertEqual(Interval(-1.0,  2.0) / Interval(-8.0, -4.0), Interval(-0.5,   0.25));
        XCTAssertEqual(Interval(-2.0,  1.0) / Interval(-8.0, -4.0), Interval(-0.25,  0.5));
        XCTAssertEqual(Interval(-2.0, -1.0) / Interval(-8.0, -4.0), Interval( 0.125, 0.5));
    }

    func testHullOperations() {
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval(-4.0, -3.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval(-4.0, -1.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval(-4.0,  4.0), Interval(-4.0, 4.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval(-1.0,  1.0), Interval(-2.0, 2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval( 1.0,  4.0), Interval(-2.0, 4.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval( 3.0,  4.0), Interval(-2.0, 4.0));
        XCTAssertEqual(Interval(-4.0, -3.0) ⩂ Interval(-2.0,  2.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval(-4.0, -1.0) ⩂ Interval(-2.0,  2.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval(-4.0,  4.0) ⩂ Interval(-2.0,  2.0), Interval(-4.0, 4.0));
        XCTAssertEqual(Interval(-1.0,  1.0) ⩂ Interval(-2.0,  2.0), Interval(-2.0, 2.0));
        XCTAssertEqual(Interval( 1.0,  4.0) ⩂ Interval(-2.0,  2.0), Interval(-2.0, 4.0));
        XCTAssertEqual(Interval( 3.0,  4.0) ⩂ Interval(-2.0,  2.0), Interval(-2.0, 4.0));
    }

    func testIntersectionOperations() {
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval(-4.0, -3.0), Interval.empty);
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval(-4.0, -1.0), Interval(-2.0, -1.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval(-4.0,  4.0), Interval(-2.0,  2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval(-1.0,  1.0), Interval(-1.0,  1.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval( 1.0,  4.0), Interval( 1.0,  2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval( 3.0,  4.0), Interval.empty);
        XCTAssertEqual(Interval(-4.0, -3.0) ∩ Interval(-2.0,  2.0), Interval.empty);
        XCTAssertEqual(Interval(-4.0, -1.0) ∩ Interval(-2.0,  2.0), Interval(-2.0, -1.0));
        XCTAssertEqual(Interval(-4.0,  4.0) ∩ Interval(-2.0,  2.0), Interval(-2.0,  2.0));
        XCTAssertEqual(Interval(-1.0,  1.0) ∩ Interval(-2.0,  2.0), Interval(-1.0,  1.0));
        XCTAssertEqual(Interval( 1.0,  4.0) ∩ Interval(-2.0,  2.0), Interval( 1.0,  2.0));
        XCTAssertEqual(Interval( 3.0,  4.0) ∩ Interval(-2.0,  2.0), Interval.empty);
    }

    func testHullMixOperations() {
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval(-4.0, -4.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval( 1.0,  1.0), Interval(-2.0, 2.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ⩂ Interval( 4.0,  4.0), Interval(-2.0, 4.0));
        XCTAssertEqual(Interval(-4.0, -4.0) ⩂ Interval(-2.0,  2.0), Interval(-4.0, 2.0));
        XCTAssertEqual(Interval( 1.0,  1.0) ⩂ Interval(-2.0,  2.0), Interval(-2.0, 2.0));
        XCTAssertEqual(Interval( 4.0,  4.0) ⩂ Interval(-2.0,  2.0), Interval(-2.0, 4.0));
    }

    func testIntersectionMixOperations() {
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval(-4.0, -4.0), Interval.empty);
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval( 1.0,  1.0), Interval(1.0, 1.0));
        XCTAssertEqual(Interval(-2.0,  2.0) ∩ Interval( 4.0,  4.0), Interval.empty);
        XCTAssertEqual(Interval(-4.0, -4.0) ∩ Interval(-2.0,  2.0), Interval.empty);
        XCTAssertEqual(Interval( 1.0,  1.0) ∩ Interval(-2.0,  2.0), Interval(1.0, 1.0));
        XCTAssertEqual(Interval( 4.0,  4.0) ∩ Interval(-2.0,  2.0), Interval.empty);
    }

    func testHullScalarOperations() {
        XCTAssertEqual(Interval(-2.0, -2.0) ⩂ Interval(-4.0, -4.0), Interval(-4.0, -2.0));
        XCTAssertEqual(Interval(-2.0, -2.0) ⩂ Interval(-2.0, -2.0), Interval(-2.0, -2.0));
        XCTAssertEqual(Interval(-2.0, -2.0) ⩂ Interval( 2.0,  2.0), Interval(-2.0,  2.0));
        XCTAssertEqual(Interval(-4.0, -4.0) ⩂ Interval(-2.0, -2.0), Interval(-4.0, -2.0));
        XCTAssertEqual(Interval(-2.0, -2.0) ⩂ Interval(-2.0, -2.0), Interval(-2.0, -2.0));
        XCTAssertEqual(Interval( 2.0,  2.0) ⩂ Interval(-2.0, -2.0), Interval(-2.0,  2.0));
    }

    func testStrictSubsetOperations() {
        XCTAssertEqual(Interval(-1.0, 2.0) ⊂ Interval(-1.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 1.0) ⊂ Interval(-3.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊂ Interval(-1.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊂ Interval(-1.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊂ Interval(-2.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊂ Interval(-2.0, 3.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊂ Interval(-3.0, 2.0), false);
        XCTAssertEqual(Interval(-1.0, 2.0) ⊂ Interval(-1.0, 2.0), false);
        XCTAssertEqual(Interval(-3.0, 2.0) ⊂ Interval(-2.0, 1.0), false);
        XCTAssertEqual(Interval(-1.0, 1.0) ⊂ Interval(-2.0, 2.0), true);
        XCTAssertEqual(Interval(-1.0, 2.0) ⊂ Interval(-2.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 1.0) ⊂ Interval(-2.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 3.0) ⊂ Interval(-2.0, 2.0), false);
        XCTAssertEqual(Interval(-3.0, 2.0) ⊂ Interval(-2.0, 2.0), false);
    }

    func testSubsetOperations() {
        XCTAssertEqual(Interval(-1.0, 2.0) ⊆ Interval(-1.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 1.0) ⊆ Interval(-3.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊆ Interval(-1.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊆ Interval(-1.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊆ Interval(-2.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊆ Interval(-2.0, 3.0), true);
        XCTAssertEqual(Interval(-2.0, 2.0) ⊆ Interval(-3.0, 2.0), true);
        XCTAssertEqual(Interval(-3.0, 2.0) ⊆ Interval(-2.0, 1.0), false);
        XCTAssertEqual(Interval(-1.0, 1.0) ⊆ Interval(-2.0, 2.0), true);
        XCTAssertEqual(Interval(-1.0, 2.0) ⊆ Interval(-2.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 1.0) ⊆ Interval(-2.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 3.0) ⊆ Interval(-2.0, 2.0), false);
        XCTAssertEqual(Interval(-3.0, 2.0) ⊆ Interval(-2.0, 2.0), false);
    }

    func testEqualOperations() {
        XCTAssertEqual(Interval(-1.0, 2.0) == Interval(-1.0, 2.0), true);
        XCTAssertEqual(Interval(-2.0, 1.0) == Interval(-3.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) == Interval(-1.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) == Interval(-1.0, 2.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) == Interval(-2.0, 1.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) == Interval(-2.0, 3.0), false);
        XCTAssertEqual(Interval(-2.0, 2.0) == Interval(-3.0, 2.0), false);
    }

    func testStrictSubsetScalarOperations() {
        XCTAssertEqual(Interval(-1.0,  2.0) ⊂ Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊂ Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊂ Interval( 0.0,  0.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊂ Interval( 2.0,  2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊂ Interval( 3.0,  3.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊂ Interval( 1.0,  1.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊂ Interval(-1.0, -1.0), false);
        XCTAssertEqual(Interval(-2.0, -2.0) ⊂ Interval(-1.0,  2.0), false);
        XCTAssertEqual(Interval(-2.0, -2.0) ⊂ Interval(-2.0,  2.0), false);
        XCTAssertEqual(Interval( 0.0,  0.0) ⊂ Interval(-2.0,  2.0), true);
        XCTAssertEqual(Interval( 2.0,  2.0) ⊂ Interval(-2.0,  2.0), false);
        XCTAssertEqual(Interval( 3.0,  3.0) ⊂ Interval(-2.0,  2.0), false);
        XCTAssertEqual(Interval( 1.0,  1.0) ⊂ Interval(-1.0, -1.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊂ Interval(-1.0, -1.0), false);
    }

    func testSubsetScalarOperations() {
        XCTAssertEqual(Interval(-1.0,  2.0) ⊆ Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊆ Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊆ Interval( 0.0,  0.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊆ Interval( 2.0,  2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) ⊆ Interval( 3.0,  3.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊆ Interval( 1.0,  1.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊆ Interval(-1.0, -1.0), true);
        XCTAssertEqual(Interval(-2.0, -2.0) ⊆ Interval(-1.0,  2.0), false);
        XCTAssertEqual(Interval(-2.0, -2.0) ⊆ Interval(-2.0,  2.0), true);
        XCTAssertEqual(Interval( 0.0,  0.0) ⊆ Interval(-2.0,  2.0), true);
        XCTAssertEqual(Interval( 2.0,  2.0) ⊆ Interval(-2.0,  2.0), true);
        XCTAssertEqual(Interval( 3.0,  3.0) ⊆ Interval(-2.0,  2.0), false);
        XCTAssertEqual(Interval( 1.0,  1.0) ⊆ Interval(-1.0, -1.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) ⊆ Interval(-1.0, -1.0), true);
    }

    func testEqualScalarOperations() {
        XCTAssertEqual(Interval(-1.0,  2.0) == Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) == Interval(-2.0, -2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) == Interval( 0.0,  0.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) == Interval( 2.0,  2.0), false);
        XCTAssertEqual(Interval(-2.0,  2.0) == Interval( 3.0,  3.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) == Interval( 1.0,  1.0), false);
        XCTAssertEqual(Interval(-1.0, -1.0) == Interval(-1.0, -1.0), true);
    }

    func testSquareOperations() {
        XCTAssertEqual(square(Interval( 11.0,  11.0)), Interval(121.0, 121.0));
        XCTAssertEqual(square(Interval(  0.0,   0.0)), Interval(  0.0,   0.0));
        XCTAssertEqual(square(Interval( -9.0,  -9.0)), Interval( 81.0,  81.0));
    }

    func testSqrtOperations() {
        XCTAssertEqual(sqrt(Interval(121.0, 121.0)), Interval(11.0, 11.0));
        XCTAssertEqual(sqrt(Interval(  0.0,   0.0)), Interval( 0.0,  0.0));
        XCTAssertEqual(sqrt(Interval( 81.0,  81.0)), Interval( 9.0,  9.0));
    }

    func testPowerOperations() {
        //XCTAssertEqual(Interval(2.0, 2.0) ** Interval(2.0, 2.0), Interval(   4.0,    4.0));
        //XCTAssertEqual(Interval(4.0, 4.0) ** Interval(5.0, 5.0), Interval(1024.0, 1024.0));
        //XCTAssertEqual(Interval(2.0, 2.0) ** Interval(3.0, 3.0), Interval(   8.0,    8.0));
    }
}
