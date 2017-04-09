//
//  DBHelperTest.swift
//  Graviton
//
//  Created by Sihao Lu on 1/18/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
@testable import Orbits
import SpaceTime

class DBHelperTest: XCTestCase {
    
    var helper: DBHelper!
    
    override func setUp() {
        super.setUp()
        helper = TransientDBHelper.setupDatabaseHelper()
    }
    
    func testCelestialBodyStorage() {
        let body = CelestialBody(naifId: 12345, name: "Test", gravParam: 1.1, radius: 2.2, rotationPeriod: 3.3, obliquity: 4.4, centerBodyNaifId: 10, hillSphereRadRp: 5.5)
        helper.saveCelestialBody(body, shouldSaveMotion: false)
        let loaded = helper.loadCelestialBody(withNaifId: 12345)
        XCTAssertNotNil(loaded)
        deepEqual(loaded!, body)
        
        let known = CelestialBody(naifId: 399, gravParam: 828, radius: 2344.3, rotationPeriod: 12.3, obliquity: 4111.4, centerBodyNaifId: 10, hillSphereRadRp: 590.3773)
        helper.saveCelestialBody(known, shouldSaveMotion: false)
        let loaded2 = helper.loadCelestialBody(withNaifId: 399)
        XCTAssertNotNil(loaded2)
        XCTAssertEqual(loaded2?.name, "Earth")
        deepEqual(loaded2!, known)
    }
    
    func testMomentStorage() {
        let o1 = Orbit(semimajorAxis: 23.2, eccentricity: 43.4, inclination: 45.6, longitudeOfAscendingNode: 73.8, argumentOfPeriapsis: 19.0)
        let o2 = Orbit(semimajorAxis: 24.2, eccentricity: 43.4, inclination: 45.6, longitudeOfAscendingNode: 73.8, argumentOfPeriapsis: 19.0)
        let o3 = Orbit(semimajorAxis: 25.2, eccentricity: 43.4, inclination: 45.6, longitudeOfAscendingNode: 73.8, argumentOfPeriapsis: 19.0)
        let motion1 = OrbitalMotionMoment(orbit: o1, gm: 10, julianDate: JulianDate.J2000.value + 100, timeOfPeriapsisPassage: JulianDate.J2000.value + 1)
        let motion2 = OrbitalMotionMoment(orbit: o2, gm: 11, julianDate: JulianDate.J2000.value + 200, timeOfPeriapsisPassage: JulianDate.J2000.value + 2)
        let motion3 = OrbitalMotionMoment(orbit: o3, gm: 12, julianDate: JulianDate.J2000.value + 300, timeOfPeriapsisPassage: JulianDate.J2000.value + 3)
        helper.saveOrbitalMotionMoment(motion1, forBodyId: 899)
        helper.saveOrbitalMotionMoment(motion2, forBodyId: 899)
        helper.saveOrbitalMotionMoment(motion3, forBodyId: 899)
        let loaded899 = helper.loadOrbitalMotionMoment(bodyId: 899, optimalJulianDate: JulianDate.J2000.value + 240)
        XCTAssertNotNil(loaded899)
        deepEqual(loaded899!.orbit, o2)
        XCTAssertEqual(loaded899!.gm, 11e9)
        XCTAssertEqual(loaded899!.timeOfPeriapsisPassage, JulianDate.J2000.value + 2)
        XCTAssertEqual(loaded899!.ephemerisJulianDate, JulianDate.J2000.value + 200)
    }
    
    private func deepEqual(_ c1: CelestialBody, _ c2: CelestialBody) {
        XCTAssertEqual(c1.naifId, c2.naifId)
        XCTAssertEqual(c1.gravParam, c2.gravParam)
        XCTAssertEqual(c1.radius, c2.radius)
        XCTAssertEqual(c1.rotationPeriod, c2.rotationPeriod)
        XCTAssertEqual(c1.obliquity, c2.obliquity)
        XCTAssertEqual(c1.centerBody, c2.centerBody)
    }
    
    private func deepEqual(_ o1: OrbitalMotion, _ o2: OrbitalMotion) {
        if o1 is OrbitalMotionMoment && !(o2 is OrbitalMotionMoment) {
            XCTFail()
        } else if o2 is OrbitalMotionMoment && !(o1 is OrbitalMotionMoment) {
            XCTFail()
        }
        deepEqual(o1.orbit, o2.orbit)
        XCTAssertEqual(o1.gm, o2.gm)
        XCTAssertEqual(o1.julianDate, o2.julianDate)
    }
    
    private func deepEqual(_ or1: Orbit, _ or2: Orbit) {
        let (ls, rs) = (or1.shape, or2.shape)
        let (lo, ro) = (or1.orientation, or2.orientation)
        XCTAssertEqual(ls.semimajorAxis, rs.semimajorAxis)
        XCTAssertEqual(ls.eccentricity, rs.eccentricity)
        XCTAssertEqual(lo.argumentOfPeriapsis, ro.argumentOfPeriapsis)
        XCTAssertEqual(lo.inclination, ro.inclination)
        XCTAssertEqual(lo.longitudeOfAscendingNode, ro.longitudeOfAscendingNode)
    }
}
