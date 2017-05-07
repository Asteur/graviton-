//
//  RiseTransitSetRealmTest.swift
//  Graviton
//
//  Created by Sihao Lu on 5/7/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
import RealmSwift
import MathUtil
@testable import Orbits

class RiseTransitSetRealmTest: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()

        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realm = try! Realm()
    }
    
    func testRTSSearching() {
        try! realm.write {
            realm.add([
                RiseTransitSetInfo(naifId: 301, jd: 10000, daylightFlag: "*", rtsFlag: "r", azimuth: 10, elevation: 20),
                RiseTransitSetInfo(naifId: 301, jd: 10000.2, daylightFlag: "", rtsFlag: "t", azimuth: 11, elevation: 21),
                RiseTransitSetInfo(naifId: 301, jd: 10000.7, daylightFlag: "C", rtsFlag: "s", azimuth: 12, elevation: 22),
                RiseTransitSetInfo(naifId: 301, jd: 10001.1, daylightFlag: "N", rtsFlag: "r", azimuth: 13, elevation: 23),
                RiseTransitSetInfo(naifId: 301, jd: 10001.3, daylightFlag: "A", rtsFlag: "t", azimuth: 14, elevation: 24),
                RiseTransitSetInfo(naifId: 301, jd: 10001.9, daylightFlag: "", rtsFlag: "s", azimuth: 15, elevation: 25),
                RiseTransitSetInfo(naifId: 301, jd: 20000.1, daylightFlag: "", rtsFlag: "r", azimuth: 15, elevation: 25),
                RiseTransitSetInfo(naifId: 301, jd: 20000.9, daylightFlag: "", rtsFlag: "t", azimuth: 15, elevation: 25),
                RiseTransitSetInfo(naifId: 301, jd: 20005.1, daylightFlag: "", rtsFlag: "s", azimuth: 15, elevation: 25),
                RiseTransitSetInfo(naifId: 301, jd: 29999.6, daylightFlag: "", rtsFlag: "r", azimuth: 4, elevation: 1),
                RiseTransitSetInfo(naifId: 301, jd: 30000.1, daylightFlag: "", rtsFlag: "t", azimuth: 5, elevation: 2),
                RiseTransitSetInfo(naifId: 301, jd: 30000.3, daylightFlag: "", rtsFlag: "s", azimuth: 6, elevation: 3),
            ])
        }
        let rtse = RiseTransitSetElevation.load(naifId: 301, optimalJulianDate: 10000.3, timeZone: TimeZone(secondsFromGMT: 0)!)
        XCTAssertNotNil(rtse)
        XCTAssertEqual(rtse!.riseAt, 10000.0)
        XCTAssertEqual(rtse!.transitAt, 10000.2)
        XCTAssertEqual(rtse!.setAt, 10000.7)
        XCTAssertEqual(rtse!.maximumElevation, radians(degrees: 21))
        XCTAssertNotNil(RiseTransitSetElevation.load(naifId: 301, optimalJulianDate: 10001.99, timeZone: TimeZone(secondsFromGMT: 0)!))
        let rt2 = RiseTransitSetElevation.load(naifId: 301, optimalJulianDate: 30000.0, timeZone: TimeZone(secondsFromGMT: -86400/2)!)
        XCTAssertNotNil(rt2)
        XCTAssertEqual(rt2!.riseAt, 29999.6)
        XCTAssertEqual(rt2!.transitAt, 30000.1)
        XCTAssertEqual(rt2!.setAt, 30000.3)
        XCTAssertEqual(rt2!.maximumElevation, radians(degrees: 2))

    }

}
