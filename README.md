![Header image](https://github.com/DJBen/Graviton/raw/master/External%20Assets/G-Purple.png)

# Graviton :milky_way:

[![Language](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org)
[![Build Status](https://travis-ci.com/DJBen/Graviton.svg?token=1KVrf6xTWoPqLKJBPuJ1&branch=master)](https://travis-ci.com/DJBen/Graviton)
[![codebeat badge](https://codebeat.co/badges/de61d36c-440a-4cc7-85cf-97379e08ef15)](https://codebeat.co/a/sihao-lu/projects/github-com-djben-graviton-master?maxAge=3600)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

- _Real-time night sky and solar system rendering._
- _Astronomy and celestial mechanics toolkit._
- _Native Apple technologies with Swift 4 and SceneKit._
----
## App
- [x] Real-time night sky rendering. Fully customizable. Totally hackable.
  - [x] Reading from GPS or inputing custom position to see a night sky in your location.
  - [x] Time warp - see what night sky is like at any time.
- [x] Real-time high accuracy solar system illustration. In scale.
- [x] Detailed celestial body information. Rise, transit and set information panel for :sunny:, :first_quarter_moon_with_face: and naked-eye planets.

## Getting Started

### Prerequisites

[Xcode 9](https://developer.apple.com/xcode/) (9A235) toolchain is required to compile and run the project.

### Installation

This app uses [Carthage](https://github.com/Carthage/Carthage) as its dependency manager. Make sure you have installed it before running the following command.

```bash
carthage update --platform ios
```
That's all you need for bootstrapping! Now you can proceed to open the Xcode project file.

**Important**: For best experience, please run with real device, especially so when testing against graphics related features.

#### Troubleshooting

If you experienced issues during installations and runtime, here are some workarounds.

1. Carthage update hangs indefinitely.

  *Probable cause*: `weebly/OrderedSet` dependency may have no shared scheme available.

  *Workaround*: run `carthage bootstrap --platform ios` instead of `carthage update`.

2. Xcode 9 simulator has very low performance and is unusable.

  *Cause*: Apple's bug. Refer to [Apple forum thread](https://forums.developer.apple.com/thread/83570) for more information.

  *Workaround*: Use real device, or [hack Xcode](https://twitter.com/stroughtonsmith/status/910203896332783616) to force it to use framework of an old version.

## Documentation
*Placeholder*

Two websites are planned to be built. One includes all documentation, the other is a shiny front page for maximum appeal.

## Frameworks
### Orbits
_High accuracy ephemeris query and orbital mechanics calculation framework._
- [x] Calculate [Keplarian](https://en.wikipedia.org/wiki/Kepler_orbit) orbital mechanics with support of all [conics](https://en.wikipedia.org/wiki/Conic_section).
- [x] Query and process high accuracy ephemeris from NASA JPL's [Horizon](http://ssd.jpl.nasa.gov/?horizons) interface and automatically cache results using [Realm](https://realm.io) and SQLite.
- [x] Excellent offline mode. Stock ephemeris from 1500 AD to 3000 AD of major celestial bodies.
- [x] Support querying rise, transit and set timestamps for major celestial bodies.

> Conics model predicts the orbits of the major planets in our solar system pretty accurately. To account for [apsidal precession](https://en.wikipedia.org/wiki/Apsidal_precession) and other orbital perturbations of celestial bodies like Mercury and Earth's moon, Orbits fetches many data points from JPL and cherry-pick the orbital configuration closest to the reference time.

## Goals
This is an amateurish project by an amateur astronomer. As a lover of science and space exploration, there are a few long-term goals:

- A full-fledged open source stellarium software
- An educational astronomy app with science in mind
- (?) A space flight simulator that utilizes [patched conics approximation](https://en.wikipedia.org/wiki/Patched_conic_approximation).

## Copyright
This project is licensed under GPLv3.
If you have issues with any assets or resources in Graviton, please don't hesitate to reach out [DJBen](mailto:lsh32768@gmail.com). No copyright issue is too small.
