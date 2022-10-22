//
//  VaccinationListCoordinator.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit

protocol VaccinationListCoordinatorDelegate: AnyObject {
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter)
}

final class VacinationListCoordinator: Coordinator, VaccinationListViewControllerDelegate {
    weak var parentCoordinator: VaccinationListCoordinatorDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = setViewController()
        setNavigationController(with: viewController)
    }
    
    private func setViewController() -> UIViewController {
        let networkProvider = NetworkProvider()
        let repository = VaccinationRepository(networkProvider: networkProvider)
        let viewModel = VaccinationListViewModel(repository: repository)
        let listViewController = VaccinationListViewController(viewModel: viewModel)
        listViewController.coordinator = self
        return listViewController
    }
    
    private func setNavigationController(with viewController: UIViewController) {
        navigationController.navigationBar.topItem?.title = "예방접종센터 리스트"
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter) {
        parentCoordinator?.showDetailViewController(at: viewController, of: model)
    }
    
}
