//
//  VaccinationMapViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import UIKit
import MapKit
import SnapKit

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
    private let locationManager = CLLocationManager()
    weak var coordinator: VaccinationMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setLayout()
        getUserLocationPermission()
        setInitialLocation()
        addCustomPin()
    }
    
    private func setInitialLocation() {
        mapView.delegate = self
        mapView.setRegion(
            MKCoordinateRegion(
                center: .init(latitude: 37.567817, longitude: 127.004501),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
            animated: true
        )
    }
    
    private func getUserLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func addCustomPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 37.567817, longitude: 127.004501)
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

//MARK: - CoreLocationManager Delegate

extension VaccinationMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .authorized:
            print("GPS 권한 설정됨")
        case .notDetermined, .restricted:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 거부됨")
        default:
            print("GPS: Default")
        }
    }
    
}
