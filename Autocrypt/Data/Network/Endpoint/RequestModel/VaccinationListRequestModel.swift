//
//  VaccinationListRequestModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

struct VaccinationListRequestModel: Encodable {
    let page: String
    let perPage: String = "10"
    let serviceKey: String = Storage().serviceKey
}
