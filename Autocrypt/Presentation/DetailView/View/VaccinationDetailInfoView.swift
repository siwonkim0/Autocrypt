//
//  VaccinationDetailInfoView.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/22.
//

import UIKit
import SnapKit

class VaccinationDetailInfoView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hospital.png")
        imageView.setContentHuggingPriority(.defaultHigh + 10, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh + 10, for: .vertical)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "병원명"
        label.font = .systemFont(ofSize: 12, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "코로나19 광주광역시 서구 예방접종센터"
        label.font = .systemFont(ofSize: 12, weight: .black)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
    }
    
    private func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(20)
//            make.leading.trailing.equalToSuperview().inset(20).priority(.medium)
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
//            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func configure(with model: VaccinationCenter) {
        titleLabel.text = model.centerName
        descriptionLabel.text = model.address
    }

}
