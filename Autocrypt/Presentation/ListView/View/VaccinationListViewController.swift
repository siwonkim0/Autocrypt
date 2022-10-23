//
//  VaccinationListViewController.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit
import RxSwift

protocol VaccinationListViewControllerDelegate: AnyObject {
    func showDetailViewController(at viewController: UIViewController, of model: VaccinationCenter)
}

final class VaccinationListViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView()
    private let scrollToTopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "top-alignment.png"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    weak var coordinator: VaccinationListViewControllerDelegate?
    private let disposeBag = DisposeBag()
    private let viewModel: VaccinationListViewModel
    
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
            loadNextPage: tableViewContentOffsetChanged(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable()
        )
        let output = viewModel.transform(input)
        
        output.result
            .bind(to: tableView.rx.items(
                cellIdentifier: "VaccinationListTableViewCell",
                cellType: VaccinationListTableViewCell.self)
            ) { index, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
        
        output.canFetchNextPage
            .filter { $0 == nil }
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { (self, nextPage) in
                self.presentAlert(with: "더 이상 결과가 없습니다.")
            })
            .disposed(by: disposeBag)
        
        output.refreshDone
            .skip(1)
            .filter { $0 == false }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { (self, _) in
                self.refreshControl.endRefreshing()
                self.refreshControl.isHidden = true
            })
            .disposed(by: disposeBag)
        
        scrollToTopButton.rx.tap
            .subscribe(with: self, onNext: { (self, _) in
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(VaccinationCenter.self)
            .subscribe(with: self, onNext: { (self, model) in
                self.coordinator?.showDetailViewController(at: self, of: model)
            })
            .disposed(by: disposeBag)
    }
    
    private func tableViewContentOffsetChanged() -> Observable<Void> {
        return tableView.rx.contentOffset
            .withUnretained(self)
            .filter { (self, offset) in
                guard self.tableView.contentSize.height != 0 else {
                    return false
                }
                return self.tableView.frame.height + offset.y + 100 >= self.tableView.contentSize.height
            }
            .map { _ in }
    }
    
    private func presentAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: "\(message)", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    //MARK: - Configure View
    private func setView() {
        navigationController?.navigationBar.topItem?.title = "예방접종센터 리스트"
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(scrollToTopButton)
    }
    
    private func setLayout() {
        setTableViewLayout()
        setButtonLayout()
    }
    
    private func setTableViewLayout() {
        tableView.registerCell(withClass: VaccinationListTableViewCell.self)
        tableView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.top.equalToSuperview()
        })
        tableView.refreshControl = refreshControl
    }
    
    private func setButtonLayout() {
        scrollToTopButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(300)
            make.bottom.equalToSuperview().offset(-50)
            make.width.height.equalTo(55)
        }
    }
    
}

