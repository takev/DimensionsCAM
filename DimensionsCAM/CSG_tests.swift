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

import XCTest
import simd

class CSG_tests: XCTestCase {
    var previous_round_mode: Int32 = -1

    var cube: CSGObject? = nil
    
    override func setUp() {
        super.setUp()

        previous_round_mode = Interval.setRoundMode()

        cube = CSGCube(size: double3(2.0, 3.0, 4.0))
    }
    
    override func tearDown() {
        Interval.unsetRoundMode(previous_round_mode)

        super.tearDown()
    }
    
    func testBoundingBox() {
        cube!.update(double4x4.identity)
        Swift.print(cube!.boundingBox)
    }
}