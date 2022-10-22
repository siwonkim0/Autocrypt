//
//  ViewModelType.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
