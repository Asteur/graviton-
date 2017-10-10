//
//  RiseTransitSetElevation.swift
//  Graviton
//
//  Created by Sihao Lu on 5/7/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import SpaceTime
import MathUtil
import RealmSwift
import CoreLocation
import GeoQueries

/// This structure embeds the rise-transit-set info along with
/// maximum elevation in a sliding window that spans a day
public struct RiseTransitSetElevation: Equatable {

    public let naif: Naif
    public let location: CLLocation

    public let startJd: JulianDate
    public let endJd: JulianDate

    /// Maximum elevation in radians
    public let maximumElevation: Double?
    public let riseAt: JulianDate?
    public let transitAt: JulianDate?
    public let setAt: JulianDate?

    init?(rts: [RiseTransitSetInfo], startJd: JulianDate, endJd: JulianDate) {
        self.startJd = startJd
        self.endJd = endJd
        let r = rts.first { $0.rts == .rise }
        let t = rts.first { $0.rts == .transit }
        let s = rts.first { $0.rts == .set }
        if r == nil && t == nil && s == nil {
            return nil
        }
        let obj = (r ?? t ?? s)!
        naif = Naif(naifId: obj.naifId)
        if let elev = t?.elevation {
            maximumElevation = radians(degrees: elev)
        } else {
            maximumElevation = nil
        }
        riseAt = r?.julianDate
        transitAt = t?.julianDate
        setAt = s?.julianDate
        location = obj.location
    }

    public static func ==(lhs: RiseTransitSetElevation, rhs: RiseTransitSetElevation) -> Bool {
        return lhs.naif == rhs.naif && lhs.location == rhs.location && lhs.startJd == rhs.startJd && lhs.endJd == rhs.endJd && lhs.maximumElevation == rhs.maximumElevation && lhs.riseAt == rhs.riseAt && lhs.transitAt == rhs.transitAt && lhs.setAt == rhs.setAt
    }
}

extension RiseTransitSetElevation: ObserverLoadable {

    /// Load the rise-transit-set info that is on the requested Julian date.
    ///
    /// - Parameters:
    ///   - naifId: Naif ID of the target body
    ///   - julianDate: The requested Julian date
    ///   - site: The observer site
    ///   - timeZone: The observer site's time zone
    /// - Returns: A rise-transit-set info record within the same day of requested Julian date
    static func load(naifId: Int, optimalJulianDate julianDate: JulianDate = JulianDate.now, site: ObserverSite, timeZone: TimeZone) -> RiseTransitSetElevation? {
        let realm = try! Realm()
        let deltaT = Double(timeZone.secondsFromGMT()) / 86400
        let startJd = modf(julianDate.value).0 + deltaT
        let endJd = modf(julianDate.value).0 + 1 + deltaT
        let results = realm.objects(RiseTransitSetInfo.self).filter("naifId == %@ AND jd BETWEEN {%@, %@}", naifId, startJd, endJd).filterGeoRadius(center: site.location.coordinate, radius: ObserverInfo.distanceTolerance, sortAscending: false)
        return RiseTransitSetElevation(rts: Array(results), startJd: JulianDate(startJd), endJd: JulianDate(endJd))
    }
}
