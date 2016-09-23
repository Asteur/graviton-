//
//  Constants.swift
//  Graviton
//
//  Created by Ben Lu on 9/13/16.
//  Copyright © 2016 Ben Lu. All rights reserved.
//

import SceneKit

let earthAxialTilt: Float = 23.44 / 180 * Float(M_PI)

let gravConstant: Float = 6.67408e-11

let earthYear: Float = 365.256363004 * 3600 * 24

let earthOrbit = Orbit(
    shape: Orbit.ConicSection.from(
        semimajorAxis: 149494366257.0978,
        eccentricity: 0.0167086
    ),
    orientation: Orbit.Orientation(
        inclination: 0,
        longitudeOfAscendingNode: 174.9 / 180 * Float(M_PI),
        argumentOfPeriapsis: 288.1 / 180 * Float(M_PI)
    )
)

let moonOrbit = Orbit(
    shape: Orbit.ConicSection.from(
        semimajorAxis: 384308437.7707066,
        eccentricity: 0.05328149353682574
    ),
    orientation: Orbit.Orientation(
        inclination: 4.922677908 / 180 * Float(M_PI),
        longitudeOfAscendingNode: 2.296616161126016 / 180 * Float(M_PI),
        argumentOfPeriapsis: 199.7640930160823 / 180 * Float(M_PI)
    )
)

let mercuryOrbit = Orbit(
    shape: Orbit.ConicSection.from(
        semimajorAxis: 57908973645.88802,
        eccentricity: 0.2056187266319207
    ),
    orientation: Orbit.Orientation(
        inclination: 5.1625210886 / 180 * Float(M_PI),
        longitudeOfAscendingNode: 10.86541167564728 / 180 * Float(M_PI),
        argumentOfPeriapsis: 66.90371044151551 / 180 * Float(M_PI)
    )
)

var solarSystem: SolarSystem = {
    let earth = CelestialBody(knownBody: .earth)
    let sun = Sun(knownBody: .sun)
    let motion = OrbitalMotion(centralBody: sun, orbit: earthOrbit)
    sun.addSatellite(satellite: earth, motion: motion)
    return SolarSystem(star: sun)
}()

// the value is GM, m^3s^-2
enum KnownBody {
    case mercury
    case venus
    case earth
    case moon
    case sun
    
    var name: String {
        switch self {
        case .mercury:
            return "mercury"
        case .venus:
            return "venus"
        case .earth:
            return "earth"
        case .moon:
            return "moon"
        case .sun:
            return "sol"
        }
    }
    
    var gravParam: Float {
        switch self {
        case .mercury:
            return 2.2032e13
        case .venus:
            return 3.24859e14
        case .earth:
            return 3.9860044e14
        case .moon:
            return 4.902794e12
        case .sun:
            return 1.3271244e20
        }
    }
    
    var radius: Float {
        switch self {
        case .mercury:
            return 2439700
        case .venus:
            return 6051800
        case .earth:
            return 6378137
        case .moon:
            return 1736482
        case .sun:
            return 695700000
        }
    }
    
    var rotationPeriod: Float {
        switch self {
        case .mercury:
            return 5067031.68
        case .venus:
            return 20996798.4
        case .earth:
            return 86164.098903691
        case .moon:
            // moon is tidally locked to the earth
            return 2360584.68479999
        // sun actually has pretty fast differential rotation, because it's a bright ball, we don't actually notice the rotation
        case .sun:
            return 0
        }
    }
    
    var axialTilt: Float {
        switch self {
        case .mercury:
            return 2.11 / 180 * Float(M_PI)
        case .venus:
            return 177.36 / 180 * Float(M_PI)
        case .earth:
            return 23.44 / 180 * Float(M_PI)
        case .moon:
            return 1.5424 / 180 * Float(M_PI)
        case .sun:
            return 0
        }
    }
    
    var initialRotation: Float {
        switch self {
        case .earth:
            // TODO: determine initial rotation at epoch
            return 0 / 180 * Float(M_PI)
        case .moon:
            return 0 / 180 * Float(M_PI)
        default:
            return 0
        }
    }
    
}

// s
let siderealDay: Float = 23 * 3600 + 56 * 60 + 4

// m
let earthEquatorialRadius: Float = 6378137
let moonRadius: Float = 1736482
let LEOAltitude: Float = 400000
let geoSyncAltitude: Float = 35786000
let moonAltitude: Float = 384472282

// m
let lightSecondDist: Float = speedOfLight * 1
let lightMinuteDist: Float = speedOfLight * 60
let astronomicalUnitDist: Float = 1.4960e11
let lightYearDist: Float = 9.4607e15
let parsecDist: Float = 3.0857e16

// m/s
let speedOfLight: Float = 299792458
