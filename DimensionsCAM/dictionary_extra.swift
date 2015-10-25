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

extension Dictionary {
    func get(key: Key, default_value: Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            return default_value
        }
    }

    mutating func setdefault(key: Key, default_value: Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            self[key] = default_value
            return default_value
        }
    }
}