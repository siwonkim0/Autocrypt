//
//  VaccinationMapCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/23.
//

import UIKit

final class VaccinationMapCoordinator: Coordinator, VaccinationMapViewControllerDelegate {
    weak var parentCoordinator: VaccinationDetailCoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewController = VaccinationMapViewController()
        mapViewController.coordinator = self
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
    func didFinishPresenting() {
        parentCoordinator?.childDidFinish(self)
    }
    
    
}
