//
//  SolarSystem.swift
//  Graviton
//
//  Created by Ben Lu on 9/14/16.
//  Copyright © 2016 Ben Lu. All rights reserved.
//

import UIKit

protocol Searchable {
    subscript(name: String) -> Body? { get }
}

protocol BoundedByGravity: Searchable {
    var satellites: [Body] { get }
    func addSatellite(satellite: Body, orbit: Orbit)
}

struct SolarSystem: Searchable {
    let star: Sun
    
    subscript(name: String) -> Body? {
        if star.name == name {
            return star
        }
        return star[name]
    }
}

class Body {
    let mass: Float
    let name: String
    weak var centralBody: CelestialBody?
    
    init(name: String, mass: Float) {
        self.name = name
        self.mass = mass
    }
}

// space vehicles' gravity field is too weak to be considered computatively useful
class SpaceVehicle: Body {
    
}

class CelestialBody: Body, BoundedByGravity {
    var orbiterDict = [String: Body]()
    var satellites: [Body] {
        return Array(orbiterDict.values)
    }
    
    func addSatellite(satellite: Body, orbit: Orbit) {
        orbiterDict[satellite.name] = satellite
        satellite.centralBody = self
    }
    
    subscript(name: String) -> Body? {
        if let target = orbiterDict[name] {
            return target
        }
        for satellite in satellites {
            guard let orbitable = satellite as? BoundedByGravity else {
                continue
            }
            if let target = orbitable[name] {
                return target
            }
        }
        return nil
    }
}

class Sun: CelestialBody {

}

class NonEmittingBody: CelestialBody {
    
}

class Planet: NonEmittingBody {
    
}

class Asteroid: NonEmittingBody {
    
}
