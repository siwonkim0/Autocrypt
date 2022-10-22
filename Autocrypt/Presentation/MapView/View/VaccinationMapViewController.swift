//
//  VaccinationMapViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import UIKit

protocol VaccinationMapViewControllerDelegate: AnyObject {
    func didFinishPresenting()
}

class VaccinationMapViewController: UIViewController {
    weak var coordinator: VaccinationMapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishPresenting()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "back"
    }
}
