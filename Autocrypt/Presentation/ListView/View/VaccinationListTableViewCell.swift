//
//  VaccinationListTableViewCell.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit
import SnapKit

final class VaccinationListTableViewCell: UITableViewCell {
    
    private let centerNameTitleLabel = UILabel().setTitleLabel(named: "센터명")
    private let facilityNameTitleLabel = UILabel().setTitleLabel(named: "건물명")
    private let addressTitleLabel = UILabel().setTitleLabel(named: "주소")
    private let updatedAtTitleLabel = UILabel().setTitleLabel(named: "업데이트 시간")
    
    private let centerNameLabel = UILabel().setDescriptionLabel()
    private let facilityNameLabel = UILabel().setDescriptionLabel()
    private let addressLabel = UILabel().setDescriptionLabel()
    private let updatedAtLabel = UILabel().setDescriptionLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: VaccinationCenter) {
        centerNameLabel.text = model.centerName
        facilityNameLabel.text = model.facilityName
        addressLabel.text = model.address
        updatedAtLabel.text = model.updatedAt
    }
    
    private func setLayout() {
        let titleStackView = setTitleStackView()
        let contentStackView = setContentStackView()
        
        let stackViewContainerView = UIStackView(arrangedSubviews: [titleStackView, contentStackView])
        stackViewContainerView.axis = .horizontal
        stackViewContainerView.distribution = .fill
        
        contentView.addSubview(stackViewContainerView)
        
        stackViewContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.bottom.top.equalToSuperview().inset(10)
        }
    }
    
    private func setTitleStackView() -> UIStackView {
        centerNameTitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        facilityNameLabel.setContentHuggingPriority(.defaultLow + 1, for: .vertical)
        addressLabel.setContentHuggingPriority(.defaultLow + 2, for: .vertical)
        updatedAtLabel.setContentHuggingPriority(.defaultLow + 3, for: .vertical)
        
        let titleStackView = UIStackView(arrangedSubviews: [centerNameTitleLabel, facilityNameTitleLabel, addressTitleLabel, updatedAtTitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 5
        titleStackView.distribution = .equalSpacing
        titleStackView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return titleStackView
    }
    
    private func setContentStackView() -> UIStackView {
        let contentStackView = UIStackView(arrangedSubviews: [centerNameLabel, facilityNameLabel, addressLabel, updatedAtLabel])
        contentStackView.axis = .vertical
        contentStackView.spacing = 5
        contentStackView.distribution = .equalSpacing
        
        return contentStackView
    }

}
