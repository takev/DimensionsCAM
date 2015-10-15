//
//  string_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-09.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

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