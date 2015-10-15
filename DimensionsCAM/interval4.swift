//
//  interval4.swift
//  DimensionsCAM
//
//  Created by Take Vos on 2015-10-03.
//  Copyright © 2015 VOSGAMES. All rights reserved.
//



struct interval4 {
    let x: Interval
    let y: Interval
    let z: Interval
    let w: Interval

    init(_ a: [Double]) {
        x = Interval(a[0])
        y = Interval(a[1])
        z = Interval(a[2])
        w = Interval(a[3])
    }

    init(_ a: [Interval]) {
        x = a[0]
        y = a[1]
        z = a[2]
        w = a[3]
    }

    init(_ x: Interval, _ y: Interval, _ z: Interval, _ w: Interval) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }


}

func dot(lhs: interval4, _ rhs: interval4) -> Interval {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Expect dot product on two vectors, not points")
    return (
        lhs.x.square +
        lhs.y.square +
        lhs.z.square
    )
}

func cross(lhs: interval4, _ rhs: interval4) -> interval4 {
    assert(lhs.w == 0.0 && rhs.w == 0.0, "Expect dot product on two vectors, not points")
    let x0 = lhs.y * rhs.z
    let x1 = lhs.z * rhs.y
    let x = x0 - x1

    let y0 = lhs.z * rhs.x
    let y1 = lhs.x * rhs.z
    let y = y0 - y1

    let z0 = lhs.x * rhs.y
    let z1 = lhs.y * rhs.x
    let z = z0 - z1

    return interval4([x, y, z, Interval(0.0)])
}

func ∙(lhs: interval4, rhs: interval4) -> Interval {
    return dot(lhs, rhs)
}

func ×(lhs: interval4, rhs: interval4) -> interval4 {
    return cross(lhs, rhs)
}
