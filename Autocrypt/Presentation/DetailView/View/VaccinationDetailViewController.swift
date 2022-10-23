//
//  VaccinationDetailViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import RxSwift

protocol VaccinationDetailViewControllerDelegate: AnyObject {
    func showMapViewController(at viewController: UIViewController, of model: VaccinationCenter)
}

final class VaccinationDetailViewController: UIViewController {
    
    private let centerNameView = VaccinationDetailInfoView()
    private let facilityNameView = VaccinationDetailInfoView()
    private let phoneNumberView = VaccinationDetailInfoView()
    private let updatedAtView = VaccinationDetailInfoView()
    private let addressView = VaccinationDetailInfoView()
    private let navigationBackButton = UIBarButtonItem(title: "지도", style: .plain, target: VaccinationDetailViewController.self, action: nil)
    
    weak var coordinator: VaccinationDetailViewControllerDelegate?
    private let disposeBag = DisposeBag()
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
        setNavigationBar()
        setLayout()
        configureBind()
    }
    
    //MARK: - Data Binding
    
    private func configureBind() {
        navigationItem.title = viewModel.centerName.description
        centerNameView.configure(with: viewModel.centerName)
        facilityNameView.configure(with: viewModel.facilityName)
        phoneNumberView.configure(with: viewModel.phoneNumber)
        updatedAtView.configure(with: viewModel.updatedAt)
        addressView.configure(with: viewModel.address)
        
        navigationBackButton.rx.tap
            .subscribe(with: self, onNext: { (self, _) in
                self.coordinator?.showMapViewController(at: self, of: self.viewModel.model)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Configure View
    
    private func setView() {
        view.backgroundColor = .systemGray3
        view.addSubview(centerNameView)
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = navigationBackButton
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    @objc private func showMapView() {
        coordinator?.showMapViewController(at: self, of: viewModel.model)
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
