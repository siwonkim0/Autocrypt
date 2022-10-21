//
//  EndpointGenerator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

struct EndpointGenerator {
    static func fetchVaccinationList(page: String) -> Endpoint<VaccinationCenterList> {
        return Endpoint(
            baseURL: "https://api.odcloud.kr/api",
            path: "/15077586/v1/centers",
            method: .get,
            queryParameters: VaccinationListRequestModel(page: page)
        )
    }
}
