//
//  UILabel+extension.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit

extension UILabel {
    func setTitleLabel(named text: String) -> UILabel {
        self.textColor = .systemGray
        self.text = text
        self.font = .systemFont(ofSize: 12)
        return self
    }
    
    func setDescriptionLabel() -> UILabel {
        self.textColor = .black
        self.font = .systemFont(ofSize: 12)
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return self
    }
    
}
