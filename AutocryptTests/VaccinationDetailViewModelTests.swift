//
//  VaccinationDetailViewModelTests.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/24.
//

import XCTest
@testable import Autocrypt

class VaccinationDetailViewModelTests: XCTestCase {
    
    private var model: VaccinationCenter!
    private var viewModel: VaccinationDetailViewModel!

    override func setUp() {
        model = VaccinationCenter(
            id: 1,
            centerName: "centerName",
            facilityName: "facilityName",
            phoneNumber: "phoneNumber",
            updatedAt: "updatedAt",
            address: "address",
            latitude: "latitude",
            longitude: "longitude"
        )
        viewModel = VaccinationDetailViewModel(model: model)
        
    }
    
    func test_centerName이_model의_centerName과_동일해야한다() {
        XCTAssertEqual(viewModel.centerName.description, model.centerName)
    }
    
    func test_facilityName이_model의_facilityName과_동일해야한다() {
        XCTAssertEqual(viewModel.facilityName.description, model.facilityName)
    }
    
    func test_phoneNumber가_model의_phoneNumber과_동일해야한다() {
        XCTAssertEqual(viewModel.phoneNumber.description, model.phoneNumber)
    }
    
    func test_updatedAt이_model의_updatedAt과_동일해야한다() {
        XCTAssertEqual(viewModel.updatedAt.description, model.updatedAt)
    }
    
    func test_address가_model의_address와_동일해야한다() {
        XCTAssertEqual(viewModel.address.description, model.address)
    }
    

}
