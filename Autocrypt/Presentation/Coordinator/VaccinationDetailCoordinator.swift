//
//  VaccinationDetailCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

protocol VaccinationDetailCoordinatorDelegate: AnyObject {
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter)
    func childDidFinish(_ child: Coordinator)
}

final class VaccinationDetailCoordinator: Coordinator, VaccinationDetailViewControllerDelegate {
    weak var parentCoordinator: VaccinationDetailCoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailViewController = VaccinationDetailViewController()
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: true)
    }

    func didFinishPresenting() {
        parentCoordinator?.childDidFinish(self)
    }
}
