//
//  string_extra.swift
//  DimensionsCAM
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

extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerate() {
            self += item
            if idx < lines.count-1 {
                self += sep
            }
        }
    }

    /// Remove whitespace in front of the string.
    func lstrip() -> String {
        for i in self.startIndex ..< self.endIndex {
            if self[i] != " " && self[i] != "\t" && self[i] != "\n" {
                return self[i ..< self.endIndex]
            }
        }
        return ""
    }

    /// Remove whitespace in back of the string.
    func rstrip() -> String {
        for i in (self.startIndex ..< self.endIndex).reverse() {
            if self[i] != " " && self[i] != "\t" && self[i] != "\n" {
                return self[self.startIndex ... i]
            }
        }
        return ""
    }

    /// Remove whitespace before and after the string.
    func strip() -> String {
        return self.lstrip().rstrip()
    }

    /// Take three floating point numbers as string and return a float vector.
    func toDoubles(seperator: String=" ") -> [Double]? {
        var values : [Double] = []
        let components = self.componentsSeparatedByString(seperator)

        for component in components {
            let stripped_component = component.strip()

            guard let float_component = Double(stripped_component) else {
                return nil
            }

            values.append(float_component)
        }

        return values
    }

}