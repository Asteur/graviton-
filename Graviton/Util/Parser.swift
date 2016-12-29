//
//  EphemerisParser.swift
//  Horizons
//
//  Created by Ben Lu on 10/4/16.
//
//

import Foundation
import Orbits

public struct ResponseValidator {
    public enum Result {
        case ok(String)
        case busy
    }
    
    public static func parse(content: String) -> Result {
        if content.contains("Blocked Concurrent Request") {
            return .busy
        } else {
            return .ok(content)
        }
    }
}

// Range 1
//        Revised: Sep 28, 2012                 Mars                             499 / 4
//
//        GEOPHYSICAL DATA (updated 2009-May-26):
//        Mean radius (km)      = 3389.9(2+-4)    Density (g cm^-3)     =  3.933(5+-4)
//        Mass (10^23 kg )      =    6.4185       Flattening, f         =  1/154.409
//        Volume (x10^10 km^3)  =   16.318        Semi-major axis       =  3397+-4
//        Sidereal rot. period  =   24.622962 hr  Rot. Rate (x10^5 s)   =  7.088218
//        Mean solar day        =    1.0274907 d  Polar gravity ms^-2   =  3.758
//        Mom. of Inertia       =    0.366        Equ. gravity  ms^-2   =  3.71
//        Core radius (km)      =  ~1700          Potential Love # k2   =  0.153 +-.017
//
//        Grav spectral fact u  =   14 (x10^5)    Topo. spectral fact t = 96 (x10^5)
//        Fig. offset (Rcf-Rcm) = 2.50+-0.07 km   Offset (lat./long.)   = 62d / 88d
//        GM (km^3 s^-2)        = 42828.3         Equatorial Radius, Re = 3394.0 km
//        GM 1-sigma (km^3 s^-2)= +- 0.1          Mass ratio (Sun/Mars) = 3098708+-9
//
//        Atmos. pressure (bar) =    0.0056       Max. angular diam.    =  17.9"
//        Mean Temperature (K)  =  210            Visual mag. V(1,0)    =  -1.52
//        Geometric albedo      =    0.150        Obliquity to orbit    =  25.19 deg
//        Mean sidereal orb per =    1.88081578 y Orbit vel.  km/s      =  24.1309
//        Mean sidereal orb per =  686.98 d       Escape vel. km/s      =   5.027
//        Hill's sphere rad. Rp =  319.8          Mag. mom (gauss Rp^3) = < 1x10^-4
// Range 2
//        Target body name: Mars (499)                      {source: mar097}
//        Center body name: Sun (10)                        {source: mar097}
//        Center-site name: BODY CENTER
// Range 3
//        Start time      : A.D. 2016-Dec-21 11:22:00.0000 TDB
//        Stop  time      : A.D. 2016-Dec-21 12:22:00.0000 TDB
//        Step-size       : 1 steps
// Range 4
//        Center geodetic : 0.00000000,0.00000000,0.0000000 {E-lon(deg),Lat(deg),Alt(km)}
//        Center cylindric: 0.00000000,0.00000000,0.0000000 {E-lon(deg),Dxy(km),Dz(km)}
//        Center radii    : 696000.0 x 696000.0 x 696000.0 k{Equator, meridian, pole}
//        System GM       : 1.3271248287031293E+11 km^3/s^2
//        Output units    : KM-S, deg, Julian Day Number (Tp)
//        Output type     : GEOMETRIC osculating elements
//        Output format   : 10
//        Reference frame : ICRF/J2000.0
//        Coordinate systm: Ecliptic and Mean Equinox of Reference Epoch

public struct ResponseParser {
    // parse range 1
    static func parseBodyInfo(_ content: String) -> [(String, String)] {
//        let commentRegex = "^\\s*(.*):$"
        let physicalDataRegex = "\\*+([^\\*]+)\\*+\\s*\\*+\\s*Ephemeris[^\\*]+\\*+([^\\*]+)\\*+([^\\*]+)\\*+([^\\*]+)\\*+"
        let planetDataMatched = content.matches(for: physicalDataRegex)[0]
        let info = planetDataMatched[1]
        return info.components(separatedBy: "\n").flatMap { (line) -> [(String, String)]? in
            guard let result = parseDoubleColumn(line) else {
                return nil
            }
            if let col2 = result.1 {
                return [result.0, col2]
            } else {
                return [result.0]
            }
        }.reduce([], +)
        
    }
    
    // parse range 1 - subroutine
    private static func parseDoubleColumn(_ line: String) -> ((String, String), (String, String)?)? {
        let lineRegex = "^\\s*(.{40})(.+)$"
        let propertyRegex = "(.+)\\s*=\\s*(.{5,24})"
        let matched = line.matches(for: lineRegex)
        guard matched.count == 1 else {
            let singleProp = line.matches(for: propertyRegex)
            guard singleProp.isEmpty == false else {
                return nil
            }
            return ((singleProp[0][1], singleProp[0][2]), nil)
        }
        let m = matched[0]
        guard m.count == 3 else { return nil }
        
        func parseProperty(_ propLine: String) -> (String, String)? {
            let props = propLine.matches(for: propertyRegex)
            guard props.isEmpty == false else {
                return nil
            }
            let p = props[0]
            return (p[1].trimmed(), p[2].trimmed())
        }
        if let firstProperty = parseProperty(m[1]) {
            return (firstProperty, parseProperty(m[2]))
        } else {
            return nil
        }
    }
    
    // parse range 2, 3 and 4
    static func parseLineBasedContent(_ content: String) -> [(String, String, String?)] {
        let physicalDataRegex = "\\*+([^\\*]+)\\*+\\s*\\*+\\s*Ephemeris[^\\*]+\\*+([^\\*]+)\\*+([^\\*]+)\\*+([^\\*]+)\\*+"
        let planetDataMatched = content.matches(for: physicalDataRegex)[0]
        let info = (2...4).map { planetDataMatched[$0] }.joined(separator: "\n").components(separatedBy: "\n")
        let regex = "^([^:]+):\\s([^\\{]+)(\\{[^\\}]+\\})?$"
        return info.map { (i) -> [(String, String, String?)] in
            return i.matches(for: regex).flatMap { (matches) -> (String, String, String?)? in
                guard matches.count == 4 else {
                    return nil
                }
                let m = matches.map { $0.trimmed() }
                return (m[1], m[2], m[3].isEmpty ? nil : m[3])
            }
        }.reduce([], +)
    }
    
    public static func parseEphemeris(content: String) -> OrbitalMotion? {
        let ephemerisRegex = "\\$\\$SOE\\s*(([^,]*,\\s*)*)\\s*\\$\\$EOE"
        let matched = content.matches(for: ephemerisRegex)[0][1]
        return EphemerisParser.parse(csv: matched)
    }
}

func dict<T: Hashable>(_ tuple: [(T, T)]) -> [T: T] {
    var map: [T: T] = [:]
    tuple.forEach { map[$0.0] = $0.1 }
    return map
}

func dropLast<T>(_ tuple: (T, T, T?)) -> (T, T) {
    return (tuple.0, tuple.1)
}

fileprivate extension String {
    func matches(for regex: String) -> [[String]] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            guard results.count > 0 else {
                return []
            }
            return results.map { (result) -> [String] in
                return (0..<result.numberOfRanges).map { (index) -> String in
                    guard result.rangeAt(index).length > 0 else {
                        return String()
                    }
                    return (self as NSString).substring(with: result.rangeAt(index))
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
