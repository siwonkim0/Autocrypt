//
//  VaccinationListViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import RxSwift
import RxCocoa

final class VaccinationListViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let loadNextPage: Observable<Void>
        let scrollToTopButtonTapped: Observable<Void> //맨 처음 셀로 이동하는 동시에 결과도 1페이지로 초기화하기
    }
    
    struct Output {
        let result: Observable<[VaccinationCenter]>
    }
    
    private let repository: VaccinationRepositoryType
    
    // MARK: - State
    private var nextPage: Int = 1
    private var results = BehaviorRelay<[VaccinationCenter]>(value: [])
    
    init(repository: VaccinationRepositoryType) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchPaginatedResult(page: 1)
            }
            .subscribe(onNext: { resultList in
                let data = resultList.data
                self.results.accept(data)
            })
            .disposed(by: disposeBag)
        
        input.loadNextPage
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap {
                self.fetchPaginatedResult(page: self.nextPage)
            }
            .subscribe(onNext: { resultList in
                self.nextPage = resultList.page + 1
                print(self.nextPage)
                let data = resultList.data
                var newResults = self.results.value
                newResults.append(contentsOf: data)
                self.results.accept(newResults)
            })
            .disposed(by: disposeBag)
        
        return Output(result: results.asObservable())
    }
    
    func fetchPaginatedResult(page: Int) -> Observable<VaccinationCenterList> {
        return repository.fetchVaccinationList(page: "\(page)")
    }
    
    
}
