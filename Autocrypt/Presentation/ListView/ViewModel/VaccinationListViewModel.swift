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
    
    // MARK: - State
    private var nextPage = BehaviorRelay<Int?>(value: 1)
    private var results = BehaviorRelay<[VaccinationCenter]>(value: [])
    private var isRefreshing = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    private let repository: VaccinationRepositoryType
    
    init(repository: VaccinationRepositoryType) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .take(1)
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
                self.updateNextPageState(to: resultList.page)
                self.updateSortedResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        input.refresh
            .withUnretained(self)
            .flatMap { (self, _) -> Observable<VaccinationCenterList> in
                self.updateRefreshState(to: true)
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
    
    private func updateSortedResults(with data: [VaccinationCenter]) {
        if data.count < 10 {
            updateNextPageState(to: nil)
        }
        if isRefreshing.value {
            updateNextPageState(to: 1)
            updateResultState(to: [])
        }
        var newResults = self.results.value
        newResults.append(contentsOf: data)
        newResults.sort {
            $0.updatedAt > $1.updatedAt
        }
        updateResultState(to: newResults)
        updateRefreshState(to: false)
    }
    
    private func updateNextPageState(to page: Int?) {
        guard let page = page else {
            nextPage.accept(nil)
            return
        }
        nextPage.accept(page + 1)
    }
    
    private func updateResultState(to data: [VaccinationCenter]) {
        results.accept(data)
    }
    
    private func updateRefreshState(to state: Bool) {
        isRefreshing.accept(state)
    }
    
}
