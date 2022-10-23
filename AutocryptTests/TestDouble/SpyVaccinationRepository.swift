//
//  SpyVaccinationRepository.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/24.
//

import XCTest
@testable import Autocrypt

import RxSwift

final class SpyVaccinationRepository: VaccinationRepositoryType {
    
    private var fetchVaccinationListCallCount: Int = 0
    var data: VaccinationCenterList
    
    init(data: VaccinationCenterList) {
        self.data = data
    }
    
    func fetchVaccinationList(page: String) -> Observable<VaccinationCenterList> {
        fetchVaccinationListCallCount += 1
        
        return Observable.just(data)
    }
    
    func verifyfetchVaccinationList(callCount: Int) {
        XCTAssertEqual(fetchVaccinationListCallCount, callCount)
    }
    

}

