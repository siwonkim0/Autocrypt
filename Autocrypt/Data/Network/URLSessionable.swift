//
//  URLSessionable.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable {}
