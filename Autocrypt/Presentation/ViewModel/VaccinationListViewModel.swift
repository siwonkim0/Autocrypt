//
//  VaccinationListViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import RxSwift
import RxCocoa

final class VaccinationListViewModel: ViewModelType {

    struct Input {
        let viewWillAppear: Observable<Void>
        let loadNextPage: Observable<Void>
        let scrollToTop: Observable<Void> //맨 처음 셀로 이동하는 동시에 결과도 1페이지로 초기화하기
    }
    
    struct Output {
        let initialResult: Observable<[VaccinationCenter]>
//        let nextPageResult: Driver<[VaccinationCenter]>
    }
    
    private let repository: VaccinationRepositoryType
    
    // MARK: - State
    private var nextPage: Int?
    private var results: [VaccinationCenter]?
    
    init(repository: VaccinationRepositoryType) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        let initialResult = input.viewWillAppear
            .flatMap {
                self.fetchPaginatedResult(page: 1)
                    .map {
                        $0.data
                    }
            
            }
//            .asDriver(onErrorJustReturn: [])
        
        return Output(initialResult: initialResult)
    }
    
    func fetchPaginatedResult(page: Int) -> Observable<VaccinationCenterList> {
        return repository.fetchVaccinationList(page: "\(page)")
    }
    
    
}
