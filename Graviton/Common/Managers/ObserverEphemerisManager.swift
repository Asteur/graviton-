//
//  ObserverEphemerisManager.swift
//  Graviton
//
//  Created by Sihao Lu on 5/14/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import UIKit
import Orbits
import SpaceTime
import CoreLocation

final class ObserverEphemerisManager: LocationSensitiveSubscriptionManager<[Naif: CelestialBodyObserverInfo]> {

    static var globalMode: Horizons.FetchMode = .preferLocal

    static let `default` = ObserverEphemerisManager()

    override func fetch(mode: Horizons.FetchMode? = nil, forJulianDate requestedJd: JulianDate) {
        if isFetching { return }
        isFetching = true
        let site = ObserverSite(naif: .majorBody(.earth), location: LocationManager.default.content ?? CLLocation())
        Horizons.shared.fetchCelestialBodyObserverInfo(preferredDate: requestedJd.date, observerSite: site, mode: mode ?? ObserverEphemerisManager.globalMode, update: { (dict) in
            self.content = dict
            for (_, sub) in self.subscriptions {
                DispatchQueue.main.async {
                    sub.didLoad!(dict)
                }
            }
        }, complete: { (_, _) in
            self.isFetching = false
        })
    }

    override func update(subscription: LocationSensitiveSubscriptionManager<[Naif: CelestialBodyObserverInfo]>.Subscription, forJulianDate requestedJd: JulianDate) {
        // no-op
    }
}
