//
//  ObserverSite.swift
//  Graviton
//
//  Created by Ben Lu on 5/5/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import CoreLocation

public struct ObserverSite {
    public let naif: Naif
    public let location: CLLocation

    public init(naif: Naif, location: CLLocation) {
        self.naif = naif
        self.location = location
    }
}
