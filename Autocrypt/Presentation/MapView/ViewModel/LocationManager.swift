//
//  LocationManager.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/24.
//

import Foundation
import CoreLocation

protocol LocationManagable {
    func getCurrentLocation() -> CLLocationCoordinate2D?
    func getUserLocationPermission()
}

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagable {
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return self.locationManager.location?.coordinate
    }
    
    func getUserLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - CoreLocationManager Delegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .authorized:
            print("GPS 권한 설정됨")
        case .notDetermined, .restricted:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 거부됨")
        default:
            print("GPS: Default")
        }
    }
}
