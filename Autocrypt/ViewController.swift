//
//  ViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let networkProvider = NetworkProvider()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkProvider.request(with: EndpointGenerator.fetchVaccinationList(page: "1"))
            .subscribe(onNext: { data in
                print(data)
            })
            .disposed(by: disposeBag)
        view.backgroundColor = .white
    }


}

