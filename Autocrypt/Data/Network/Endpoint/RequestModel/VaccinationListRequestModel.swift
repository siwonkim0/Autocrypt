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
    let serviceKey: String = "LQyknYzGt2cE6Uk%2F6%2FwGr97siPY23WBCkNVCy2IAll2s5mRhjaIthTIMOY73lhi9JelUrsFBIABPa5DHhGL9uQ%3D%3D"
}
