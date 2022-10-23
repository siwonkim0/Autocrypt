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
    weak var coordinator: VaccinationMapViewControllerDelegate?
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setLayout()
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: .init(latitude: 37.567817, longitude: 127.004501), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        addCustomPin()
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
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
}
