//
//  SphericalCoordinate.swift
//  Graviton
//
//  Created by Sihao Lu on 1/3/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import SceneKit

public struct SphericalCoordinate {
    public let distance: Float
    public let rightAscension: Float
    public let declination: Float
    
    init(cartesian v: SCNVector3) {
        distance = sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        rightAscension = acos(v.z / distance)
        declination = atan2(v.y, v.x)
    }
}

public extension SCNVector3 {
    public init(sphericalCoordinate s: SphericalCoordinate) {
        self.init(
            s.distance * sin(s.rightAscension) * cos(s.declination),
            s.distance * sin(s.rightAscension) * sin(s.declination),
            s.distance * cos(s.rightAscension)
        )
    }
}
