//
//  VaccinationMapViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import MapKit
import SnapKit
import RxSwift

protocol VaccinationMapViewControllerDelegate: AnyObject {}

class VaccinationMapViewController: UIViewController, MKMapViewDelegate {
    
    private let toCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitle("현재위치로", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false
        return button
    }()
    
    private let toVaccinationCenterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitle("접종센터로", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = false
        return button
    }()
    
    private let mapView = MKMapView()

    weak var coordinator: VaccinationMapViewControllerDelegate?
    private let disposeBag = DisposeBag()
    private let viewModel: VaccinationMapViewModel
    
    init(viewModel: VaccinationMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setLayout()
        configureBind()
    }
    
    private func configureBind() {
        let input = VaccinationMapViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            currentLocationButtonTapped: toCurrentLocationButton.rx.tap.asObservable(),
            vaccinationCenterLocationButtonTapped: toVaccinationCenterButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input)
        
        output.vaccinationCenterLocationCoordinate
            .subscribe(with: self, onNext: { (self, coordinate) in
                guard let coordinate = coordinate else { return }
                self.setLocation(with: coordinate)
                self.addCustomPin(to: coordinate)
            })
            .disposed(by: disposeBag)
        
        output.currentLocationCoordinate
            .skip(1)
            .subscribe(with: self, onNext: { (self, coordinate) in
                guard let coordinate = coordinate else {
                    self.showAllowLocationAlert()
                    return
                }
                self.setLocation(with: coordinate)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAllowLocationAlert() {
        let alert = UIAlertController(title: "해당 기능의 사용을 위해 위치 권한이 필요합니다.", message: "위치 권한 설정의 변경이 불가한 경우, \n먼저 '설정 > 개인 정보 보호 > 위치 서비스'를 켜주세요.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func setLocation(with coordinate: CLLocationCoordinate2D) {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
            animated: true
        )
    }

    private func addCustomPin(to coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "코로나19 중앙 예방접종센터"
        mapView.addAnnotation(pin)
    }
    
    //MARK: - Configure View
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationItem.title = "지도"
    }
    
    private func setLayout() {
        setMapViewLayout()
        setStackViewLayout()
    }
    
    private func setMapViewLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setStackViewLayout() {
        let stackView = UIStackView(arrangedSubviews: [toCurrentLocationButton, toVaccinationCenterButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-80)
            make.height.equalTo(110)
        }
    }
    
}


