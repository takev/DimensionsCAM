//
//  CSet.swift
//  DimensionsCAM
//
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