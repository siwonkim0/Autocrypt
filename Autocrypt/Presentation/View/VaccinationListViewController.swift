//
//  VaccinationListViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit
import RxSwift

final class VaccinationListViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: VaccinationListViewModel
    
    let tableView: UITableView = {
        return UITableView()
    }()
    
    init(viewModel: VaccinationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLayout()
        configureBind()
    }

    
    //MARK: - Data Binding
    private func configureBind() {
        let input = VaccinationListViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            loadNextPage: rx.viewWillAppear.asObservable(),
            scrollToTop: rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input)
        
        output.initialResult
            .bind(to: tableView.rx.items(
                cellIdentifier: "VaccinationListTableViewCell",
                cellType: VaccinationListTableViewCell.self)
            ) { index, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
    }
    
    //MARK: - Configure View
    private func setView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setLayout() {
        tableView.registerCell(withClass: VaccinationListTableViewCell.self)
        tableView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.top.equalToSuperview()
        })
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
    }

}

