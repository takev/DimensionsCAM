//
//  CSet.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-09-26.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//

class CSet<Element: Hashable>: CollectionType {
    typealias Index = Set<Element>.Index
    typealias Generator = Set<Element>.Generator
    typealias SubSequence = Set<Element>.SubSequence

    var intrinsic: Set<Element>

    init() {
        intrinsic = Set<Element>()
    }

    var count:      Index.Distance  { return intrinsic.count }
    var endIndex:   Index           { return intrinsic.endIndex }
    var startIndex: Index           { return intrinsic.startIndex }
    var isEmpty:    Bool            { return intrinsic.isEmpty }
    var first:      Element?        { return intrinsic.first }

    subscript(range: Range<Index>) -> SubSequence {
        return intrinsic[range]
    }

    subscript(index: Index) -> Element {
        return intrinsic[index]
    }

    func generate() -> SetGenerator<Element> {
        return intrinsic.generate()
    }

    func prefixThrough(position: Index) -> SubSequence {
        return intrinsic.prefixThrough(position)
    }

    func prefixUpTo(end: Index) -> SubSequence {
        return intrinsic.prefixUpTo(end)
    }

    func suffixFrom(start: Index) -> SubSequence {
        return intrinsic.suffixFrom(start)
    }

    func insert(member: Element) {
        intrinsic.insert(member)
    }

    func remove(member: Element) -> Element? {
        return intrinsic.remove(member)
    }


}