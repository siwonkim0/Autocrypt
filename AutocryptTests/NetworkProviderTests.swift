//
//  NetworkProviderTests.swift
//  NetworkProviderTests
//
//  Created by Siwon Kim on 2022/10/21.
//

import XCTest
@testable import Autocrypt

class NetworkProviderTests: XCTestCase {
    
    var sut: NetworkProvider!
    var stubURLSession: StubURLSession!
    
    func test_API호출_성공시_정상적으로_data가_디코딩되어야한다() {
        stubURLSession = StubURLSession()
        sut = NetworkProvider(session: stubURLSession)
        
        let expectation = XCTestExpectation()

        let endpoint = EndpointGenerator.fetchVaccinationList(page: "1")
        let stubResponse = try! JSONDecoder().decode(VaccinationCenterList.self, from: endpoint.testData!)

        sut.request(with: endpoint) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.data[0].centerName, stubResponse.data[0].centerName)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_status코드가_정상범위가_아닐때_에러메세지가_나와야한다() {
        stubURLSession = StubURLSession(responseState: .invalidStatusCode)
        sut = NetworkProvider(session: stubURLSession)
        
        let expectation = XCTestExpectation()
        let endpoint = EndpointGenerator.fetchVaccinationList(page: "1")

        sut.request(with: endpoint) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Status 코드가 정상범위가 아닙니다. 400")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_data가_없을때_에러메세지가_나와야한다() {
        stubURLSession = StubURLSession(responseState: .invalidData)
        sut = NetworkProvider(session: stubURLSession)
        
        let expectation = XCTestExpectation()
        let endpoint = EndpointGenerator.fetchVaccinationList(page: "1")

        sut.request(with: endpoint) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "유효한 데이터가 아닙니다")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

}
