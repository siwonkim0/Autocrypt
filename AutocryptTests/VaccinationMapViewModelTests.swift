//
//  VaccinationMapViewModelTests.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/24.
//

import XCTest
@testable import Autocrypt

import RxSwift

class VaccinationMapViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var model: VaccinationCenter!
    private var locationManager: SpyLocationManager!
    private var viewModel: VaccinationMapViewModel!
    private var output: VaccinationMapViewModel.Output!
    private var viewWillAppearSubject: PublishSubject<Void>!
    private var currentLocationButtonTappedSubject: PublishSubject<Void>!
    private var vaccinationCenterLocationButtonTappedSubject: PublishSubject<Void>!

    override func setUp() {
        disposeBag = DisposeBag()
        viewWillAppearSubject = PublishSubject<Void>()
        currentLocationButtonTappedSubject = PublishSubject<Void>()
        vaccinationCenterLocationButtonTappedSubject = PublishSubject<Void>()
        
        model = VaccinationCenter(
            id: 1,
            centerName: "",
            facilityName: "",
            phoneNumber: "",
            updatedAt: "",
            address: "",
            latitude: "35.139465",
            longitude: "126.925563"
        )
        locationManager = SpyLocationManager()
        viewModel = VaccinationMapViewModel(model: model, locationManager: locationManager)
        
        output = viewModel.transform(.init(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            currentLocationButtonTapped: currentLocationButtonTappedSubject.asObservable(),
            vaccinationCenterLocationButtonTapped: vaccinationCenterLocationButtonTappedSubject.asObservable()
        ))
    }
    
    func test_viewWillAppear_시점에_접종센터_위치를_설정해야한다() {
        viewWillAppearSubject.onNext(())
        output.vaccinationCenterLocationCoordinate
            .subscribe(onNext: { coordinate in
                XCTAssertEqual(coordinate?.latitude, 35.139465)
                self.locationManager.verifyGetUserLocationPermission(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_접종센터로_버튼_이벤트가_발생하면_접종센터_위치를_설정해야한다() {
        vaccinationCenterLocationButtonTappedSubject.onNext(())
        output.vaccinationCenterLocationCoordinate
            .subscribe(onNext: { coordinate in
                XCTAssertEqual(coordinate?.latitude, 35.139465)
            })
            .disposed(by: disposeBag)
    }
    
    func test_현재위치로_버튼_이벤트가_발생하면_현재위치를_설정해야한다() {
        currentLocationButtonTappedSubject.onNext(())
        output.currentLocationCoordinate
            .subscribe(onNext: { coordinate in
                XCTAssertEqual(coordinate?.latitude, 37.567817)
                self.locationManager.verifyGetCurrentLocation(callCount: 1)
            })
            .disposed(by: disposeBag)
    }

}
