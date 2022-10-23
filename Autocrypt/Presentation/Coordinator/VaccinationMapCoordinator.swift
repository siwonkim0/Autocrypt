//
//  VaccinationMapCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import UIKit

protocol VaccinationMapViewCoordinatorDelegate: AnyObject {}

final class VaccinationMapCoordinator: Coordinator, VaccinationMapViewControllerDelegate {
    weak var parentCoordinator: VaccinationMapViewCoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let model: VaccinationCenter
    
    init(navigationController: UINavigationController, model: VaccinationCenter) {
        self.navigationController = navigationController
        self.model = model
    }
    
    func start() {
        let viewModel = VaccinationMapViewModel(model: model)
        let mapViewController = VaccinationMapViewController(viewModel: viewModel)
        mapViewController.coordinator = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
