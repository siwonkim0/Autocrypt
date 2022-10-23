//
//  AppCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showListViewController()
        navigationController.delegate = self
    }
    
    private func showListViewController() {
        let coordinator = VacinationListCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension AppCoordinator: VaccinationListCoordinatorDelegate {
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter) {
        let coordinator = VaccinationDetailCoordinator(navigationController: navigationController, model: model)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}

extension AppCoordinator : VaccinationDetailCoordinatorDelegate {
    func showMapViewController(at viewController: UIViewController) {
        let coordinator = VaccinationMapCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}

extension AppCoordinator: VaccinationMapViewCoordinatorDelegate { }

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let detailViewController = fromViewController as? VaccinationDetailViewController,
           let detailViewCoordinator = detailViewController.coordinator as? Coordinator {
            childDidFinish(detailViewCoordinator)
        } else if let mapViewController = fromViewController as? VaccinationMapViewController,
                  let mapViewCoordinator = mapViewController.coordinator as? Coordinator {
            childDidFinish(mapViewCoordinator)
        }
    }
}
