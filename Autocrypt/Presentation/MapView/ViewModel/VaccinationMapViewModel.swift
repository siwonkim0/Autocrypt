//
//  VaccinationMapViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import CoreLocation
import RxSwift
import RxCocoa

final class VaccinationMapViewModel: ViewModelType {
    
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
    private let locationManager: LocationManagable
    
    init(model: VaccinationCenter, locationManager: LocationManagable) {
        self.model = model
        self.locationManager = locationManager
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(with: self, onNext: { (self, _) in
                self.locationManager.getUserLocationPermission()
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
                self.currentLocationCoordinate.accept(self.locationManager.getCurrentLocation())
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
    
}

