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
    }
    
    struct Output {
        let result: Observable<[VaccinationCenter]>
        let canFetchNextPage: Observable<Int?>
    }
    
    let disposeBag = DisposeBag()
    private let repository: VaccinationRepositoryType
    
    // MARK: - State
    private var nextPage = BehaviorRelay<Int?>(value: 1)
    private var results = BehaviorRelay<[VaccinationCenter]>(value: [])
    
    init(repository: VaccinationRepositoryType) {
        self.repository = repository
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppear 
            .withUnretained(self)
            .flatMap { (self, _) in
                self.fetchPaginatedResult(page: 1)
            }
            .subscribe(with: self, onNext: { (self, resultList) in
                self.updateResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        input.loadNextPage
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { (self, _) -> Observable<VaccinationCenterList> in
                guard let nextPage = self.nextPage.value else {
                    return .empty()
                }
                return self.fetchPaginatedResult(page: nextPage)
            }
            .subscribe(with: self, onNext: { (self, resultList) in
                self.updateNextPage(with: resultList.page)
                self.updateResults(with: resultList.data)
            })
            .disposed(by: disposeBag)
        
        return Output(
            result: results.asObservable(),
            canFetchNextPage: nextPage.asObservable()
        )
    }
    
    private func fetchPaginatedResult(page: Int) -> Observable<VaccinationCenterList> {
        return repository.fetchVaccinationList(page: "\(page)")
    }
    
    private func updateNextPage(with page: Int) {
        self.nextPage.accept(page + 1)
    }
    
    private func updateResults(with data: [VaccinationCenter]) {
        if data.count < 10 {
            self.nextPage.accept(nil)
        }
        var newResults = self.results.value
        newResults.append(contentsOf: data)
        newResults.sort { 
            $0.updatedAt > $1.updatedAt
        }
        self.results.accept(newResults)
    }
    
    
}
