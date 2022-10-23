//
//  VaccinationMapViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import CoreLocation
import RxSwift
import RxCocoa

final class VaccinationMapViewModel: NSObject, ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
        let currentLocationButtonTapped: Observable<Void>
        let vaccinationCenterLocationButtonTapped: Observable<Void>
    }
    
    struct Output {
        let currentLocationCoordinate: Observable<CLLocationCoordinate2D?>
        let vaccinationCenterLocationCoordinate: Observable<CLLocationCoordinate2D?>
    }
    
    // MARK: - State
    private var currentLocationCoordinate = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    private var vaccinationCenterLocationCoordinate = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let model: VaccinationCenter
    private let locationManager = CLLocationManager()
    
    init(model: VaccinationCenter) {
        self.model = model
        super.init()
        getUserLocationPermission()
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(with: self, onNext: { (self, _) in
                self.setVaccinationCenterLocationCoordinate()
            })
            .disposed(by: disposeBag)
        
        input.vaccinationCenterLocationButtonTapped
            .subscribe(with: self, onNext: { (self, _) in
                self.setVaccinationCenterLocationCoordinate()
            })
            .disposed(by: disposeBag)
        
        input.currentLocationButtonTapped
            .subscribe(with: self, onNext: { (self, _) in
                self.currentLocationCoordinate.accept(self.locationManager.location?.coordinate)
            })
            .disposed(by: disposeBag)
        
        return Output(
            currentLocationCoordinate: currentLocationCoordinate.asObservable(),
            vaccinationCenterLocationCoordinate: vaccinationCenterLocationCoordinate.asObservable()
        )
    }
    
    private func setVaccinationCenterLocationCoordinate() {
        let latitude = Double(self.model.latitude) ?? 0
        let longitude = Double(self.model.longitude) ?? 0
        self.vaccinationCenterLocationCoordinate.accept(.init(latitude: latitude, longitude: longitude))
    }
    
    private func getUserLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
}

//MARK: - CoreLocationManager Delegate

extension VaccinationMapViewModel: CLLocationManagerDelegate {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
}

struct VaccinationCenterLocation {
    let latitute: Double
    let longitude: Double
}
