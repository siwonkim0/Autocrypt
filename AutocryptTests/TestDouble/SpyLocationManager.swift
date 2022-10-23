//
//  SpyLocationManager.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/24.
//

import Foundation
import CoreLocation

import XCTest
@testable import Autocrypt

final class SpyLocationManager: LocationManagable {
    
    private var getCurrentLocationCallCount: Int = 0
    private var getUserLocationPermissionCallCount: Int = 0
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        getCurrentLocationCallCount += 1
        return CLLocationCoordinate2D(latitude: 37.567817, longitude: 127.00450)
    }
    
    func getUserLocationPermission() {
        getUserLocationPermissionCallCount += 1
    }
    
    func verifyGetCurrentLocation(callCount: Int) {
        XCTAssertEqual(getCurrentLocationCallCount, callCount)
    }
    
    func verifyGetUserLocationPermission(callCount: Int) {
        XCTAssertEqual(getUserLocationPermissionCallCount, callCount)
    }
    
}
