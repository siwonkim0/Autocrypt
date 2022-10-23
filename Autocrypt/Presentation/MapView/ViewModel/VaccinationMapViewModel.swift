//
//  VaccinationMapViewModel.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import Foundation

final class VaccinationMapViewModel {
    let model: VaccinationCenter
    
    init(model: VaccinationCenter) {
        self.model = model
    }
    
}

struct VaccinationCenterLocation {
    let latitute: Double
    let longitude: Double
}
