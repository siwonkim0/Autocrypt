//
//  VaccinationCenterList.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

struct VaccinationCenterList: Decodable {
    let data: [VaccinationCenter]
    let page: Int
    let currentCount: Int
    let totalCount: Int
}

struct VaccinationCenter: Decodable {
    let id: Int
    let centerName: String
    let facilityName: String
    let phoneNumber: String
    let updatedAt: String
    let address: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case id, centerName, facilityName, phoneNumber, updatedAt, address
        case latitude = "lat"
        case longitude = "lng"
    }
}
