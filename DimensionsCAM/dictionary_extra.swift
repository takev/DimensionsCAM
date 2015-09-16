//
//  dictionary_extra.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-10.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

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