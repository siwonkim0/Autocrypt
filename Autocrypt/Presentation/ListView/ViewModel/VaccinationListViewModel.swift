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
        let refresh: Observable<Void>
    }
    
    struct Output {
        let result: Observable<[VaccinationCenter]>
        let canFetchNextPage: Observable<Int?>
        let refreshDone: Observable<Bool>
    }
    
    private let disposeBag = DisposeBag()
    private let repository: VaccinationRepositoryType
    
    // MARK: - State
    private var nextPage = BehaviorRelay<Int?>(value: 1)
    private var results = BehaviorRelay<[VaccinationCenter]>(value: [])
    private var isRefreshing = BehaviorRelay<Bool>(value: false)
    
    init(repository: VaccinationRepositoryType) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear 
            .withUnretained(self)
            .flatMap { (self, _) in
                self.fetchPaginatedResults(page: 1)
            }
            .subscribe(with: self, onNext: { (self, resultList) in
                self.updateSortedResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        input.loadNextPage
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { (self, _) -> Observable<VaccinationCenterList> in
                guard let nextPage = self.nextPage.value else {
                    return .empty()
                }
                return self.fetchPaginatedResults(page: nextPage)
            }
            .subscribe(with: self, onNext: { (self, resultList) in
                self.updateNextPage(with: resultList.page)
                self.updateSortedResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        input.refresh
            .withUnretained(self)
            .flatMap { (self, _) -> Observable<VaccinationCenterList> in
                self.isRefreshing.accept(true)
                return self.fetchPaginatedResults(page: 1)
            }
            .subscribe(with: self, onNext: { (self, resultList) in
                self.updateSortedResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        return Output(
            result: results.asObservable(),
            canFetchNextPage: nextPage.asObservable(),
            refreshDone: isRefreshing.asObservable()
        )
    }
    
    private func fetchPaginatedResults(page: Int) -> Observable<VaccinationCenterList> {
        return repository.fetchVaccinationList(page: "\(page)")
    }
    
    private func updateNextPage(with page: Int) {
        self.nextPage.accept(page + 1)
    }
    
    private func updateSortedResults(with data: [VaccinationCenter]) {
        if data.count < 10 {
            self.nextPage.accept(nil)
        }
        if isRefreshing.value {
            nextPage.accept(1)
            results.accept([])
        }
        var newResults = self.results.value
        newResults.append(contentsOf: data)
        newResults.sort {
            $0.updatedAt > $1.updatedAt
        }
        self.results.accept(newResults)
        self.isRefreshing.accept(false)
    }
    
    
}
