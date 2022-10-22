//
//  VaccinationDetailViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import Foundation

final class VaccinationDetailViewModel {
    let model: VaccinationCenter
    
    var centerName: VaccinationInformation {
        VaccinationInformation(imageName: "hospital.png", title: "센터명", description: model.centerName)
    }
    
    var facilityName: VaccinationInformation {
        VaccinationInformation(imageName: "building.png", title: "건물명", description: model.facilityName)
    }
    
    var phoneNumber: VaccinationInformation {
        VaccinationInformation(imageName: "telephone.png", title: "전화번호", description: model.phoneNumber)
    }
    
    var updatedAt: VaccinationInformation {
        VaccinationInformation(imageName: "chat.png", title: "업데이트 시간", description: model.updatedAt)
    }
    
    var address: VaccinationInformation {
        VaccinationInformation(imageName: "placeholder.png", title: "주소", description: model.address)
    }
    
    init(model: VaccinationCenter) {
        self.model = model
    }
}

struct VaccinationInformation {
    let imageName: String
    let title: String
    let description: String
}
