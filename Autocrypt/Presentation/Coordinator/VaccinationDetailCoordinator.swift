//
//  VaccinationDetailCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

protocol VaccinationDetailCoordinatorDelegate: AnyObject {
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter)
    func showMapViewController(at viewController: UIViewController)
    func childDidFinish(_ child: Coordinator)
}

final class VaccinationDetailCoordinator: Coordinator, VaccinationDetailViewControllerDelegate {
    weak var parentCoordinator: VaccinationDetailCoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let model: VaccinationCenter
    
    init(navigationController: UINavigationController, model: VaccinationCenter) {
        self.navigationController = navigationController
        self.model = model
    }
    
    func start() {
        let viewModel = VaccinationDetailViewModel(model: model)
        let detailViewController = VaccinationDetailViewController(viewModel: viewModel)
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: true)
    }

    func didFinishPresenting() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func showMapViewController(at viewController: UIViewController) {
        parentCoordinator?.showMapViewController(at: viewController)
    }
}
