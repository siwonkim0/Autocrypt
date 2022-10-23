//
//  VaccinationListViewModelTests.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/24.
//

import XCTest
@testable import Autocrypt

import RxSwift

class VaccinationListViewModelTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    private var repository: SpyVaccinationRepository!
    private var viewModel: VaccinationListViewModel!
    private var output: VaccinationListViewModel.Output!
    private var viewWillAppearSubject: PublishSubject<Void>!
    private var loadNextPageSubject: PublishSubject<Void>!
    private var refreshSubject: PublishSubject<Void>!
    
    override func setUp() {
        disposeBag = DisposeBag()
        viewWillAppearSubject = PublishSubject<Void>()
        loadNextPageSubject = PublishSubject<Void>()
        refreshSubject = PublishSubject<Void>()
        repository = SpyVaccinationRepository(data: makeVaccinationCenterList(count: 10))
        viewModel = VaccinationListViewModel(repository: repository)
        
        output = viewModel.transform(.init(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            loadNextPage: loadNextPageSubject.asObservable(),
            refresh: refreshSubject.asObservable()
        ))
    }
    
    func test_viewWillAppear_시점에_첫번째_페이지_결과를_받아와야한다() {
        viewWillAppearSubject.onNext(())
        output.results
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0].centerName, "testCenter")
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_스크롤_이벤트가_발생하면_다음_페이지_결과를_받아와야한다() {
        loadNextPageSubject.onNext(())
        output.results
            .subscribe(onNext: { results in
                XCTAssertEqual(results[0].centerName, "testCenter")
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_스크롤_이벤트가_발생하면_nextPage에_1을_더해야한다() {
        loadNextPageSubject.onNext(())
        output.nextPage
            .subscribe(onNext: { page in
                XCTAssertEqual(page, 13)
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_스크롤_이벤트가_발생하여_받아온_결과가_10개미만이라면_nextPage는_nil이_되어야한다() {
        repository.data = makeVaccinationCenterList(count: 5)
        
        loadNextPageSubject.onNext(())
        output.nextPage
            .subscribe(onNext: { page in
                XCTAssertNil(page)
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_새로고침을_하면_nextPage는_1이_되어야한다() {
        refreshSubject.onNext(())
        output.nextPage
            .subscribe(onNext: { page in
                XCTAssertEqual(page, 2)
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_새로고침을_하면_결과가_첫번째_페이지_결과로_초기화되어야한다() {
        refreshSubject.onNext(())
        output.results
            .subscribe(onNext: { results in
                XCTAssertEqual(results.count, 10)
                self.repository.verifyfetchVaccinationList(callCount: 1)
            })
            .disposed(by: disposeBag)
    }

}

extension VaccinationListViewModelTests {
    func makeVaccinationCenterList(count: Int) -> VaccinationCenterList {
        let vaccinationCenters = (0..<count).map { index in
            VaccinationCenter(
            id: index,
            centerName: "testCenter",
            facilityName: "",
            phoneNumber: "",
            updatedAt: "",
            address: "",
            latitude: "",
            longitude: ""
            )
        }
        return VaccinationCenterList(
            data: vaccinationCenters,
            page: 12,
            currentCount: 10,
            totalCount: 122
        )
    }
}
