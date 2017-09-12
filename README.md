![Header image](https://github.com/DJBen/Graviton/raw/master/External%20Assets/G-Purple.png)

# Graviton :milky_way:

[![Language](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat)](https://swift.org)
[![Build Status](https://travis-ci.com/DJBen/Graviton.svg?token=1KVrf6xTWoPqLKJBPuJ1&branch=master)](https://travis-ci.com/DJBen/Graviton)
[![codebeat badge](https://codebeat.co/badges/de61d36c-440a-4cc7-85cf-97379e08ef15)](https://codebeat.co/a/sihao-lu/projects/github-com-djben-graviton-master?maxAge=3600)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

- _Real-time night sky and solar system rendering._
- _Astronomy and celestial mechanics toolkit._
- _Native Apple technologies with Swift 3 and SceneKit._
----
## App
- [x] Real-time night sky rendering. Fully customizable. Totally hackable.
  - [x] Reading from GPS or inputing custom position to see a night sky in your location.
  - [x] Time warp - see what night sky is like at any time.
- [x] Real-time high accuracy solar system illustration. In scale.
- [x] Detailed celestial body information. Rise, transit and set information panel for :sunny:, :first_quarter_moon_with_face: and naked-eye planets.

## Getting Started
__Installation is verified to work with Xcode 8.3.3. Xcode 9 Beta version is not tested.__

### Prerequisites

#### Git LFS

This project requires [Git LFS](https://git-lfs.github.com) with version greater than `2.2.0` installed to better manage its binary files. To check your version, run the following:

```bash
$ git lfs version
```

You should see something like below
```bash
git-lfs/2.2.1 (GitHub; darwin amd64; go 1.8.3)
```

If not, you need to install it. Simply follow the [Git LFS](https://git-lfs.github.com) link to install.

#### Carthage
This app uses [Carthage](https://github.com/Carthage/Carthage) as its dependency manager. Make sure you have installed it before bootstrapping.


### Bootstrapping

```bash
carthage update --platform ios
```
That's all you need for bootstrapping! Now you can proceed to open the Xcode project file.

## Documentation
*Placeholder*

## Frameworks
__Unless marked internal, all frameworks are available for standalone use.__
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
