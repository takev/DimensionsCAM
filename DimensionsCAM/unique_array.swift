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

struct unique_array<T: Hashable> {
    var items           : [T]       = []
    var index_by_item   : [T : Int] = [:]

    /// Add an item to the unique array.
    /// Return the position where the item is or was inserted.
    ///
    mutating func add(item: T) -> Int {
        if let i = index_by_item[item] {
            return i

        } else {
            let i = items.count
            items.append(item)
            index_by_item[item] = i
            return i
        }
    }

    subscript(i: Int) -> T {
        get {
            return items[i]
        }
    }
}