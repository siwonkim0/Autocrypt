//
//  UITableView+extension.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            return T()
        }
        return cell
    }

    func registerCell<T: UITableViewCell>(withClass: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

}
