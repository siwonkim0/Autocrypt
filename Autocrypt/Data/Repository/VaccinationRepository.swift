//
//  VaccinationRepository.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import RxSwift

protocol VaccinationRepositoryType {
    func fetchVaccinationList(page: String) -> Observable<VaccinationCenterList>
}

final class VaccinationRepository: VaccinationRepositoryType {
    
    private let networkProvider: NetworkProvidable
    
    init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    func fetchVaccinationList(page: String) -> Observable<VaccinationCenterList> {
        return networkProvider.request(with: EndpointGenerator.fetchVaccinationList(page: page))
    }
}
