//
//  VaccinationDetailViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

class VaccinationDetailViewController: UIViewController {
    
    private let centerNameView = VaccinationDetailInfoView()
    private let facilityNameView = VaccinationDetailInfoView()
    private let phoneNumberView = VaccinationDetailInfoView()
    private let updatedAtView = VaccinationDetailInfoView()
    private let addressView = VaccinationDetailInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLayout()
    }
    
    private func setView() {
        view.backgroundColor = .systemGray3
        view.addSubview(centerNameView)
    }
    
    private func setLayout() {
        view.addSubview(centerNameView)
        let firstStackView = setFirstStackView()
        let secondStackView = setSecondStackView()

        let stackViewContainerView = UIStackView(arrangedSubviews: [firstStackView, secondStackView, addressView])
        stackViewContainerView.axis = .vertical
        stackViewContainerView.distribution = .fillEqually
        stackViewContainerView.spacing = 25

        view.addSubview(stackViewContainerView)
        
        stackViewContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setFirstStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [centerNameView, facilityNameView])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillEqually

        return stackView
    }
    
    private func setSecondStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [phoneNumberView, updatedAtView])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillEqually

        return stackView
    }

}
