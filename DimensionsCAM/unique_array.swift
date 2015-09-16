//
//  searchable_array.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-09.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

import Foundation

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