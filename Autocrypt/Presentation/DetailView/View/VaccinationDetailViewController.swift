//
//  VaccinationDetailViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

protocol VaccinationDetailViewControllerDelegate: AnyObject {
//    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter)
    func didFinishPresenting()
}

class VaccinationDetailViewController: UIViewController {
    
    private let centerNameView = VaccinationDetailInfoView()
    private let facilityNameView = VaccinationDetailInfoView()
    private let phoneNumberView = VaccinationDetailInfoView()
    private let updatedAtView = VaccinationDetailInfoView()
    private let addressView = VaccinationDetailInfoView()
    
    weak var coordinator: VaccinationDetailViewControllerDelegate?
    private let viewModel: VaccinationDetailViewModel
    
    init(viewModel: VaccinationDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLayout()
        configure(with: viewModel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishPresenting()
    }
    
    //MARK: - Data Binding
    private func configure(with viewModel: VaccinationDetailViewModel) {
        navigationItem.title = viewModel.centerName.description
        centerNameView.configure(with: viewModel.centerName)
        facilityNameView.configure(with: viewModel.facilityName)
        phoneNumberView.configure(with: viewModel.phoneNumber)
        updatedAtView.configure(with: viewModel.updatedAt)
        addressView.configure(with: viewModel.address)
    }
    
    //MARK: - Configure View
    
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
